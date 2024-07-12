from google.cloud import firestore
from firebase_admin import auth as firebase_auth

test_param = {
    "DEPLOYMENT_KEY": "test",
    "PRIMARY_USER_ID": "primary_id",
    "PRIMARY_USER_EMAIL": "primary@example.com",
    "PRIMARY_USER_PASSWORD": "password",
    "TEST_MANAGER_ID": "manager_id",
    "TEST_MANAGER_EMAIL": "manager@example.com",
    "TEST_MANAGER_PASSWORD": "password",
}


def set_test_data(
    db: firestore.Client,
    auth: firebase_auth.Client,
):
    print("START : set_test_data")

    db.collection("service").document("conf").update(
        {
            "uiVersion": "for test",
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    test_ref = db.collection("sites").document("test")
    accounts_ref = test_ref.collection("accounts")
    users_ref = test_ref.collection("users")
    groups_ref = test_ref.collection("groups")

    (_, user01_doc) = users_ref.add(
        {
            "name": "User 01",
            "email": "user01@example.com",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    (_, user02_doc) = users_ref.add(
        {
            "name": "User 02",
            "email": "user02@example.com",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    (_, user_d_doc) = users_ref.add(
        {
            "name": "User to be deleted",
            "email": "user_d@example.com",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    groups_ref.document("group01").set(
        {
            "name": "Group 01",
            "users": [user01_doc.id, user02_doc.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    groups_ref.document("group02").set(
        {
            "name": "Group 02",
            "users": [user02_doc.id],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    groups_ref.document("to_delete").set(
        {
            "name": "Group to be deleted",
            "users": [],
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    accounts_ref.document("user01_id").set(
        {
            "user": user01_doc.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    accounts_ref.document("user02_id").set(
        {
            "user": user02_doc.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )
    accounts_ref.document("to_delete").set(
        {
            "user": user_d_doc.id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    auth.create_user(
        uid="user01_id",
        email="user01@example.com",
        password="password",
    )
    auth.create_user(
        uid="user02_id",
        email="user02@example.com",
        password="password",
    )

    db.collection("sites").document("admins").collection("groups").document(
        "to_delete"
    ).set(
        {
            "name": "Group to be deleted",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    db.collection("sites").document("to_delete").set(
        {
            "name": "Org to be deleted",
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    )

    for site in ["admins", "test"]:
        for index in range(1, 5):
            site_ref = db.collection("sites").document(site)
            notices_ref = site_ref.collection("notices")
            notices_ref.add(
                {
                    "title": f"Notice {site} {index}",
                    "message": f"Message Message Message Message {site}.\n" * index,
                    "createdAt": firestore.SERVER_TIMESTAMP,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                }
            )

    print("END   : set_test_data")
