from datetime import datetime
import time
from firebase_admin import auth
from google.cloud import firestore
import requests
from admin import create_org
from test.data import set_test_data


def _get_deployment_handle(
    db: firestore.Client,
) -> bool:
    print("Start: get_deployment_handle")
    doc = db.collection("service").document("deployment").get()
    if doc.exists:
        print("Error: service/deployment exists")
        return False
    ts = datetime.now().isoformat()
    doc.reference.set({"ts": ts})
    time.sleep(1)
    doc = doc.reference.get()
    if (not doc.exists) or doc.get("ts") != ts:
        print("Error: interrupted")
        return False
    print("End  : get_deployment_handle return True")
    return True


def _set_ui_version(
    db: firestore.Client,
    project: str,
):
    print("Start: setUiVersion")
    res = requests.get(
        f"https://{project}.web.app/version.json" f"?check={datetime.now().timestamp()}"
    )
    if res.status_code == 200:
        ver = res.json()["version"]
        doc = db.collection("service").document("conf").get()
        curr = doc.get("uiVersion")
        if curr != ver:
            print(f"Info  : update uiVersion {curr} to {ver}")
            doc.reference.update(
                {
                    "uiVersion": ver,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                }
            )
        else:
            print("Info  : skip to update")
    else:
        print(f"Error: HTTP Status: {res.status_code}")
    print("End  : setUiVersion")


def _upgrade_data_v1(
    db: firestore.Client,
    auth_client: auth.Client,
    data: dict,
):
    create_org(
        auth_client=auth_client,
        db=db,
        org_id="admins",
        org_name="Administrators",
        uid=data["PRIMARY_USER_ID"],
        email=data["PRIMARY_USER_EMAIL"],
        password=data["PRIMARY_USER_PASSWORD"],
        name="Primary user",
    )
    create_org(
        auth_client=auth_client,
        db=db,
        org_id="test",
        org_name="Test",
        uid=data["TEST_MANAGER_ID"],
        email=data["TEST_MANAGER_EMAIL"],
        password=data["TEST_MANAGER_PASSWORD"],
        name="Manager",
    )


def _set_data_version(conf_ref, ver: int):
    conf_ref.update(
        {
            "dataVersion": ver,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )


def _upgrade_data(
    db: firestore.Client,
    auth_client: auth.Client,
    data: dict,
):
    print("Start: upgrade_data")

    cur_ver = 0
    conf_ref = db.collection("service").document("conf")
    conf_doc = conf_ref.get()

    if conf_doc.exists:
        cur_ver = conf_doc.get("dataVersion")
    else:
        conf_ref.set(
            {
                "dataVersion": 0,
                "uiVersion": "",
                "policy": "## Privacy policy",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    new_ver = 1

    if cur_ver == new_ver:
        print("Info  : skip to upgrade")
    else:
        print(f"Info  : upgrade {cur_ver} to {new_ver}")

        if cur_ver < 1:
            _upgrade_data_v1(db=db, auth_client=auth_client, data=data)
            _set_data_version(conf_ref, 1)

    print("End  : upgrade_data")

def deploy(
    db: firestore.Client,
    auth_client: auth.Client,
    deployment_key: str,
    project_id: str,
    data: dict,
):
    if not _get_deployment_handle(db):
        print("Error: get_handle()")
        return

    test = deployment_key == "test"
    print(f"test: {test}")

    _upgrade_data(db=db, auth_client=auth_client, data=data)

    if test:
        set_test_data(db=db, auth_client=auth_client)
    else:
        _set_ui_version(db=db, project_id=project_id)
