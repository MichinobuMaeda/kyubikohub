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

from deployment import deploy

admin = initialize_app()


@https_fn.on_call(
    region="asia-northeast2",
    secrets=["DEPLOYMENT_KEY"],
)
def deployment(
    req: https_fn.CallableRequest,
) -> any:  # pragma: no cover
    if os.environ.get("DEPLOYMENT_KEY") == req.data["DEPLOYMENT_KEY"]:
        deploy(
            auth_client=auth.Client(admin),
            db=firestore.client(admin),
            deployment_key=os.environ.get("DEPLOYMENT_KEY"),
            project_id=os.environ.get("GCLOUD_PROJECT"),
            data=req.data
        )
