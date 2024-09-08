from firebase_admin import auth as firebase_auth
from google.cloud import firestore
import conf
from utils import (
    is_lower_cases_and_numerics,
    is_email_format,
    is_zip_format,
    is_tel_format,
    has_string_value_of_key,
    is_active_doc,
)


def is_admin(
    db: firestore.Client,
    uid: str | None,
) -> bool:
    if uid is None:
        return False
    else:
        site_ref = db.collection("sites").document("admins")
        doc_ref = site_ref.collection("accounts").document(uid)
        return is_active_doc(doc_ref.get())


def create_site(
    auth: firebase_auth.Client,
    db: firestore.Client,
    site_id: str,
    site_name: str,
    manager_name: str,
    manager_email: str,
    manager_password: str,
    manager_uid: str | None = None,
) -> bool:
    print(f"INFO  : create sites/{site_id} with manager {manager_uid} {manager_email}")

    site_ref = db.collection("sites").document(site_id)

    if site_ref.get().exists:
        return False

    conf_ref = db.collection("service").document("conf")
    conf_doc = conf_ref.get()

    forGuests = (
        conf_doc.get("forGuests")
        if "forGuests" in (conf_doc.to_dict() or {})
        else conf.siteDescForGuests
    )
    forMembers = (
        conf_doc.get("forMembers")
        if "forMembers" in (conf_doc.to_dict() or {})
        else conf.siteDescForMembers
    )
    forManagers = (
        conf_doc.get("forManagers")
        if "forManagers" in (conf_doc.to_dict() or {})
        else conf.siteDescForManagers
    )

    site_ref.set(
        {
            "name": site_name,
            "forGuests": forGuests,
            "forMembers": forMembers,
            "forManagers": forManagers,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    _, user_ref = site_ref.collection("users").add(
        {
            "name": manager_name,
            "email": manager_email,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    site_ref.collection("groups").document("managers").set(
        {
            "name": conf.managersGroupName,
            "users": [user_ref.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    try:
        auth_user = auth.get_user_by_email(
            email=manager_email,
        )
    except firebase_auth.UserNotFoundError:
        if manager_uid is None:
            auth_user = auth.create_user(
                email=manager_email,
                password=manager_password,
            )
        else:
            auth_user = auth.create_user(
                uid=manager_uid,
                email=manager_email,
                password=manager_password,
            )

    site_ref.collection("accounts").document(auth_user.uid).set(
        {
            "user": user_ref.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
            "deletedAt": None,
        }
    )

    return True


# Return the new subscriber ID
def accept_subscription(
    db: firestore.Client,
    data: dict,
) -> tuple[str | None, str | None]:
    try:
        for key in (
            "siteId",
            "siteName",
            "name",
            "email",
            "zip",
            "pref",
            "city",
            "addr",
            "desc",
        ):
            if not has_string_value_of_key(data, key):
                print(f"ERROR : {key} is empty")
                return (f"required: {key}", None)

        if not is_lower_cases_and_numerics(data["siteId"]):
            print(f"ERROR : {data['siteId']} is invalid")
            return ("invalid: siteId", None)

        if not is_email_format(data["email"]):
            print(f"ERROR : {data['email']} is invalid")
            return ("invalid: email", None)

        if has_string_value_of_key(data, "tel") and not is_tel_format(data["tel"]):
            print(f"ERROR : {data['tel']} is invalid")
            return ("invalid: tel", None)

        if not is_zip_format(data["zip"]):
            print(f"ERROR : {data['zip']} is invalid")
            return ("invalid: zip", None)

        if len(data["desc"]) < 200:
            print(f"ERROR : {data['desc']} is too short")
            return ("too short: desc", None)

        if db.collection("sites").document(data["siteId"]).get().exists:
            print(f"ERROR : {data['siteId']} has already been created")
            return ("duplicated: siteId", None)

        if (
            len(
                db.collection("subscribers")
                .where(filter=firestore.FieldFilter("siteId", "==", data["siteId"]))
                .get()
            )
            > 0
        ):
            print(f"ERROR : {data['siteId']} has already been requested")
            return ("duplicated: siteId", None)

        if (
            len(
                db.collection("subscribers")
                .where(filter=firestore.FieldFilter("email", "==", data["email"]))
                .get()
            )
            > 2
        ):
            print(f"ERROR : {data['email']} has already been requested")
            return ("too many request from: email", None)

        (_, ref) = db.collection("subscribers").add(
            {
                **data,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        return (None, ref.id)
    except Exception as e:
        print(f"ERROR : {e}")
        return ("unknown", None)
