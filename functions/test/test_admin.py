import unittest
from unittest.mock import MagicMock
from google.cloud import firestore
from admin import create_site
from .utils import MockDb, MockAuth, MockUserRecord


class TestMain(unittest.TestCase):
    def test_create_site_with_uid(
        self,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/site_id
        site_snap = db.set_doc("sites", "site_id", {"name": "Org Name"})
        # sites/site_id/users
        user_snap = site_snap.reference.set_doc("users", "user_id", None)
        # sites/site_id/accounts/account_id
        account_snap = site_snap.reference.set_doc("accounts", "account_id", None)
        # sites/site_id/groups/managers
        managers_snap = site_snap.reference.set_doc("groups", "managers", None)

        auth_client.create_user = MagicMock(return_value=MockUserRecord("account_id"))
        site_snap.reference.set = MagicMock(return_value=None)
        site_snap.reference.collection("users").add = MagicMock(
            return_value=(None, user_snap)
        )
        account_snap.reference.set = MagicMock(return_value=None)
        managers_snap.reference.set = MagicMock(return_value=None)

        # Run
        create_site(
            auth_client=auth_client,
            db=db,
            site_id="site_id",
            site_name="Org Name",
            uid="account_id",
            email="user@example.com",
            password="testpassword",
            name="User name",
        )

        # Check
        auth_client.create_user.assert_called_once_with(
            uid="account_id",
            email="user@example.com",
            password="testpassword",
        )
        site_snap.reference.set.assert_called_once_with(
            {
                "name": "Org Name",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        site_snap.reference.collection("users").add.assert_called_once_with(
            {
                "name": "User name",
                "email": "user@example.com",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        account_snap.reference.set.assert_called_once_with(
            {
                "user": "user_id",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        managers_snap.reference.set.assert_called_once_with(
            {
                "name": "Managers",
                "users": ["user_id"],
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    def test_create_site_without_uid(
        self,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # sites/site_id
        site_snap = db.set_doc("sites", "site_id", {"name": "Org Name"})
        # sites/site_id/users
        user_snap = site_snap.reference.set_doc("users", "user_id", None)
        # sites/site_id/accounts/account_id
        account_snap = site_snap.reference.set_doc("accounts", "account_id", None)
        # sites/site_id/groups/managers
        managers_snap = site_snap.reference.set_doc("groups", "managers", None)

        auth_client.create_user = MagicMock(return_value=MockUserRecord("account_id"))
        site_snap.reference.set = MagicMock(return_value=None)
        site_snap.reference.collection("users").add = MagicMock(
            return_value=(None, user_snap)
        )
        account_snap.reference.set = MagicMock(return_value=None)
        managers_snap.reference.set = MagicMock(return_value=None)

        # Run
        create_site(
            auth_client=auth_client,
            db=db,
            site_id="site_id",
            site_name="Org Name",
            email="user@example.com",
            password="testpassword",
            name="User name",
        )

        # Check
        auth_client.create_user.assert_called_once_with(
            email="user@example.com",
            password="testpassword",
        )
        site_snap.reference.set.assert_called_once_with(
            {
                "name": "Org Name",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        site_snap.reference.collection("users").add.assert_called_once_with(
            {
                "name": "User name",
                "email": "user@example.com",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        account_snap.reference.set.assert_called_once_with(
            {
                "user": "user_id",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        managers_snap.reference.set.assert_called_once_with(
            {
                "name": "Managers",
                "users": ["user_id"],
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
