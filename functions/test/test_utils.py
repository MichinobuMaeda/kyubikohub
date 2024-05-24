import unittest
from unittest.mock import MagicMock
from google.cloud import firestore
from datetime import datetime
from utils import is_active_doc, delete_doc, restore_doc
from .utils import MockDb


class TestMain(unittest.TestCase):
    def test_is_active_doc_with_valid_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        doc_snap = site_snap.reference.set_doc(
            "accounts", "account_id", {"name": "Test user"}
        )

        # Run
        ret = is_active_doc(doc_snap)

        # Check
        assert ret

    def test_is_active_doc_with_deleted_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        doc_snap = site_snap.reference.set_doc(
            "accounts",
            "account_id",
            {
                "name": "Admin user",
                "deletedAt": datetime.now(),
            },
        )

        # Run
        ret = is_active_doc(doc_snap)

        # Check
        assert not ret

    def test_is_active_doc_without_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        doc_snap = site_snap.reference.set_doc("accounts", "account_id", None)

        # Run
        ret = is_active_doc(doc_snap)

        # Check
        assert not ret

    def test_delete_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        doc_snap = site_snap.reference.set_doc(
            "accounts", "account_id", {"name": "Test user"}
        )

        doc_snap.reference.update = MagicMock(return_value=None)

        # Run
        delete_doc(doc_snap.reference)

        # Check
        doc_snap.reference.update.assert_called_once_with(
            {
                "deletedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    def test_restore_doc(
        self,
    ):
        # Prepare
        db = MockDb()
        # sites/test
        site_snap = db.set_doc("sites", "test", {"name": "Test"})
        # sites/test/accounts/account_id
        doc_snap = site_snap.reference.set_doc(
            "accounts", "account_id", {"name": "Test user"}
        )

        doc_snap.reference.update = MagicMock(return_value=None)

        # Run
        restore_doc(doc_snap.reference)

        # Check
        doc_snap.reference.update.assert_called_once_with(
            {
                "deletedAt": None,
            }
        )
