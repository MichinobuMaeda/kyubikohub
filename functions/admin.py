from firebase_admin import auth
from google.cloud import firestore


def create_site(
    auth_client: auth.Client,
    db: firestore.Client,
    site_id: str,
    site_name: str,
    email: str,
    name: str,
    password: str=None,
    uid: str=None,
):
    print(f"Info  : create sites/{site_id} with manager {uid} {email}")

    if uid is None:
        user = auth_client.create_user(email=email, password=password)
        uid = user.uid
    else:
        auth_client.create_user(uid=uid, email=email, password=password)

    site_ref = db.collection("sites").document(site_id)

    site_ref.set(
        {
            "name": site_name,
            "forGuests": "## はじめての皆さん",
            "forMembers": "## メンバーの皆さん",
            "forMangers": "## サイト管理者の皆さん",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    (_, user_doc) = site_ref.collection("users").add(
        {
            "name": name,
            "email": email,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    site_ref.collection("accounts").document(uid).set(
        {
            "user": user_doc.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    site_ref.collection("groups").document("managers").set(
        {
            "name": "Managers",
            "users": [user_doc.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
