from firebase_admin import auth
from google.cloud import firestore
import conf
from utils import is_active_doc


def is_admin(
    db: firestore.Client,
    uid: str,
) -> bool:
    return is_active_doc(
        db.collection("sites")
        .document("admins")
        .collection("accounts")
        .document(uid)
        .get()
    )


def create_site(
    auth_client: auth.Client,
    db: firestore.Client,
    site_id: str,
    site_name: str,
    email: str,
    name: str,
    password: str = None,
    uid: str = None,
) -> bool:
    print(f"INFO  : create sites/{site_id} with manager {uid} {email}")

    if uid is None:
        auth_user = auth_client.create_user(email=email, password=password)
        uid = auth_user.uid
    else:
        auth_client.create_user(uid=uid, email=email, password=password)

    conf_ref = db.collection("service").document("conf")
    conf_doc = conf_ref.get()

    site_ref = db.collection("sites").document(site_id)

    forGuests = (
        conf_doc.get("forGuests")
        if "forGuests" in conf_doc.to_dict()
        else conf.siteDescForGuests
    )
    forMembers = (
        conf_doc.get("forMembers")
        if "forMembers" in conf_doc.to_dict()
        else conf.siteDescForMembers
    )
    forMangers = (
        conf_doc.get("forMangers")
        if "forMangers" in conf_doc.to_dict()
        else conf.siteDescForMangers
    )

    site_ref.set(
        {
            "name": site_name,
            "forGuests": forGuests,
            "forMembers": forMembers,
            "forMangers": forMangers,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    (_, user) = site_ref.collection("users").add(
        {
            "name": name,
            "email": email,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    site_ref.collection("accounts").document(uid).set(
        {
            "user": user.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    site_ref.collection("groups").document("managers").set(
        {
            "name": conf.managersGroupName,
            "users": [user.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    return True
