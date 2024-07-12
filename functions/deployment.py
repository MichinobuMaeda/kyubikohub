from datetime import datetime
import time
from firebase_admin import auth as firebase_auth
from google.cloud import firestore
import requests
from admin import create_site
import conf


def _get_deployment_handle(
    db: firestore.Client,
) -> bool:
    print("START : get_deployment_handle")
    doc = db.collection("service").document("deployment").get()
    if doc.exists:
        print("ERROR : service/deployment exists")
        return False
    ts = datetime.now().isoformat()
    doc.reference.set({"ts": ts})
    time.sleep(1)
    doc = doc.reference.get()
    if (not doc.exists) or doc.get("ts") != ts:
        print("ERROR : interrupted")
        return False
    print("END   : get_deployment_handle return True")
    return True


def _set_ui_version(
    db: firestore.Client,
    project_id: str,
):
    print("START : setUiVersion")
    res = requests.get(
        f"https://{project_id}.web.app/version.json"
        f"?check={datetime.now().timestamp()}"
    )
    if res.status_code == 200:
        ver = res.json()["version"]
        doc = db.collection("service").document("conf").get()
        curr = doc.get("uiVersion")
        if curr != ver:
            print(f"INFO  : update uiVersion {curr} to {ver}")
            doc.reference.update(
                {
                    "uiVersion": ver,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                }
            )
        else:
            print("INFO  : skip to update")
    else:
        print(f"ERROR : HTTP Status: {res.status_code}")
    print("END   : setUiVersion")


def _upgrade_data_v1(
    db: firestore.Client,
    auth: firebase_auth.Client,
    data: dict,
):
    create_site(
        auth=auth,
        db=db,
        site_id="admins",
        site_name="Administrators",
        manager_uid=data["PRIMARY_USER_ID"],
        manager_email=data["PRIMARY_USER_EMAIL"],
        manager_password=data["PRIMARY_USER_PASSWORD"],
        manager_name="Primary user",
    )
    create_site(
        auth=auth,
        db=db,
        site_id="test",
        site_name="Test",
        manager_uid=data["TEST_MANAGER_ID"],
        manager_email=data["TEST_MANAGER_EMAIL"],
        manager_password=data["TEST_MANAGER_PASSWORD"],
        manager_name="Manager",
    )


def _upgrade_data_v2(
    db: firestore.Client,
    auth: firebase_auth.Client,
    data: dict,
):
    conf_ref = db.collection("service").document("conf")
    conf_doc = conf_ref.get()

    if "forGuests" not in (conf_doc.to_dict() or {}):
        conf_ref.update(
            {
                "forGuests": conf.siteDescForGuests,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    if "forMembers" not in (conf_doc.to_dict() or {}):
        conf_ref.update(
            {
                "forMembers": conf.siteDescForMembers,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    if "forManagers" not in (conf_doc.to_dict() or {}):
        conf_ref.update(
            {
                "forManagers": conf.siteDescForManagers,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )


def _set_data_version(conf_ref, ver: int):
    conf_ref.update(
        {
            "dataVersion": ver,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )


def upgrade_data(
    db: firestore.Client,
    auth: firebase_auth.Client,
    data: dict,
):
    print("START : upgrade_data")

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
                "desc": "## Privacy policy",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    upgrades = [
        _upgrade_data_v1,
        _upgrade_data_v2,
    ]

    new_ver = 0

    for upgrade in upgrades:
        new_ver = new_ver + 1
        if cur_ver == new_ver:
            print("INFO  : skip to upgrade")
        else:
            print(f"INFO  : upgrade {cur_ver} to {new_ver}")

            if cur_ver < new_ver:
                upgrade(db=db, auth=auth, data=data)
                _set_data_version(conf_ref, new_ver)
                cur_ver = new_ver

    print("END   : upgrade_data")


def deploy(
    db: firestore.Client,
    auth: firebase_auth.Client,
    project_id: str | None,
    data: dict,
):
    if project_id is None:
        print("ERROR : project_id is None")
        return
    if not _get_deployment_handle(db):
        print("ERROR : get_handle()")
        return

    upgrade_data(db=db, auth=auth, data=data)
    _set_ui_version(db=db, project_id=project_id)
