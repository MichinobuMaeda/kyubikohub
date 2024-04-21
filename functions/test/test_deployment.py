import unittest
from unittest import mock
from unittest.mock import MagicMock
from dotenv import load_dotenv
from google.cloud import firestore
from deployment import restore_trigger_doc, set_ui_version
from .utils import MockDocSnap, MockEvent, MockResponse


def mocked_requests_get_success(*args, **kwargs):
    return MockResponse({"version": "1.2.3"}, 200)


def mocked_requests_get_failed(*args, **kwargs):
    return MockResponse(None, 500)


class TestMain(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        load_dotenv(".env.local")

    def test_restore_trigger_doc(
        self,
    ):
        # Prepare
        event = MockEvent("test_project", MockDocSnap("test/path", {}))
        event.data.reference.set = MagicMock(return_value=None)

        # Run
        restore_trigger_doc(event)

        # Check
        event.data.reference.set.assert_called_with(
            {
                "createdAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @mock.patch("requests.get", side_effect=mocked_requests_get_success)
    def test_set_ui_version_update(
        self,
        requests_get_mock,
    ):
        # Prepare
        ver = "1.2.3"
        event = MockEvent(
            "test_success",
            MockDocSnap("test/path", {"uiVersion": "0.0.0"}),
        )
        event.data.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(event)

        # Check
        event.data.reference.update.assert_called_with(
            {
                "uiVersion": ver,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @mock.patch("requests.get", side_effect=mocked_requests_get_success)
    def test_set_ui_version_no_action(
        self,
        requests_get_mock,
    ):
        # Prepare
        ver = "1.2.3"
        event = MockEvent(
            "test_success",
            MockDocSnap("test/path", {"uiVersion": ver}),
        )
        event.data.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(event)

        # Check
        event.data.reference.update.assert_not_called()

    @mock.patch("requests.get", side_effect=mocked_requests_get_failed)
    def test_set_ui_version_failed(
        self,
        requests_get_mock,
    ):
        # Prepare
        event = MockEvent("test_failed", MockDocSnap("test/path", {}))
        event.data.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(event)

        # Check
        event.data.reference.update.assert_not_called()
