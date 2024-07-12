from firebase_functions import https_fn
from firebase_admin import (
    initialize_app,
    firestore,
    auth as firebase_auth,
)
import os
from coverage import Coverage

# Before importing local modules
if os.environ.get("DEPLOYMENT_KEY") == "test":
    cov = Coverage(
        data_file=".coverage",
        omit=["main.py", "*_test.py", "test_*.py"],
    )
    cov.start()

from test_utils import test_deploy, run_test
from admin import is_admin, create_site
from deployment import deploy

app = initialize_app()
db = firestore.client(app)
auth = firebase_auth.Client(app)

region = "asia-northeast2"


@https_fn.on_call(
    region=region,
)
def create_site_with_manager(
    req: https_fn.CallableRequest,
) -> bool:
    if is_admin(
        db=db,
        uid=None if req.auth is None else req.auth.uid,
    ):
        return create_site(
            auth=auth,
            db=db,
            site_id=req.data["site_id"],
            site_name=req.data["site_name"],
            manager_email=req.data["email"],
            manager_name=req.data["name"],
            manager_password=req.data["password"],
        )
    return False


@https_fn.on_call(
    region=region,
    secrets=["DEPLOYMENT_KEY"],
)
def deployment(
    req: https_fn.CallableRequest,
):
    if os.environ.get("DEPLOYMENT_KEY") == "test":
        return "error"
    if os.environ.get("DEPLOYMENT_KEY") != req.data["DEPLOYMENT_KEY"]:
        return "error"
    deploy(
        auth=auth,
        db=db,
        project_id=(os.environ.get("GCLOUD_PROJECT") or ""),
        data=req.data,
    )


@https_fn.on_call(
    region=region,
    secrets=["DEPLOYMENT_KEY"],
)
def test_deployment(
    req: https_fn.CallableRequest,
):
    if os.environ.get("DEPLOYMENT_KEY") != "test":
        return "error"
    test_deploy(
        auth=auth,
        db=db,
    )


@https_fn.on_call(
    region=region,
)
def test_functions(
    req: https_fn.CallableRequest,
):
    if os.environ.get("DEPLOYMENT_KEY") != "test":
        return "error"

    res = run_test(
        cov=cov,
        db=db,
        auth=auth,
    )
    return "OK" if res else "NG"
