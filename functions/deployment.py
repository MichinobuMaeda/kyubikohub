from datetime import datetime
import time
from firebase_admin import auth
from google.cloud import firestore
import requests


def get_deployment_handle(
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


def set_ui_version(
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


def create_org(
    auth_client: auth.Client,
    db: firestore.Client,
    org_id: str,
    org_name: str,
    uid: str,
    email: str,
    password: str,
    name: str,
):
    print(f"Info  : create orgs/{org_id} with manager {uid} {email}")

    auth_client.create_user(uid=uid, email=email, password=password)

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

def upgrade_data_v1(
    db: firestore.Client,
    auth_client: auth.Client,
    data: dict,
):
    create_org(
        auth_client,
        db,
        "admins",
        "Administrators",
        data["PRIMARY_USER_ID"],
        data["PRIMARY_USER_EMAIL"],
        data["PRIMARY_USER_PASSWORD"],
        "Primary user",
    )
    create_org(
        auth_client,
        db,
        "test",
        "Test",
        data["TEST_MANAGER_ID"],
        data["TEST_MANAGER_EMAIL"],
        data["TEST_MANAGER_PASSWORD"],
        "Manager",
    )

def set_data_version(conf_ref, ver: int):
    conf_ref.update(
        {
            "dataVersion": ver,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

def upgrade_data(
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
            upgrade_data_v1(db, auth_client, data)
            set_data_version(conf_ref, 1)

    print("End  : upgrade_data")
