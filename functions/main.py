# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`
import re
import logging
import stripe
import math
from firebase_functions import firestore_fn, https_fn
from firebase_functions.options import set_global_options
from firebase_admin import firestore, initialize_app, messaging
from firebase_functions.params import SecretParam
from google.cloud.firestore_v1.base_query import FieldFilter
import google.cloud.firestore

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)

STRIPE_SECRET_KEY = SecretParam("STRIPE_SECRET_KEY")
STRIPE_WEBHOOK_SECRET = SecretParam("STRIPE_WEBHOOK_SECRET")

initialize_app()
#
#
@https_fn.on_request()
def on_request_example(req: https_fn.Request) -> https_fn.Response:
    return https_fn.Response("Hello world!")

@https_fn.on_request()
def addmessage(req: https_fn.Request) -> https_fn.Response:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Grab the text parameter.
    original = req.args.get("text")
    autor = req.args.get("autor")
    if original is None:
        return https_fn.Response("No text parameter provided", status=400)
    if autor is None:
        return https_fn.Response("No autor parameter provided", status=400)

    firestore_client = firestore.client()

    # Push the new message into Cloud Firestore using the Firebase Admin SDK.
    _, doc_ref = firestore_client.collection("Textos").add({"original": original,"autor":autor})

    # Send back a message that we've successfully written the message
    return https_fn.Response(f"Message with ID {doc_ref.id} added.")


@firestore_fn.on_document_created(document="Textos/{pushId}")
def makeuppercase(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """Listens for new documents to be added to /messages. If the document has
    an "original" field, creates an "uppercase" field containg the contents of
    "original" in upper case."""

    # Get the value of "original" if it exists.
    if event.data is None:
        return
    try:
        original = event.data.get("original")
    except KeyError:
        # No "original" field, so do nothing.
        return

    # Set the "uppercase" field.
    print(f"Uppercasing {event.params['pushId']}: {original}")
    upper = original.upper()
    event.data.reference.update({"uppercase": upper})

@https_fn.on_call(secrets=[STRIPE_SECRET_KEY])
def createPaymentIntent(req: https_fn.CallableRequest) -> dict:

    if req.auth is None:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            message="Debes iniciar sesión para pagar.",
        )

    data = req.data
    if not isinstance(data, dict):
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="Faltan los datos del pago.",
        )

    amount = data.get("amount")
    currency = data.get("currency")

    # Stripe recibe el importe en la unidad mínima: 1250 = 12,50 €.
    # En Android, Firebase puede codificar un int de Dart como Int64Value.
    if isinstance(amount, dict) and amount.get("@type") in (
        "type.googleapis.com/google.protobuf.Int64Value",
        "type.googleapis.com/google.protobuf.UInt64Value",
    ):
        value = amount.get("value")
        if (
            set(amount) == {"@type", "value"}
            and isinstance(value, str)
            and re.fullmatch(r"-?[0-9]{1,9}", value)
        ):
            amount = int(value)

    if isinstance(amount, bool) or not isinstance(amount, int):
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="El importe debe ser un número entero de céntimos.",
        )
    if not 50 <= amount <= 99_999_999:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="El importe debe estar entre 0,50 € y 999.999,99 €.",
        )
    if currency != "eur":
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="La moneda debe ser eur.",
        )

    stripe.api_key = STRIPE_SECRET_KEY.value

    intent = stripe.PaymentIntent.create(
        amount=amount,
        currency="eur",
        automatic_payment_methods={"enabled": True},
        metadata={"profileUid": req.auth.uid},
    )

    return {"clientSecret": intent.client_secret}


