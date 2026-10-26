# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import firestore_fn, https_fn
from firebase_functions.options import set_global_options
from firebase_admin import firestore, initialize_app
import google.cloud.firestore
# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)

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

@https_fn.on_request()
def createPaymentIntent(req: https_fn.Request) -> https_fn.Response:
    # Grab the amount parameter.

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


    if amount is None:
        return https_fn.Response("No amount parameter provided", status=400)
    if currency is None:
        return https_fn.Response("No currency parameter provided", status=400)

    firestore_client = firestore.client()

    # Push the new message into Cloud Firestore using the Firebase Admin SDK.
    _, doc_ref = firestore_client.collection("Textos").add({"original": original,"autor":autor})

    # Send back a message that we've successfully written the message
    return https_fn.Response(f"Message with ID {doc_ref.id} added.")