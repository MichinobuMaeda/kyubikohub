import unittest
from google.cloud import firestore
from firebase_admin import (
    get_app,
    firestore as firestore_client,
    auth as auth_client,
)
from test_utils import clear_data, test_deploy
from utils import (
    is_alpha_numerics,
    is_lower_cases_and_numerics,
    is_upper_cases_and_numerics,
    is_email_format,
    is_active_doc,
    delete_doc,
    restore_doc,
)


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

    def test_is_alpha_numerics(self):
        assert is_alpha_numerics(None)
        assert is_alpha_numerics("")
        assert is_alpha_numerics("abc")
        assert is_alpha_numerics("123")
        assert is_alpha_numerics("abc123")
        assert not is_alpha_numerics(" abc123")
        assert not is_alpha_numerics("abc 123")
        assert not is_alpha_numerics("abc123 ")
        assert is_alpha_numerics("Abc123")
        assert not is_alpha_numerics("abc123!")

    def test_is_lower_cases_and_numerics(self):
        assert is_lower_cases_and_numerics(None)
        assert is_lower_cases_and_numerics("")
        assert is_lower_cases_and_numerics("abc")
        assert is_lower_cases_and_numerics("123")
        assert is_lower_cases_and_numerics("abc123")
        assert not is_lower_cases_and_numerics(" abc123")
        assert not is_lower_cases_and_numerics("abc 123")
        assert not is_lower_cases_and_numerics("abc123 ")
        assert not is_lower_cases_and_numerics("abc123G")
        assert not is_lower_cases_and_numerics("abc123!")

    def test_is_upper_cases_and_numerics(self):
        assert is_upper_cases_and_numerics(None)
        assert is_upper_cases_and_numerics("")
        assert is_upper_cases_and_numerics("ABC")
        assert is_upper_cases_and_numerics("123")
        assert is_upper_cases_and_numerics("ABC123")
        assert not is_upper_cases_and_numerics(" ABC123")
        assert not is_upper_cases_and_numerics("ABC 123")
        assert not is_upper_cases_and_numerics("ABC123 ")
        assert not is_upper_cases_and_numerics("ABC123g")
        assert not is_upper_cases_and_numerics("ABC123!")

    def test_is_email_format(self):
        assert is_email_format(None)
        assert is_email_format("")
        assert is_email_format("abc@example.com")
        assert is_email_format("abc.def@example.com")
        assert is_email_format("abc-def@example.com")
        assert is_email_format("abc_def@example.com")
        assert is_email_format("abc@mail.example.co.jp")
        assert is_email_format("abc@example.co.jp")
        assert is_email_format("abc@example.jp")
        assert not is_email_format(" ")
        assert not is_email_format(" abc@example.com")
        assert not is_email_format("abc @example.com")
        assert not is_email_format("abc@ example.com")
        assert not is_email_format("abc@exam ple.com")
        assert not is_email_format("abc@example .com")
        assert not is_email_format("abc@example.com ")
        assert not is_email_format("abc@example.com.")
        assert not is_email_format("abc@example.")
        assert not is_email_format("abc@example")
        assert not is_email_format("abc@")
        assert not is_email_format("abc")

    def test_is_active_doc_with_valid_doc(self):
        # Prepare
        col_ref = self.db.collection("tests")
        doc1_ref = col_ref.document("test1")
        doc2_ref = col_ref.document("test2")
        doc1_ref.set(
            {
                "name": "Test",
            }
        )
        doc2_ref.set(
            {
                "name": "Test",
                "deletedAt": None,
            }
        )

        # Run
        ret1 = is_active_doc(doc1_ref.get())
        ret2 = is_active_doc(doc2_ref.get())

        # Check
        assert ret1
        assert ret2

    def test_is_active_doc_with_deleted_doc(self):
        # Prepare
        col_ref = self.db.collection("tests")
        doc1_ref = col_ref.document("test1")
        doc1_ref.set(
            {
                "name": "Test",
                "deletedAt": firestore.SERVER_TIMESTAMP,
            }
        )

        # Run
        ret1 = is_active_doc(doc1_ref.get())

        # Check
        assert not ret1

    def test_is_active_doc_without_doc(self):
        # Prepare
        col_ref = self.db.collection("tests")
        doc1_ref = col_ref.document("test1")
        doc1_ref.set(
            {
                "name": "Test",
            }
        )
        doc1_ref.delete()

        # Run
        ret1 = is_active_doc(doc1_ref.get())

        # Check
        assert not ret1

    def test_delete_doc(self):
        col_ref = self.db.collection("tests")
        doc1_ref = col_ref.document("test1")
        doc1_ref.set(
            {
                "name": "Test",
            }
        )

        # Run
        delete_doc(doc1_ref)

        # Check
        assert doc1_ref.get().exists
        assert doc1_ref.get().get("deletedAt") is not None

    def test_restore_doc(self):
        col_ref = self.db.collection("tests")
        doc1_ref = col_ref.document("test1")
        doc1_ref.set(
            {
                "name": "Test",
            }
        )
        delete_doc(doc1_ref)

        # Run
        restore_doc(doc1_ref)

        # Check
        assert doc1_ref.get().exists
        assert doc1_ref.get().get("deletedAt") is None
