from datetime import datetime
from firebase_admin import auth
from firebase_functions.firestore_fn import Event, DocumentSnapshot
from google.cloud import firestore
import os
import requests


def restore_trigger_doc(
    event: Event[DocumentSnapshot],
):
    print("Start: restoreTriggerDoc")
    ref = event.data.reference
    ref.set(
        {
            "createdAt": firestore.SERVER_TIMESTAMP,
        }
    )
    print(f"restored doc: {ref.path}")
    print("End  : restoreTriggerDoc")


def set_ui_version(
    event: Event[DocumentSnapshot],
):
    print("Start: setUiVersion")
    res = requests.get(
        f"https://{event.project}.web.app/version.json"
        f"?check={datetime.now().timestamp()}"
    )
    if res.status_code == 200:
        ver = res.json()["version"]
        doc = event.data
        if doc.get("uiVersion") != ver:
            doc.reference.update(
                {
                    "uiVersion": ver,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                }
            )
    else:
        print(f"Error: HTTP Status: {res.status_code}")
    print("End  : setUiVersion")


def create_org(
    db: firestore.Client,
    org_id: str,
    org_name: str,
    uid: str,
    email: str,
    password: str,
    name: str,
):
    auth.create_user(uid=uid, email=email, password=password)

    org_ref = db.collection("orgs").document(org_id)

    org_ref.set(
        {
            "name": org_name,
            "accounts": [uid],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    (_, user_doc) = org_ref.collection("users").add(
        {
            "name": name,
            "email": email,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    org_ref.collection("accounts").document(uid).set(
        {
            "user": user_doc.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    org_ref.collection("groups").document("managers").set(
        {
            "name": "Managers",
            "users": [user_doc.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )


def upgrade_data(
    db: firestore.Client,
    auth: auth.Client,
):
    print("Start: upgrade_data")

    conf_ref = db.collection("service").document("conf")
    conf_doc = conf_ref.get()
    cur_ver = 0

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
    print(f"CurVer: {cur_ver}")

    new_ver = 1
    print(f"NewVer: {new_ver}")

    if cur_ver == new_ver:
        pass
    elif cur_ver == 0:
        create_org(
            db,
            "admins",
            "Administrators",
            os.environ.get("PRIMARY_USER_ID"),
            os.environ.get("PRIMARY_USER_EMAIL"),
            os.environ.get("PRIMARY_USER_PASSWORD"),
            "Primary user",
        )
        create_org(
            db,
            "test",
            "Test",
            os.environ.get("TEST_MANAGER_ID"),
            os.environ.get("TEST_MANAGER_EMAIL"),
            os.environ.get("TEST_MANAGER_PASSWORD"),
            "Manager",
        )

        conf_ref.update(
            {
                "dataVersion": new_ver,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    print("End  : upgrade_data")
