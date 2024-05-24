import unittest
from unittest.mock import MagicMock, patch, call
from google.cloud import firestore
from firebase_admin import auth
from datetime import datetime
from manager import (
    is_manager,
    create_user,
    add_account_to_user,
    disable_accounts_of_user,
    delete_user,
)
import conf
from .utils import MockDb, MockDocSnap, MockAuth, MockUserRecord, MockQuery


class TestMain(unittest.TestCase):
    def test_is_manager_with_valid_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        site_snap.reference.set_doc(
            "accounts", "account_id", {"name": "Manager", "user": "user_id"}
        )
        site_snap.reference.set_doc(
            "groups", "managers", {"name": "Managers", "users": ["user_id"]}
        )

        # Run
        ret = is_manager(db=db, uid="account_id", site_id="test")

        # Check
        assert ret

    def test_is_manager_with_deleted_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        site_snap.reference.set_doc(
            "accounts",
            "account_id",
            {
                "name": "Manager",
                "user": "user_id",
                "deletedAt": datetime.now(),
            },
        )
        site_snap.reference.set_doc(
            "groups", "managers", {"name": "Managers", "users": ["user_id"]}
        )

        # Run
        ret = is_manager(db=db, uid="account_id", site_id="test")

        # Check
        assert not ret

    def test_is_manager_without_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        site_snap.reference.set_doc("accounts", "account_id", None)
        site_snap.reference.set_doc(
            "groups", "managers", {"name": "Managers", "users": ["user_id"]}
        )

        # Run
        ret = is_manager(db=db, uid="account_id", site_id="test")

        # Check
        assert not ret

    @patch("manager.is_manager", side_effect=MagicMock(return_value=False))
    def test_create_user_without_privilege(
        self,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()

        # Run
        ret = create_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            name="User name",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    @patch("manager.add_account_to_user", side_effect=MagicMock(return_value=True))
    def test_create_user_with_email_and_password(
        self,
        mock_add_account_to_user,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        user_snap = site_snap.reference.set_doc("users", "user_id", {})

        db.collection("sites").document("test").collection("users").add = MagicMock(
            return_value=(None, user_snap)
        )

        # Run
        ret = create_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            name="User name",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

        db.collection("sites").document("test").collection(
            "users"
        ).add.assert_called_once_with(
            {
                "name": "User name",
                "email": "user@example.com",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

        mock_add_account_to_user.assert_called_once_with(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    @patch("manager.add_account_to_user", side_effect=MagicMock(return_value=True))
    def test_create_user_without_email_and_password(
        self,
        mock_add_account_to_user,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users
        site_snap.reference.set_collection("users")

        added_user = MockDocSnap()
        added_user.id = "user_id"
        added_user.exists = True
        db.collection("sites").document("test").collection("users").add = MagicMock(
            return_value=(None, added_user)
        )

        # Run
        ret = create_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            name="User name",
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

        db.collection("sites").document("test").collection(
            "users"
        ).add.assert_called_once_with(
            {
                "name": "User name",
                "email": None,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

        mock_add_account_to_user.assert_not_called()

    @patch("manager.is_manager", side_effect=MagicMock(return_value=False))
    def test_add_account_to_user_without_privilege(
        self,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        auth_client.get_user_by_email = MagicMock(
            side_effect=auth.UserNotFoundError("Test"),
        )
        auth_client.create_user = MagicMock(
            return_value=MockUserRecord(uid="account_id"),
        )

        # Run
        ret = add_account_to_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )
        auth_client.get_user_by_email.assert_not_called()
        auth_client.create_user.assert_not_called()

    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_add_account_to_inactive_user(
        self,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        site_snap.reference.set_doc(
            "users",
            "user_id",
            {
                "name": "User",
                "deletedAt": datetime.now(),
            },
        )
        auth_client.get_user_by_email = MagicMock(
            side_effect=auth.UserNotFoundError("Test"),
        )
        auth_client.create_user = MagicMock(
            return_value=MockUserRecord(uid="account_id"),
        )

        # Run
        ret = add_account_to_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )
        auth_client.get_user_by_email.assert_not_called()
        auth_client.create_user.assert_not_called()

    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_add_account_with_new_uid_to_user(
        self,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        site_snap.reference.set_doc("users", "user_id", {"name": "User"})
        # sites/test/accounts/account_id
        account_snap = site_snap.reference.set_doc("accounts", "account_id", {})
        account_snap.reference.set = MagicMock(
            return_value=(None, account_snap),
        )

        auth_client.get_user_by_email = MagicMock(
            side_effect=auth.UserNotFoundError("Test"),
        )
        auth_client.create_user = MagicMock(
            return_value=MockUserRecord(uid="account_id"),
        )

        # Run
        ret = add_account_to_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

        auth_client.get_user_by_email.assert_called_once_with(
            email="user@example.com",
        )

        auth_client.create_user.assert_called_once_with(
            email="user@example.com",
            password="test_password",
        )

        account_snap.reference.set(
            call(
                {
                    "user": "account_id",
                    "createdAt": firestore.SERVER_TIMESTAMP,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                    "deletedAt": None,
                }
            )
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_add_account_with_existing_uid_to_user(
        self,
        mock_is_manager,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        site_snap.reference.set_doc("users", "user_id", {"name": "User"})
        # sites/test/accounts/account_id
        account_snap = site_snap.reference.set_doc("accounts", "account_id", {})
        account_snap.reference.set = MagicMock(
            return_value=(None, account_snap),
        )

        auth_client.get_user_by_email = MagicMock(
            return_value=MockUserRecord(uid="account_id"),
        )
        auth_client.create_user = MagicMock(
            return_value=MockUserRecord(uid="account_id"),
        )

        # Run
        ret = add_account_to_user(
            auth_client=auth_client,
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            email="user@example.com",
            password="test_password",
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

        auth_client.get_user_by_email.assert_called_once_with(
            email="user@example.com",
        )

        auth_client.create_user.assert_not_called()

        account_snap.reference.set(
            call(
                {
                    "user": "account_id",
                    "createdAt": firestore.SERVER_TIMESTAMP,
                    "updatedAt": firestore.SERVER_TIMESTAMP,
                    "deletedAt": None,
                }
            )
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=False))
    def test_disable_accounts_of_user_without_privilege(
        self,
        mock_is_manager,
    ):
        # Prepare
        db = MockDb()

        # Run
        ret = disable_accounts_of_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            # restore=False,
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=False))
    def test_disable_accounts_of_inactive_user(
        self,
        mock_is_manager,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        site_snap.reference.set_doc(
            "users",
            "user_id",
            {
                "name": "User",
                "deletedAt": datetime.now(),
            },
        )

        # Run
        ret = disable_accounts_of_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            # restore=False,
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

    @patch("manager.delete_doc", side_effect=MagicMock(return_value=True))
    @patch("manager.restore_doc", side_effect=MagicMock(return_value=True))
    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_disable_accounts_of_user(
        self,
        mock_is_manager,
        mock_restore_doc,
        mock_delete_doc,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        user_snap = site_snap.reference.set_doc("users", "user_id", {"name": "User"})
        user_snap.reference.set = MagicMock(return_value=None)
        # sites/test/accounts
        accounts_ref = site_snap.reference.set_collection("accounts")
        # sites/test/accounts/account01
        account01_snap = accounts_ref.set_doc("account01", {"user": "user_id"})
        # sites/test/accounts/account02
        account02_snap = accounts_ref.set_doc("account02", {"user": "user_id"})
        accounts_query = MockQuery()
        accounts_query.stream = MagicMock(
            return_value=(n for n in (account01_snap, account02_snap))
        )
        accounts_ref.where = MagicMock(return_value=accounts_query)

        # Run
        ret = disable_accounts_of_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            # restore=False,
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )
        mock_restore_doc.assert_not_called()
        assert 2 == mock_delete_doc.call_count
        user_snap.reference.set.assert_called_once_with(
            {
                "revokedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @patch("manager.delete_doc", side_effect=MagicMock(return_value=True))
    @patch("manager.restore_doc", side_effect=MagicMock(return_value=True))
    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_restore_accounts_of_user(
        self,
        mock_is_manager,
        mock_restore_doc,
        mock_delete_doc,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        user_snap = site_snap.reference.set_doc("users", "user_id", {"name": "User"})
        user_snap.reference.set = MagicMock(return_value=None)
        # sites/test/accounts
        accounts_ref = site_snap.reference.set_collection("accounts")
        # sites/test/accounts/account01
        account01_snap = accounts_ref.set_doc("account01", {"user": "user_id"})
        # sites/test/accounts/account02
        account02_snap = accounts_ref.set_doc("account02", {"user": "user_id"})
        accounts_query = MockQuery()
        accounts_query.stream = MagicMock(
            return_value=(n for n in (account01_snap, account02_snap))
        )
        accounts_ref.where = MagicMock(return_value=accounts_query)

        # Run
        ret = disable_accounts_of_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
            restore=True,
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )
        assert 2 == mock_restore_doc.call_count
        mock_delete_doc.assert_not_called()
        user_snap.reference.set.assert_called_once_with(
            {
                "revokedAt": None,
            }
        )

    @patch("manager.is_manager", side_effect=MagicMock(return_value=False))
    def test_delete_user_without_privilege(
        self,
        mock_is_manager,
    ):
        # Prepare
        db = MockDb()

        # Run
        ret = delete_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
        )

        # Check
        assert not ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )

    @patch("manager.delete_doc", side_effect=MagicMock(return_value=True))
    @patch("manager.is_manager", side_effect=MagicMock(return_value=True))
    def test_delete_user(
        self,
        mock_is_manager,
        mock_delete_doc,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {})
        # sites/test/users/user_id
        user_snap = site_snap.reference.set_doc("users", "user_id", {"name": "User"})
        user_snap.reference.set = MagicMock(return_value=None)
        # sites/test/accounts
        accounts_ref = site_snap.reference.set_collection("accounts")
        # sites/test/accounts/account01
        account01_snap = accounts_ref.set_doc("account01", {"user": "user_id"})
        # sites/test/accounts/account02
        account02_snap = accounts_ref.set_doc("account02", {"user": "user_id"})
        accounts_query = MockQuery()
        accounts_query.stream = MagicMock(
            return_value=(n for n in (account01_snap, account02_snap))
        )
        accounts_ref.where = MagicMock(return_value=accounts_query)

        # Run
        ret = delete_user(
            db=db,
            uid="account_id",
            site_id="test",
            user_id="user_id",
        )

        # Check
        assert ret

        mock_is_manager.assert_called_once_with(
            db=db,
            uid="account_id",
            site_id="test",
        )
        assert 3 == mock_delete_doc.call_count
