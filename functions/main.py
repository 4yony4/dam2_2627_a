# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

import re

import stripe
from firebase_functions import firestore_fn, https_fn
from firebase_functions.options import set_global_options
from firebase_admin import firestore, initialize_app
from firebase_functions.params import SecretParam
import google.cloud.firestore

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)

STRIPE_SECRET_KEY = SecretParam("STRIPE_SECRET_KEY")

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
        metadata={"firebaseUid": req.auth.uid},
    )

    return {"clientSecret": intent.client_secret}
