import unittest
import unittest.mock
from google.cloud import firestore
from firebase_admin import (
    get_app,
    firestore as firestore_client,
    auth as auth_client,
)
from admin import (
    is_admin,
    create_site,
    accept_subscription,
)
import conf
from test_utils import clear_data, test_deploy


class TestMain(unittest.TestCase):
    def setUp(self):
        app = get_app()
        self.db = firestore_client.client(app)
        self.auth = auth_client.Client(app)
        print(f"START : -------- {__name__} --------")

    def tearDown(self):
        print(f"END   : -------- {__name__} --------")
        clear_data(db=self.db, auth=self.auth)
        test_deploy(db=self.db, auth=self.auth)

    def test_is_admin_with_valid_doc(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})
        account_ref = site_ref.collection("accounts").document("account_id")
        account_ref.set({"name": "Admin user"})

        # Run
        ret = is_admin(db=self.db, uid="account_id")

        # Evaluate
        assert ret

    def test_is_admin_with_deleted_doc(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})
        account_ref = site_ref.collection("accounts").document("account_id")
        account_ref.set(
            {
                "name": "Admin user",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            }
        )

        # Run
        ret = is_admin(db=self.db, uid="account_id")

        # Evaluate
        assert not ret

    def test_is_admin_without_doc(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})

        # Run
        ret = is_admin(db=self.db, uid="account_id")

        # Evaluate
        assert not ret

    def test_is_admin_without_uid(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})

        # Run
        ret = is_admin(db=self.db, uid=None)

        # Evaluate
        assert not ret

    def test_create_site_with_uid(self):
        # Prepare

        # Run
        ret = create_site(
            auth=self.auth,
            db=self.db,
            site_id="site_11",
            site_name="Org Name",
            manager_name="User name",
            manager_uid="account_id",
            manager_email="user11@example.com",
            manager_password="testpassword",
        )

        # Evaluate
        assert ret

        auth_user = self.auth.get_user(uid="account_id")
        assert auth_user.email == "user11@example.com"

        site = self.db.collection("sites").document("site_11").get()
        assert site.exists
        assert site.get("name") == "Org Name"
        assert site.get("forGuests") == conf.siteDescForGuests
        assert site.get("forMembers") == conf.siteDescForMembers
        assert site.get("forManagers") == conf.siteDescForManagers
        assert site.get("createdAt") is not None
        assert site.get("updatedAt") is not None

        account = site.reference.collection("accounts").document("account_id").get()
        assert account.exists
        assert account.get("createdAt") is not None
        assert account.get("updatedAt") is not None
        user_id = account.get("user")

        user = site.reference.collection("users").document(user_id).get()
        assert user.exists
        assert user.get("name") == "User name"
        assert user.get("email") == "user11@example.com"
        assert user.get("createdAt") is not None
        assert user.get("updatedAt") is not None

        managers = site.reference.collection("groups").document("managers").get()
        assert managers.exists
        assert managers.get("name") == conf.managersGroupName
        assert managers.get("users") == [user_id]
        assert managers.get("createdAt") is not None
        assert managers.get("updatedAt") is not None

    def test_create_site_without_uid(self):
        # Prepare

        # Run
        ret = create_site(
            auth=self.auth,
            db=self.db,
            site_id="site_12",
            site_name="Org Name",
            manager_email="user12@example.com",
            manager_password="testpassword",
            manager_name="User name",
        )

        # Evaluate
        assert ret

        auth_user = self.auth.get_user_by_email(email="user12@example.com")
        assert auth_user.email == "user12@example.com"
        uid = auth_user.uid

        site = self.db.collection("sites").document("site_12").get()
        assert site.exists
        assert site.get("name") == "Org Name"
        assert site.get("forGuests") == conf.siteDescForGuests
        assert site.get("forMembers") == conf.siteDescForMembers
        assert site.get("forManagers") == conf.siteDescForManagers
        assert site.get("createdAt") is not None
        assert site.get("updatedAt") is not None

        account = site.reference.collection("accounts").document(uid).get()
        assert account.exists
        assert account.get("createdAt") is not None
        assert account.get("updatedAt") is not None
        user_id = account.get("user")

        user = site.reference.collection("users").document(user_id).get()
        assert user.exists
        assert user.get("name") == "User name"
        assert user.get("email") == "user12@example.com"
        assert user.get("createdAt") is not None
        assert user.get("updatedAt") is not None

        managers = site.reference.collection("groups").document("managers").get()
        assert managers.exists
        assert managers.get("name") == conf.managersGroupName
        assert managers.get("users") == [user_id]
        assert managers.get("createdAt") is not None
        assert managers.get("updatedAt") is not None

    def test_create_site_with_existing_site01(self):
        # Prepare

        # Run
        ret = create_site(
            auth=self.auth,
            db=self.db,
            site_id="test",
            site_name="Dummy",
            manager_name="Dummy",
            manager_uid="dummy_id",
            manager_email="dummy@example.com",
            manager_password="dummy_password",
        )

        # Evaluate
        assert not ret

    subscription = {
        "siteId": "site01",
        "siteName": "Site name",
        "name": "Name",
        "email": "test@example.com",
        "tel": "090-1234-5678",
        "zip": "123-4567",
        "pref": "Tokyo",
        "city": "Shinjuku",
        "addr": "1-2-3 Nishi-Shinjuku",
        "bldg": "Shinjuku bldg. 1F",
        "desc": "t" * 200,
    }

    def test_accept_subscription_without_site_id(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": None,
            },
        )

        # Evaluate
        assert err == "required: siteId"
        assert ret is None

    def test_accept_subscription_without_site_name(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteName": None,
            },
        )

        # Evaluate
        assert err == "required: siteName"
        assert ret is None

    def test_accept_subscription_without_name(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "name": None,
            },
        )

        # Evaluate
        assert err == "required: name"
        assert ret is None

    def test_accept_subscription_without_email(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "email": None,
            },
        )

        # Evaluate
        assert err == "required: email"
        assert ret is None

    def test_accept_subscription_without_zip(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "zip": None,
            },
        )

        # Evaluate
        assert err == "required: zip"
        assert ret is None

    def test_accept_subscription_without_pref(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "pref": None,
            },
        )

        # Evaluate
        assert err == "required: pref"
        assert ret is None

    def test_accept_subscription_without_city(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "city": None,
            },
        )

        # Evaluate
        assert err == "required: city"
        assert ret is None

    def test_accept_subscription_without_addr(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "addr": None,
            },
        )

        # Evaluate
        assert err == "required: addr"
        assert ret is None

    def test_accept_subscription_without_desc(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "desc": None,
            },
        )

        # Evaluate
        assert err == "required: desc"
        assert ret is None

    def test_accept_subscription_with_invalid_site_id(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": "Site01",
            },
        )

        # Evaluate
        assert err == "invalid: siteId"
        assert ret is None

    def test_accept_subscription_with_invalid_email(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "email": "test",
            },
        )

        # Evaluate
        assert err == "invalid: email"
        assert ret is None

    def test_accept_subscription_with_invalid_tel(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "tel": "123@456789",
            },
        )

        # Evaluate
        assert err == "invalid: tel"
        assert ret is None

    def test_accept_subscription_with_invalid_zip(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "zip": "123@4567",
            },
        )

        # Evaluate
        assert err == "invalid: zip"
        assert ret is None

    def test_accept_subscription_with_short_desc(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "desc": "t" * 199,
            },
        )

        # Evaluate
        assert err == "too short: desc"
        assert ret is None

    def test_accept_subscription_with_registered_site_id(self):
        # Prepare
        self.db.collection("sites").document("site09").set({"name": "Site name"})

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": "site09",
            },
        )

        # Evaluate
        assert err == "duplicated: siteId"
        assert ret is None

    def test_accept_subscription_with_requested_site_id(self):
        # Prepare
        self.db.collection("subscribers").add(
            {
                "siteId": "site08",
                "siteName": "Site name",
            }
        )

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": "site08",
            },
        )

        # Evaluate
        assert err == "duplicated: siteId"
        assert ret is None

    def test_accept_subscription_with_requested_x2_email(self):
        # Prepare
        self.db.collection("subscribers").add(
            {
                "siteId": "site07a",
                "siteName": "Site name",
                "email": "test07@example.com",
            }
        )
        self.db.collection("subscribers").add(
            {
                "siteId": "site07b",
                "siteName": "Site name",
                "email": "test07@example.com",
            }
        )

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": "site07c",
                "email": "test07@example.com",
            },
        )

        # Evaluate
        assert err is None
        assert ret is not None

    def test_accept_subscription_with_requested_x3_email(self):
        # Prepare
        self.db.collection("subscribers").add(
            {
                "siteId": "site06a",
                "siteName": "Site name",
                "email": "test06@example.com",
            }
        )
        self.db.collection("subscribers").add(
            {
                "siteId": "site06b",
                "siteName": "Site name",
                "email": "test06@example.com",
            }
        )
        self.db.collection("subscribers").add(
            {
                "siteId": "site06c",
                "siteName": "Site name",
                "email": "test06@example.com",
            }
        )

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "siteId": "site06d",
                "email": "test06@example.com",
            },
        )

        # Evaluate
        assert err == "too many request from: email"
        assert ret is None

    def test_accept_subscription_with_exception(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=None,
            data={
                **self.subscription,
            },
        )

        # Evaluate
        assert err == "unknown"
        assert ret is None

    def test_accept_subscription_with_valid_data(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
            },
        )

        # Evaluate
        assert err is None
        assert ret is not None
        snap = self.db.collection("subscribers").document(ret).get()
        doc = snap.to_dict()
        assert doc["siteId"] == "site01"
        assert doc["siteName"] == "Site name"
        assert doc["name"] == "Name"
        assert doc["email"] == "test@example.com"
        assert doc["tel"] == "090-1234-5678"
        assert doc["zip"] == "123-4567"
        assert doc["pref"] == "Tokyo"
        assert doc["city"] == "Shinjuku"
        assert doc["addr"] == "1-2-3 Nishi-Shinjuku"
        assert doc["bldg"] == "Shinjuku bldg. 1F"
        assert doc["desc"] == "t" * 200
        assert doc["createdAt"] is not None
        assert doc["updatedAt"] is not None

    def test_accept_subscription_without_optional_data(self):
        # Prepare

        # Run
        (err, ret) = accept_subscription(
            db=self.db,
            data={
                **self.subscription,
                "tel": "",
                "bldg": "",
            },
        )

        # Evaluate
        assert err is None
        assert ret is not None
        snap = self.db.collection("subscribers").document(ret).get()
        doc = snap.to_dict()
        assert doc["siteId"] == "site01"
        assert doc["siteName"] == "Site name"
        assert doc["name"] == "Name"
        assert doc["email"] == "test@example.com"
        assert doc["tel"] == ""
        assert doc["zip"] == "123-4567"
        assert doc["pref"] == "Tokyo"
        assert doc["city"] == "Shinjuku"
        assert doc["addr"] == "1-2-3 Nishi-Shinjuku"
        assert doc["bldg"] == ""
        assert doc["desc"] == "t" * 200
        assert doc["createdAt"] is not None
        assert doc["updatedAt"] is not None