@https_fn.on_request(secrets=[STRIPE_WEBHOOK_SECRET, STRIPE_SECRET_KEY])
def stripeWebhook(req: https_fn.Request) -> https_fn.Response:
    if req.method != "POST":
        return https_fn.Response("Método no permitido", status=405)

    signature = req.headers.get("Stripe-Signature")
    if not signature:
        return https_fn.Response("Falta la firma", status=400)

    try:
        # La firma debe comprobarse con el cuerpo original, sin convertirlo a JSON.
        event = stripe.Webhook.construct_event(
            req.data,
            signature,
            STRIPE_WEBHOOK_SECRET.value,
        )
    except (ValueError, stripe.SignatureVerificationError):
        return https_fn.Response("Firma o contenido inválido", status=400)

    tipos_admitidos = {
        "payment_intent.succeeded",
        "payment_intent.payment_failed",
        "payment_intent.processing",
        "payment_intent.canceled",
    }
    if event["type"] not in tipos_admitidos:
        return https_fn.Response("Evento ignorado", status=200)

    intent_id = event["data"]["object"]["id"]

    # Consultamos el estado actual: Stripe puede entregar eventos repetidos
    # o en distinto orden.
    stripe.api_key = STRIPE_SECRET_KEY.value
    try:
        intent = stripe.PaymentIntent.retrieve(intent_id)
    except stripe.StripeError:
        logging.exception("No se pudo consultar PaymentIntent %s", intent_id)
        return https_fn.Response("Error al consultar Stripe", status=503)

    intent_data = intent.to_dict()
    profileUid = (intent_data.get("metadata") or {}).get("profileUid")
    client_secret = intent_data.get("client_secret")

    if not profileUid:
        # Es un PaymentIntent ajeno al flujo de esta app.
        return https_fn.Response("Sin usuario de la app", status=200)

    if not client_secret:
        logging.error("PaymentIntent %s sin client_secret", intent_id)
        return https_fn.Response("No se puede localizar la transacción", status=503)

    transactions = (
        firestore.client()
        .collection("Perfiles")
        .document(profileUid)
        .collection("Transactions")
    )
    docs = list(
        transactions
        .where(filter=FieldFilter("sClientSecret", "==", client_secret))
        .limit(2)
        .stream()
    )

    if len(docs) != 1:
        # Si el documento aún no se ha creado, Stripe reintentará el webhook.
        logging.error(
            "Se encontraron %s transacciones para PaymentIntent %s",
            len(docs),
            intent_id,
        )
        return https_fn.Response("Transacción no localizada de forma única", status=503)

    doc = docs[0]
    cambios = {
        "sEstado": intent["status"],
        "iCents": intent["amount"],
        "sCurrency": intent["currency"],
    }

    # Evita escrituras y avisos repetidos en el listener.
    actual = doc.to_dict() or {}
    if any(actual.get(campo) != valor for campo, valor in cambios.items()):
        doc.reference.update(cambios)

    return https_fn.Response("OK", status=200)


# INICIO ZONA PUSH CON GPS.
#----------------------------------------------------------------------------
#

def distancia_km(lat1, lon1, lat2, lon2):
    """Distancia sobre la superficie terrestre mediante Haversine."""
    radio_tierra = 6371.0088

    lat1 = math.radians(lat1)
    lat2 = math.radians(lat2)
    delta_lat = lat2 - lat1
    delta_lon = math.radians(lon2 - lon1)

    a = (
            math.sin(delta_lat / 2) ** 2
            + math.cos(lat1)
            * math.cos(lat2)
            * math.sin(delta_lon / 2) ** 2
    )

    a = min(1.0, max(0.0, a))
    return radio_tierra * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def leer_numero(datos, campo, minimo, maximo):
    valor = datos.get(campo)

    if (
            isinstance(valor, bool)
            or not isinstance(valor, (int, float))
            or not math.isfinite(valor)
            or not minimo <= valor <= maximo
    ):
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message=f"{campo} debe estar entre {minimo} y {maximo}.",
        )

    return float(valor)

