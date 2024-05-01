import unittest
from unittest.mock import MagicMock, patch, call
import json
import os
from google.cloud import firestore
from deployment import (
    _get_deployment_handle,
    _set_ui_version,
    _upgrade_data_v1,
    _set_data_version,
    _upgrade_data,
    deploy,
)
from .utils import MockDb, MockResponse, MockAuth, MockDocRef


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
        res = _get_deployment_handle(db)

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
        res = _get_deployment_handle(db)

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
        res = _get_deployment_handle(db)

        # Check
        assert res

    @patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_to_update_service_conf(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.0.0"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        _set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_called_once_with(
            {
                "uiVersion": "1.2.3",
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_end_with_no_action(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.2.3"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        _set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_not_called()

    @patch("requests.get", side_effect=mocked_requests_get_to_fail)
    def test_set_ui_version_to_fail(
        self,
        requests_get_mock,
    ):
        # Prepare
        db = MockDb()
        snap = db.set_doc("service", "conf", {"uiVersion": "1.0.0"})
        snap.reference.update = MagicMock(return_value=None)

        # Run
        _set_ui_version(db, "project_id")

        # Check
        url = "https://project_id.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        snap.reference.update.assert_not_called()

    @patch("deployment.create_site")
    def test_upgrade_data_v1(
        self,
        mock_create_site,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        data = {
            "PRIMARY_USER_ID": "primary_user_id",
            "PRIMARY_USER_EMAIL": "primary_user_email",
            "PRIMARY_USER_PASSWORD": "primary_user_password",
            "TEST_MANAGER_ID": "test_manager_id",
            "TEST_MANAGER_EMAIL": "test_manager_email",
            "TEST_MANAGER_PASSWORD": "test_manager_password",
        }

        # Run
        _upgrade_data_v1(auth_client=auth_client, db=db, data=data)

        # Check
        mock_create_site.assert_has_calls(
            [
                call(
                    auth_client=auth_client,
                    db=db,
                    site_id="admins",
                    site_name="Administrators",
                    uid="primary_user_id",
                    email="primary_user_email",
                    password="primary_user_password",
                    name="Primary user",
                ),
                call(
                    auth_client=auth_client,
                    db=db,
                    site_id="test",
                    site_name="Test",
                    uid="test_manager_id",
                    email="test_manager_email",
                    password="test_manager_password",
                    name="Manager",
                ),
            ]
        )

    def test_set_set_data_version(
        self,
    ):
        # Prepare
        conf_ref = MockDocRef("service/conf")
        conf_ref.update = MagicMock(return_value=None)
        new_ver = 9

        # Run
        _set_data_version(conf_ref, new_ver)

        # Check
        conf_ref.update.assert_called_once_with(
            {
                "dataVersion": new_ver,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    def test_upgrade_data_without_conf(
        self,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # service/conf
        conf_snap = db.set_doc("service", "conf", None)
        conf_snap.reference.set = MagicMock(return_value=None)
        data = {"dummy": "dummy"}

        # Run
        _upgrade_data(db=db, auth_client=auth_client, data=data)

        # Check
        conf_snap.reference.set.assert_called_once_with(
            {
                "dataVersion": 0,
                "uiVersion": "",
                "policy": "## Privacy policy",
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )
        mock_upgrade_data_v1.assert_called_once_with(
            db=db, auth_client=auth_client, data=data
        )
        mock_set_data_version.assert_called_once_with(conf_snap.reference, 1)

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    def test_upgrade_data_with_conf_data_version_0(
        self,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # service/conf
        conf_snap = db.set_doc("service", "conf", {"dataVersion": 0})
        conf_snap.reference.set = MagicMock(return_value=None)
        data = {"dummy": "dummy"}

        # Run
        _upgrade_data(db=db, auth_client=auth_client, data=data)

        # Check
        conf_snap.reference.set.assert_not_called()
        mock_upgrade_data_v1.assert_called_once_with(
            db=db, auth_client=auth_client, data=data
        )
        mock_set_data_version.assert_called_once_with(conf_snap.reference, 1)

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    def test_upgrade_data_with_conf_data_version_1(
        self,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        # service/conf
        conf_snap = db.set_doc("service", "conf", {"dataVersion": 1})
        conf_snap.reference.set = MagicMock(return_value=None)
        data = {"dummy": "dummy"}

        # Run
        _upgrade_data(db=db, auth_client=auth_client, data=data)

        # Check
        conf_snap.reference.set.assert_not_called()
        mock_upgrade_data_v1.assert_not_called()
        mock_set_data_version.assert_not_called()

    @patch("deployment._set_ui_version")
    @patch("deployment.set_test_data")
    @patch("deployment._upgrade_data")
    @patch("deployment._get_deployment_handle", return_value=False)
    def test_deploy_with_error_of_get_deployment_handle(
        self,
        mock_get_deployment_handle,
        mock_upgrade_data,
        mock_set_test_data,
        mock_set_ui_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        deployment_key = "not test"
        project_id = "id of project"
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=db,
            auth_client=auth_client,
            deployment_key=deployment_key,
            project_id=project_id,
            data=data,
        )

        # Check
        mock_get_deployment_handle.assert_called_once_with(db)
        mock_upgrade_data.assert_not_called()
        mock_set_test_data.assert_not_called()
        mock_set_ui_version.assert_not_called()

    @patch("deployment._set_ui_version")
    @patch("deployment.set_test_data")
    @patch("deployment._upgrade_data")
    @patch("deployment._get_deployment_handle", return_value=True)
    def test_deploy_in_production_environment(
        self,
        mock_get_deployment_handle,
        mock_upgrade_data,
        mock_set_test_data,
        mock_set_ui_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        deployment_key = "not test"
        project_id = "id of project"
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=db,
            auth_client=auth_client,
            deployment_key=deployment_key,
            project_id=project_id,
            data=data,
        )

        # Check
        mock_get_deployment_handle.assert_called_once_with(db)
        mock_upgrade_data.assert_called_once_with(
            db=db,
            auth_client=auth_client,
            data=data,
        )
        mock_set_test_data.assert_not_called()
        mock_set_ui_version.assert_called_once_with(
            db=db,
            project_id=project_id,
        )

    @patch("deployment._set_ui_version")
    @patch("deployment.set_test_data")
    @patch("deployment._upgrade_data")
    @patch("deployment._get_deployment_handle", return_value=True)
    def test_deploy_in_test_environment(
        self,
        mock_get_deployment_handle,
        mock_upgrade_data,
        mock_set_test_data,
        mock_set_ui_version,
    ):
        # Prepare
        auth_client = MockAuth()
        db = MockDb()
        deployment_key = "test"
        project_id = "id of project"
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=db,
            auth_client=auth_client,
            deployment_key=deployment_key,
            project_id=project_id,
            data=data,
        )

        # Check
        mock_get_deployment_handle.assert_called_once_with(db)
        mock_upgrade_data.assert_called_once_with(
            db=db,
            auth_client=auth_client,
            data=data,
        )
        mock_set_test_data.assert_called_once_with(
            db=db,
            auth_client=auth_client,
        )
        mock_set_ui_version.assert_not_called()
