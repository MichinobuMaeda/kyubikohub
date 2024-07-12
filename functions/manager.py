from firebase_admin import auth as firebase_auth
from google.cloud import firestore
from utils import is_active_doc, delete_doc, restore_doc


def is_manager(
    db: firestore.Client,
    uid: str,
    site_id: str,
) -> bool:
    site_ref = db.collection("sites").document(site_id)
    site = site_ref.get()
    if is_active_doc(site):
        account = site_ref.collection("accounts").document(uid).get()
        if is_active_doc(account) and "user" in account.to_dict():
            user_id = account.get("user")
            managers = site.reference.collection("groups").document("managers").get()
            return (
                is_active_doc(managers)
                and "users" in managers.to_dict()
                and user_id in managers.get("users")
            )
    return False


def create_user(
    auth: firebase_auth.Client,
    db: firestore.Client,
    uid: str,
    site_id: str,
    name: str,
    email: str | None = None,
    password: str | None = None,
) -> str | None:
    print(f"INFO  : create user {name} {email} on sites/{site_id} by {uid}")

    if is_manager(db=db, uid=uid, site_id=site_id):
        site_ref = db.collection("sites").document(site_id)
        _, user_ref = site_ref.collection("users").add(
            {
                "name": name,
                "email": email,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

        if email is not None and password is not None:
            add_account_to_user(
                auth=auth,
                db=db,
                uid=uid,
                site_id=site_id,
                user_id=user_ref.id,
                email=email,
                password=password,
            )
        return user_ref.id
    return None


def add_account_to_user(
    auth: firebase_auth.Client,
    db: firestore.Client,
    uid: str,
    site_id: str,
    user_id: str,
    email: str,
    password: str,
) -> bool:
    print(f"INFO  : add account {email} to user {user_id} on sites/{site_id} by {uid}")

    if is_manager(db=db, uid=uid, site_id=site_id):
        site_ref = db.collection("sites").document(site_id)
        user_ref = site_ref.collection("users").document(user_id)
        user = user_ref.get()

        if is_active_doc(user):
            try:
                auth_user = auth.get_user_by_email(email=email)
            except firebase_auth.UserNotFoundError:
                auth_user = auth.create_user(email=email, password=password)

            site_ref.collection("accounts").document(auth_user.uid).set(
                {
                    "user": user.id,
                    "createdAt": firestore.SERVER_TIMESTAMP,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                    "deletedAt": None,
                }
            )
            return True
    return False


def disable_accounts_of_user(
    db: firestore.Client,
    uid: str,
    site_id: str,
    user_id: str,
    restore: bool = False,
) -> bool:
    print(f"INFO  : disable accounts of user {user_id} on sites/{site_id} by {uid}")

    if is_manager(db=db, uid=uid, site_id=site_id):
        site_ref = db.collection("sites").document(site_id)
        user_ref = site_ref.collection("users").document(user_id)
        user = user_ref.get()

        if is_active_doc(user):
            for account in (
                site_ref.collection("accounts")
                .where(filter=firestore.FieldFilter("user", "==", user.id))
                .stream()
            ):
                if restore:
                    if not is_active_doc(account):
                        restore_doc(account.reference)
                else:
                    if is_active_doc(account):
                        delete_doc(account.reference)

            user_ref.set(
                {
                    "revokedAt": None if restore else firestore.SERVER_TIMESTAMP,
                }
            )
            return True
    return False


def delete_user(
    db: firestore.Client,
    uid: str,
    site_id: str,
    user_id: str,
) -> bool:
    print(f"INFO  : delete user {user_id} on sites/{site_id} by {uid}")

    if is_manager(db=db, uid=uid, site_id=site_id):
        site_ref = db.collection("sites").document(site_id)
        user_ref = site_ref.collection("users").document(user_id)
        user = user_ref.get()

        for account in (
            site_ref.collection("accounts")
            .where(filter=firestore.FieldFilter("user", "==", user.id))
            .stream()
        ):
            delete_doc(account.reference)

        delete_doc(user_ref)
        return True
    return False
