from firebase_functions import https_fn
from firebase_admin import (
    initialize_app,
    firestore,
    auth,
)
import os
import sys
from pathlib import Path

# https://github.com/firebase/firebase-functions-python/pull/12
sys.path.insert(0, Path(__file__).parent.as_posix())

from deployment import (
    get_deployment_handle,
    upgrade_data,
    set_ui_version,
)
from test.data import set_test_data

admin = initialize_app()


@https_fn.on_call(
    region="asia-northeast2",
    secrets=["DEPLOYMENT_KEY"],
)
def deployment(
    req: https_fn.CallableRequest,
) -> any:  # pragma: no cover
    if os.environ.get("DEPLOYMENT_KEY") != req.data["DEPLOYMENT_KEY"]:
        print("Error: DEPLOYMENT_KEY")
        return

    firestore_client = firestore.client(admin)
    auth_client = auth.Client(admin)

    if not get_deployment_handle(firestore_client):
        print("Error: get_handle()")
        return

    test = os.environ.get("DEPLOYMENT_KEY") == "test"
    print(f"test: {test}")

    upgrade_data(firestore_client, auth_client, req.data)

    if test:
        set_test_data(firestore_client, auth_client)
    else:
        set_ui_version(firestore_client, os.environ.get("GCLOUD_PROJECT"))