@firestore_fn.on_document_created(document="Perfiles/{perfilID}/Mensajes/{mensajeID}")
def mensajeCreado(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:

    # Get the value of "original" if it exists.
    if event.data is None:
        return
    try:
        datos = event.data.to_dict() or {}
    except KeyError:
        # No "original" field, so do nothing.
        return


    titulo = datos.get("titulo")
    cuerpo = datos.get("cuerpo")

    perfilID=event.params['perfilID']
    mensajeID=event.params['mensajeID']

    perfil = firestore.client().collection("Perfiles").document(perfilID).get()
    posicion = (perfil.to_dict() or {}).get("gpsPosition")

    resultado = pushMensajeRadio(
        latitud=posicion.latitude,
        longitud=posicion.longitude,
        radio=10,
        titulo=titulo.strip(),
        mensaje=cuerpo.strip(),
        excluir_emisor=False,
    )



@https_fn.on_call(region="us-central1", timeout_sec=120)
def enviarPushEnRadio(req: https_fn.CallableRequest) -> dict:
    if req.auth is None:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            message="Debes iniciar sesión.",
        )

    datos = req.data
    if not isinstance(datos, dict):
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="Debes enviar un objeto con los parámetros.",
        )

    latitud = leer_numero(datos, "lat", -90, 90)
    longitud = leer_numero(datos, "lon", -180, 180)

    # Límite de ejemplo: puedes ajustarlo.
    radio = leer_numero(datos, "radioKm", 0.001, 100)

    titulo = datos.get("titulo")
    mensaje = datos.get("mensaje")
    excluir_emisor = datos.get("excluirEmisor", True)

    pushMensajeRadio(latitud,longitud,radio,titulo,mensaje,excluir_emisor)

def pushMensajeRadio(latitud,longitud,radio,titulo,mensaje,excluir_emisor):
    # Requiere que el usuario haya iniciado sesión en Firebase Auth.


    if (
            not isinstance(titulo, str)
            or not titulo.strip()
            or len(titulo) > 100
            or not isinstance(mensaje, str)
            or not mensaje.strip()
            or len(mensaje) > 1000
            or not isinstance(excluir_emisor, bool)
    ):
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message=(
                "titulo: 1-100 caracteres; mensaje: 1-1000 caracteres; "
                "excluirEmisor: booleano."
            ),
        )

    db = firestore.client()

    # Solo recuperamos los dos campos que necesitamos.
    perfiles = (
        db.collection("Perfiles")
        .select(["gpsPosition", "sTokenMovil"])
        .stream()
    )

    tokens = set()
    perfiles_en_radio = 0

    for documento in perfiles:
        if excluir_emisor and documento.id == req.auth.uid:
            continue

        perfil = documento.to_dict() or {}
        posicion = perfil.get("gpsPosition")

        if not isinstance(posicion, firestore.GeoPoint):
            continue

        distancia = distancia_km(
            latitud,
            longitud,
            posicion.latitude,
            posicion.longitude,
        )

        if distancia > radio:
            continue

        perfiles_en_radio += 1
        token = perfil.get("sTokenMovil")

        if isinstance(token, str) and token.strip():
            tokens.add(token.strip())

    lista_tokens = sorted(tokens)
    aceptadas_fcm = 0
    fallidas = 0

    # FCM admite hasta 500 tokens por llamada multicast.
    for inicio in range(0, len(lista_tokens), 500):
        lote = lista_tokens[inicio:inicio + 500]

        push = messaging.MulticastMessage(
            tokens=lote,
            notification=messaging.Notification(
                title=titulo.strip(),
                body=mensaje.strip(),
            ),
            # En FCM, todos los valores de data deben ser strings.
            data={
                "tipo": "aviso_cercania",
                "lat": str(latitud),
                "lon": str(longitud),
                "radioKm": str(radio),
            },
        )

        try:
            resultado = messaging.send_each_for_multicast(push)
        except Exception:
            logging.exception("No se pudo completar un lote de notificaciones")
            raise https_fn.HttpsError(
                code=https_fn.FunctionsErrorCode.INTERNAL,
                message=(
                    "No se pudo completar el envío. "
                    "Puede haber notificaciones ya aceptadas; "
                    "reintentar podría duplicarlas."
                ),
            )

        aceptadas_fcm += resultado.success_count
        fallidas += resultado.failure_count

        for respuesta in resultado.responses:
            if not respuesta.success:
                # Registramos el tipo de error sin exponer tokens.
                logging.warning(
                    "Error individual de FCM: %s",
                    type(respuesta.exception).__name__,
                )

    return {
        "perfilesEnRadio": perfiles_en_radio,
        "dispositivosConToken": len(lista_tokens),
        "aceptadasFCM": aceptadas_fcm,
        "fallidas": fallidas,
    }

# FIN ZONA PUSH CON GPS.
#----------------------------------------------------------------------------
#