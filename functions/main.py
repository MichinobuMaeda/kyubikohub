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

from admin import is_admin, create_site
from deployment import deploy

app = initialize_app()

region = "asia-northeast2"


@https_fn.on_call(
    region=region,
)
def create_site_with_manager(
    req: https_fn.CallableRequest,
) -> any:  # pragma: no cover
    if is_admin(db=firestore.client(app), uid=req.auth.uid):
        return create_site(
            auth_client=auth.Client(app),
            db=firestore.client(app),
            site_id=req.data["site_id"],
            site_name=req.data["site_name"],
            email=req.data["email"],
            name=req.data["name"],
            password=req.data["password"],
        )
    return False


@https_fn.on_call(
    region=region,
    secrets=["DEPLOYMENT_KEY"],
)
def deployment(
    req: https_fn.CallableRequest,
) -> any:  # pragma: no cover
    if os.environ.get("DEPLOYMENT_KEY") == req.data["DEPLOYMENT_KEY"]:
        deploy(
            auth_client=auth.Client(app),
            db=firestore.client(app),
            deployment_key=os.environ.get("DEPLOYMENT_KEY"),
            project_id=os.environ.get("GCLOUD_PROJECT"),
            data=req.data,
        )
