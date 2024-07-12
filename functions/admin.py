from firebase_admin import auth as firebase_auth
from google.cloud import firestore
import conf
from utils import is_active_doc


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


def subscribers_email_count(
    db: firestore.Client,
    email: str,
) -> int:
    return (
        sum(
            1
            for _ in filter(
                lambda x: (
                    "deletedAt" not in (x.to_dict() or {}) or x.get("deletedAt") is None
                )
                and (
                    "rejectedAt" not in (x.to_dict() or {})
                    or x.get("rejectedAt") is None
                ),
                db.collection("subscribers")
                .where(filter=firestore.FieldFilter("email", "==", email))
                .get(),
            )
        )
    ) + (
        sum(
            1
            for _ in filter(
                lambda x: (
                    "deletedAt" not in (x.to_dict() or {}) or x.get("deletedAt") is None
                )
                and (
                    "rejectedAt" not in (x.to_dict() or {})
                    or x.get("rejectedAt") is None
                )
                and ("email" not in (x.to_dict() or {}) or x.get("email") != email),
                db.collection("subscribers")
                .where(filter=firestore.FieldFilter("managerEmail", "==", email))
                .get(),
            )
        )
    )


def accept_subscription(
    db: firestore.Client,
    site: str,
    name: str,
    email: str,
    tel: str | None,
    zip: str,
    prefecture: str,
    city: str,
    address1: str,
    address2: str | None,
    desc: str,
    managerName: str | None,
    managerEmail: str | None,
) -> str:
    print(f"INFO  : accept_subscription site:{site} email:{email}")

    if site is None or len(site) == 0:
        print("ERROR : site is empty")
        return "required: site"

    if name is None or len(name) == 0:
        print("ERROR : name is empty")
        return "required: name"

    if email is None or len(email) == 0:
        print("ERROR : email is empty")
        return "required: email"

    if zip is None or len(zip) == 0:
        print("ERROR : zip is empty")
        return "required: zip"

    if prefecture is None or len(prefecture) == 0:
        print("ERROR : prefecture is empty")
        return "required: prefecture"

    if city is None or len(city) == 0:
        print("ERROR : city is empty")
        return "required: city"

    if address1 is None or len(address1) == 0:
        print("ERROR : address1 is empty")
        return "required: address1"

    if desc is None or len(desc) == 0:
        print("ERROR : desc is empty")
        return "required: desc"

    emailCount = subscribers_email_count(db, email)
    if emailCount >= 3:
        print(f"ERROR : emailCount: too many requests from {email}")
        return f"too many requests: {email}"

    if db.collection("sites").document(site).get().exists:
        print(f"ERROR : {site} has already been created")
        return "duplicate: site"

    if (
        len(
            db.collection("subscribers")
            .where(filter=firestore.FieldFilter("site", "==", site))
            .get()
        )
        > 0
    ):
        print(f"ERROR : {site} has already been requested")
        return "duplicate: site"

    db.collection("subscribers").add(
        {
            "site": site,
            "name": name,
            "email": email,
            "tel": tel,
            "zip": zip,
            "prefecture": prefecture,
            "city": city,
            "address1": address1,
            "address2": address2,
            "desc": desc,
            "managerName": managerName,
            "managerEmail": managerEmail,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    return "ok"
