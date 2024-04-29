from firebase_admin import auth
from google.cloud import firestore


def create_org(
    auth_client: auth.Client,
    db: firestore.Client,
    org_id: str,
    org_name: str,
    email: str,
    name: str,
    password: str=None,
    uid: str=None,
):
    print(f"Info  : create orgs/{org_id} with manager {uid} {email}")

    if uid is None:
        user = auth_client.create_user(email=email, password=password)
        uid = user.uid
    else:
        auth_client.create_user(uid=uid, email=email, password=password)

    org_ref = db.collection("orgs").document(org_id)

    org_ref.set(
        {
            "name": org_name,
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
