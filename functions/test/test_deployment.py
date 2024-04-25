import unittest
from unittest import mock
from unittest.mock import MagicMock
import json
import os
from google.cloud import firestore
from deployment import get_deployment_handle, set_ui_version
from .utils import MockDb, MockResponse

def mocked_requests_get_to_succeed(*args, **kwargs):
    return MockResponse({"version": "1.2.3"}, 200)


def mocked_requests_get_to_fail(*args, **kwargs):
    return MockResponse(None, 500)


def get_deployment_params():
    with open(
        os.path.join(
            os.path.dirname(__file__),
            "..",
            "..",
            "test",
            "deployment_params.json",
        )
    ) as json_data:
        data = json.load(json_data)
        json_data.close()
        return data


class TestMain(unittest.TestCase):
    def test_get_deployment_handle_return_false_if_doc_exists(
        self,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "deployment", {"ts": "2020-01-23T00:00:00.000Z"})
        snap.reference.set = MagicMock(return_value=None)

        # Run
        res = get_deployment_handle(db)

        # Check
        snap.reference.set.assert_not_called()
        assert not res

    def test_get_deployment_handle_return_false_if_interrupted(
        self,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "deployment", None)
        snap.reference.set = MagicMock(return_value=None)

        # Run
        res = get_deployment_handle(db)

        # Check
        assert "T" in snap.reference.set.call_args[0][0]["ts"]
        assert not res

    def test_get_deployment_handle_return_true(
        self,
    ):
        # Prepare
        db = MockDb()
        db.set_doc("service", "deployment", None)

        # Run
        res = get_deployment_handle(db)

        # Check
        assert res

    @mock.patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_to_update_service_conf(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.0.0"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_called_once_with(
            {
                "uiVersion": "1.2.3",
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @mock.patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_end_with_no_action(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.2.3"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_not_called()

    @mock.patch("requests.get", side_effect=mocked_requests_get_to_fail)
    def test_set_ui_version_to_fail(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.0.0"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_not_called()
