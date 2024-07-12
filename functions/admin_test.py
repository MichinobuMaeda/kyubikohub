import unittest
from unittest.mock import patch
from google.cloud import firestore
from firebase_admin import (
    get_app,
    firestore as firestore_client,
    auth as auth_client,
)
from admin import (
    is_admin,
    create_site,
    subscribers_email_count,
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

        # Check
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

        # Check
        assert not ret

    def test_is_admin_without_doc(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})

        # Run
        ret = is_admin(db=self.db, uid="account_id")

        # Check
        assert not ret

    def test_is_admin_without_uid(self):
        # Prepare
        site_ref = self.db.collection("sites").document("admins")
        site_ref.set({"name": "Administrators"})

        # Run
        ret = is_admin(db=self.db, uid=None)

        # Check
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

        # Check
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

        # Check
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

    def test_create_site_with_existing_site_id(self):
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

        # Check
        assert not ret

    def test_subscribers_email_count(self):
        # Prepare
        col_ref = self.db.collection("subscribers")
        col_ref.document("id01").set(
            {
                "site": "site01",
                "email": "01@example.com",
            },
        )
        col_ref.document("id02").set(
            {
                "site": "site02",
                "email": "02@example.com",
                "managerEmail": "01@example.com",
            },
        )
        col_ref.document("id03").set(
            {
                "site": "site03",
                "email": "03@example.com",
                "managerEmail": "01@example.com",
            },
        )
        col_ref.document("id04").set(
            {
                "site": "site04",
                "email": "04@example.com",
                "managerEmail": "02@example.com",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        col_ref.document("id05").set(
            {
                "site": "site05",
                "email": "05@example.com",
                "managerEmail": "02@example.com",
                "rejectedAt": firestore.SERVER_TIMESTAMP,
            },
        )

        # Run
        ret01 = subscribers_email_count(db=self.db, email="01@example.com")
        ret02 = subscribers_email_count(db=self.db, email="02@example.com")

        # Check
        assert ret01 == 3
        assert ret02 == 1

    def test_accept_subscription_without_site_id(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: site"

    def test_accept_subscription_without_name(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: name"

    def test_accept_subscription_without_email(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: email"

    def test_accept_subscription_without_zip(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: zip"

    def test_accept_subscription_without_prefecture(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: prefecture"

    def test_accept_subscription_without_city(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: city"

    def test_accept_subscription_without_address1(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: address1"

    def test_accept_subscription_without_desc(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "required: desc"

    @patch("admin.subscribers_email_count", side_effect=[3])
    def test_accept_subscription_too_many_requests_from_unique_email_address(
        self,
        _,
    ):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "too many requests: test@example.com"

    @patch("admin.subscribers_email_count", side_effect=[2])
    def test_accept_subscription_for_created_site(
        self,
        _,
    ):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="test",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "duplicate: site"

    def test_accept_subscription_for_requested_site(self):
        # Prepare
        self.db.collection("subscribers").add({"site": "site_id"})

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2=None,
            desc="Test description",
            managerName=None,
            managerEmail=None,
        )

        assert ret == "duplicate: site"

    def test_accept_subscription_with_valid_data(self):
        # Prepare

        # Run
        ret = accept_subscription(
            db=self.db,
            site="site_id",
            name="Test name",
            email="test@example.com",
            tel="090-1234-5678",
            zip="123-4567",
            prefecture="Tokyo",
            city="Shinjuku",
            address1="1-2-3 Nishi-Shinjuku",
            address2="Shinjuku building 1F",
            desc="Test description",
            managerName="Manager name",
            managerEmail="manager@example.com",
        )

        assert ret == "ok"
        for sub_ref in (
            self.db.collection("subscribers").where("site", "==", "site_id").stream()
        ):
            doc = sub_ref.to_dict()
            assert doc["site"] == "site_id"
            assert doc["name"] == "Test name"
            assert doc["email"] == "test@example.com"
            assert doc["tel"] == "090-1234-5678"
            assert doc["zip"] == "123-4567"
            assert doc["prefecture"] == "Tokyo"
            assert doc["city"] == "Shinjuku"
            assert doc["address1"] == "1-2-3 Nishi-Shinjuku"
            assert doc["address2"] == "Shinjuku building 1F"
            assert doc["desc"] == "Test description"
            assert doc["managerName"] == "Manager name"
            assert doc["managerEmail"] == "manager@example.com"
            assert doc["createdAt"] is not None
            assert doc["updatedAt"] is not None
