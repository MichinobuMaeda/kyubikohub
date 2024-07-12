import unittest
from unittest.mock import MagicMock, patch
from google.cloud import firestore
from firebase_admin import (
    get_app,
    firestore as firestore_client,
    auth as auth_client,
)
from manager import (
    is_manager,
    create_user,
    add_account_to_user,
    disable_accounts_of_user,
    delete_user,
)
from test_utils import clear_data, test_deploy
from utils import is_active_doc


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

    def test_is_manager_with_valid_doc(self):
        # Prepare

        # Run
        ret = is_manager(db=self.db, uid="manager_id", site_id="test")

        # Check
        assert ret

    def test_is_manager_with_deleted_doc(self):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        account_ref = site_ref.collection("accounts").document("deleted_id")
        account_ref.set(
            {
                "name": "Deleted",
                "user": "user_deleted",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        user_ref = site_ref.collection("users").document("user_deleted")
        user_ref.set({"name": "Deleted"})
        managers_ref = site_ref.collection("groups").document("managers")
        managers_ref.set({"name": "Managers", "users": ["user_deleted"]})

        # Run
        ret = is_manager(db=self.db, uid="deleted_id", site_id="test")

        # Check
        assert not ret

    def test_is_manager_without_doc(self):
        # Prepare

        # Run
        ret = is_manager(db=self.db, uid="dummy", site_id="test")

        # Check
        assert not ret

    def test_create_user_without_privilege(
        self,
    ):
        # Prepare
        clear_data(db=self.db, auth=self.auth)

        # Run
        user_snap = create_user(
            auth=self.auth,
            db=self.db,
            uid="primary_id",
            site_id="test",
            name="User name",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert user_snap is None

    def test_create_user_with_email_and_password(
        self,
    ):
        # Prepare

        # Run
        user_id = create_user(
            auth=self.auth,
            db=self.db,
            uid="manager_id",
            site_id="test",
            name="User name",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert user_id is not None
        site_ref = self.db.collection("sites").document("test")
        user_snap = site_ref.collection("users").document(user_id).get()
        assert user_snap is not None
        assert user_snap.exists
        assert user_snap.get("name") == "User name"
        assert user_snap.get("email") == "user@example.com"
        assert user_snap.get("createdAt") is not None
        assert user_snap.get("updatedAt") is not None
        auth_ref = self.auth.get_user_by_email(email="user@example.com")
        assert auth_ref is not None
        account_ref = site_ref.collection("accounts").document(auth_ref.uid)
        assert account_ref.get().exists

    @patch("manager.add_account_to_user", side_effect=MagicMock(return_value=True))
    def test_create_user_without_email_and_password(
        self,
        mock_add_account_to_user,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        site_ref.set({"name": "Test"})

        # Run
        user_id = create_user(
            auth=self.auth,
            db=self.db,
            uid="manager_id",
            site_id="test",
            name="User name",
        )

        # Check
        assert user_id is not None
        user_snap = site_ref.collection("users").document(user_id).get()
        assert user_snap is not None
        assert user_snap.exists
        assert user_snap.get("name") == "User name"
        assert "email" not in user_snap.to_dict() or user_snap.get("email") is None
        assert user_snap.get("createdAt") is not None
        assert user_snap.get("updatedAt") is not None

        mock_add_account_to_user.assert_not_called()

    def test_add_account_to_user_without_privilege(
        self,
    ):
        # Prepare

        # Run
        ret = add_account_to_user(
            auth=self.auth,
            db=self.db,
            uid="primary_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert not ret
        self.assertRaises(
            auth_client.UserNotFoundError,
            self.auth.get_user,
            uid="account_id",
        )

    def test_add_account_to_inactive_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_ref = site_ref.collection("users").document("user_id")
        user_ref.set(
            {
                "name": "User",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            },
        )

        # Run
        ret = add_account_to_user(
            auth=self.auth,
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert not ret
        user_snap = user_ref.get()
        assert user_snap.exists
        assert user_snap.get("deletedAt") is not None
        self.assertRaises(
            auth_client.UserNotFoundError,
            self.auth.get_user,
            uid="account_id",
        )

    def test_add_account_with_new_uid_to_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_ref = site_ref.collection("users").document("user_22")
        user_ref.set({"name": "User"})
        user_snap = user_ref.get()

        # Run
        ret = add_account_to_user(
            auth=self.auth,
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id="user_22",
            email="user22@example.com",
            password="test_password",
        )

        # Check
        assert ret
        auth_user = self.auth.get_user_by_email(email="user22@example.com")
        account_ref = site_ref.collection("accounts").document(auth_user.uid)
        account_snap = account_ref.get()

        assert account_snap.get("user") == user_snap.id
        assert (
            "email" not in account_snap.to_dict() or account_snap.get("email") is None
        )
        assert account_snap.get("createdAt") is not None
        assert account_snap.get("updatedAt") is not None

    def test_add_account_with_existing_uid_to_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_id = create_user(
            db=self.db,
            auth=self.auth,
            uid="manager_id",
            site_id="test",
            name="User",
            email="user22@example.com",
            password="test_password",
        )

        # Run
        ret = add_account_to_user(
            auth=self.auth,
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id=user_id,
            email="user23@example.com",
            password="test_password",
        )

        # Check
        assert ret
        auth_user_new = self.auth.get_user_by_email(email="user23@example.com")
        account_ref_new = site_ref.collection("accounts").document(auth_user_new.uid)
        account_snap_new = account_ref_new.get()
        assert account_snap_new.get("user") == user_id

    def test_disable_accounts_of_user_without_privilege(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_ref = site_ref.collection("users").document("user_22")
        user_ref.set({"name": "User"})

        # Run
        ret = disable_accounts_of_user(
            db=self.db,
            uid="primary_id",
            site_id="test",
            user_id="user_22",
            # restore=False,
        )

        # Check
        assert not ret
        user_snap = user_ref.get()
        assert is_active_doc(user_snap)

    def test_disable_accounts_of_inactive_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_ref = site_ref.collection("users").document("user_22")
        user_ref.set(
            {
                "name": "User",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            },
        )

        # Run
        ret = disable_accounts_of_user(
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id="user_22",
            # restore=False,
        )

        # Check
        assert not ret
        user_snap = user_ref.get()
        assert user_snap.get("deletedAt") is not None

    def test_disable_accounts_of_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_id = create_user(
            db=self.db,
            auth=self.auth,
            uid="manager_id",
            site_id="test",
            name="User",
            email="user22@example.com",
            password="test_password",
        )

        # Run
        ret = disable_accounts_of_user(
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id=user_id,
            # restore=False,
        )

        # Check
        assert ret
        user_snap = site_ref.collection("users").document(user_id).get()
        assert user_snap.get("revokedAt") is not None
        auth_user = self.auth.get_user_by_email(email="user22@example.com")
        account_ref = site_ref.collection("accounts").document(auth_user.uid)
        account_snap = account_ref.get()
        assert not is_active_doc(account_snap)

    def test_restore_accounts_of_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_id = create_user(
            db=self.db,
            auth=self.auth,
            uid="manager_id",
            site_id="test",
            name="User",
            email="user22@example.com",
            password="test_password",
        )
        disable_accounts_of_user(
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id=user_id,
            # restore=False,
        )

        # Run
        ret = disable_accounts_of_user(
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id=user_id,
            restore=True,
        )

        # Check
        assert ret
        user_snap = site_ref.collection("users").document(user_id).get()
        assert user_snap.get("revokedAt") is None
        auth_user = self.auth.get_user_by_email(email="user22@example.com")
        account_ref = site_ref.collection("accounts").document(auth_user.uid)
        account_snap = account_ref.get()
        assert is_active_doc(account_snap)

    def test_delete_user_without_privilege(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_id = create_user(
            db=self.db,
            auth=self.auth,
            uid="manager_id",
            site_id="test",
            name="User",
            email="user22@example.com",
            password="test_password",
        )

        # Run
        ret = delete_user(
            db=self.db,
            uid="primary_id",
            site_id="test",
            user_id=user_id,
        )

        # Check
        assert not ret
        user_snap = site_ref.collection("users").document(user_id).get()
        assert is_active_doc(user_snap)

    def test_delete_user(
        self,
    ):
        # Prepare
        site_ref = self.db.collection("sites").document("test")
        user_id = create_user(
            db=self.db,
            auth=self.auth,
            uid="manager_id",
            site_id="test",
            name="User",
            email="user22@example.com",
            password="test_password",
        )

        # Run
        ret = delete_user(
            db=self.db,
            uid="manager_id",
            site_id="test",
            user_id=user_id,
        )

        # Check
        assert ret
        user_snap = site_ref.collection("users").document(user_id).get()
        assert not is_active_doc(user_snap)
