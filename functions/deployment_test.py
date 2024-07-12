import unittest
from unittest.mock import MagicMock, patch, call
import requests
import time
from threading import Thread
from google.cloud import firestore
from firebase_admin import (
    get_app,
    firestore as firestore_client,
    auth as auth_client,
)
import conf
from deployment import (
    _get_deployment_handle,
    _set_ui_version,
    _upgrade_data_v1,
    _upgrade_data_v2,
    _set_data_version,
    upgrade_data,
    deploy,
)
from test_utils import clear_data, test_deploy


def mocked_requests_get_to_succeed(*args, **kwargs):
    response = requests.Response()
    response.status_code = 200
    response.json = MagicMock(return_value={"version": "1.2.3"})
    return response


def mocked_requests_get_to_fail(*args, **kwargs):
    response = requests.Response()
    response.status_code = 500
    response.json = MagicMock(return_value=None)
    return response


def deleteAfter(doc_ref: firestore.DocumentReference, sec: float):
    print(f"START : deleteAfter {sec} sec")
    time.sleep(sec)
    doc_ref.delete()
    print(f"END   : deleteAfter {sec} sec")


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

    def test_get_deployment_handle_return_false_if_doc_exists(self):
        # Prepare
        deployment_ref = self.db.collection("service").document("deployment")
        deployment_ref.set({"ts": "2020-01-23T00:00:00.000Z"})

        # Run
        res = _get_deployment_handle(self.db)

        # Check
        assert not res
        assert deployment_ref.get().get("ts") == "2020-01-23T00:00:00.000Z"

    def test_get_deployment_handle_return_false_if_interrupted(self):
        # Prepare
        deployment_ref = self.db.collection("service").document("deployment")
        deployment_ref.set({"ts": "2020-01-23T00:00:00.000Z"})
        deployment_ref.delete()

        t = Thread(target=deleteAfter, args=(deployment_ref, 0.5))
        t.start()

        # Run
        res = _get_deployment_handle(self.db)

        # Check
        assert not res

    def test_get_deployment_handle_return_true(self):
        # Prepare
        deployment_ref = self.db.collection("service").document("deployment")
        deployment_ref.set({"ts": "2020-01-23T00:00:00.000Z"})
        deployment_ref.delete()

        # Run
        res = _get_deployment_handle(self.db)

        # Check
        assert res

    @patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_to_update_service_conf(
        self,
        requests_get_mock,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.0.0"})
        project_id = "project_id"

        # Run
        _set_ui_version(self.db, project_id)

        # Check
        url = f"https://{project_id}.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        assert conf_ref.get().get("uiVersion") == "1.2.3"
        assert conf_ref.get().get("updatedAt") is not None

    @patch("requests.get", side_effect=mocked_requests_get_to_succeed)
    def test_set_ui_version_end_with_no_action(
        self,
        requests_get_mock,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.2.3", "updatedAt": None})
        project_id = "project_id"

        # Run
        _set_ui_version(self.db, project_id)

        # Check
        url = f"https://{project_id}.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        assert conf_ref.get().get("uiVersion") == "1.2.3"
        assert conf_ref.get().get("updatedAt") is None

    @patch("requests.get", side_effect=mocked_requests_get_to_fail)
    def test_set_ui_version_to_fail(
        self,
        requests_get_mock,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.0.0", "updatedAt": None})
        project_id = "project_id"

        # Run
        _set_ui_version(self.db, project_id)

        # Check
        url = f"https://{project_id}.web.app/version.json?check="
        assert url in requests_get_mock.call_args[0][0]
        assert conf_ref.get().get("uiVersion") == "1.0.0"
        assert conf_ref.get().get("updatedAt") is None

    @patch("deployment.create_site")
    def test_upgrade_data_v1(
        self,
        mock_create_site,
    ):
        # Prepare
        data = {
            "PRIMARY_USER_ID": "primary_user_id",
            "PRIMARY_USER_EMAIL": "primary_user_email",
            "PRIMARY_USER_PASSWORD": "primary_user_password",
            "TEST_MANAGER_ID": "test_manager_id",
            "TEST_MANAGER_EMAIL": "test_manager_email",
            "TEST_MANAGER_PASSWORD": "test_manager_password",
        }

        # Run
        _upgrade_data_v1(auth=self.auth, db=self.db, data=data)

        # Check
        mock_create_site.assert_has_calls(
            [
                call(
                    auth=self.auth,
                    db=self.db,
                    site_id="admins",
                    site_name="Administrators",
                    manager_uid="primary_user_id",
                    manager_email="primary_user_email",
                    manager_password="primary_user_password",
                    manager_name="Primary user",
                ),
                call(
                    auth=self.auth,
                    db=self.db,
                    site_id="test",
                    site_name="Test",
                    manager_uid="test_manager_id",
                    manager_email="test_manager_email",
                    manager_password="test_manager_password",
                    manager_name="Manager",
                ),
            ]
        )

    def test_upgrade_data_v2(self):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.0.0", "updatedAt": None})
        data = {}

        # Run
        _upgrade_data_v2(auth=self.auth, db=self.db, data=data)

        # Check
        conf_snap = conf_ref.get()
        assert conf_snap.get("forGuests") == conf.siteDescForGuests
        assert conf_snap.get("forMembers") == conf.siteDescForMembers
        assert conf_snap.get("forManagers") == conf.siteDescForManagers
        assert conf_ref.get().get("updatedAt") is not None

    def test_set_set_data_version(self):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.0.0", "updatedAt": None})
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
    @patch("deployment._upgrade_data_v2")
    def test_upgrade_data_without_conf(
        self,
        mock_upgrade_data_v2,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"uiVersion": "1.0.0"})
        conf_ref.delete()
        data = {"dummy": "dummy"}

        # Run
        upgrade_data(db=self.db, auth=self.auth, data=data)

        # Check
        conf_snap = conf_ref.get()
        assert conf_snap.get("dataVersion") == 0
        assert conf_snap.get("uiVersion") == ""
        assert conf_snap.get("desc") == "## Privacy policy"
        assert conf_snap.get("createdAt") is not None
        assert conf_snap.get("updatedAt") is not None
        mock_upgrade_data_v1.assert_called_once_with(
            db=self.db, auth=self.auth, data=data
        )
        mock_upgrade_data_v2.assert_called_once_with(
            db=self.db, auth=self.auth, data=data
        )
        mock_set_data_version.assert_has_calls(
            [
                call(conf_snap.reference, 1),
                call(conf_snap.reference, 2),
            ]
        )

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    @patch("deployment._upgrade_data_v2")
    def test_upgrade_data_with_conf_data_version_0(
        self,
        mock_upgrade_data_v2,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"dataVersion": 0})
        data = {"dummy": "dummy"}

        # Run
        upgrade_data(db=self.db, auth=self.auth, data=data)

        # Check
        mock_upgrade_data_v1.assert_called_once_with(
            db=self.db, auth=self.auth, data=data
        )
        mock_upgrade_data_v2.assert_called_once_with(
            db=self.db, auth=self.auth, data=data
        )
        mock_set_data_version.assert_has_calls(
            [
                call(conf_ref, 1),
                call(conf_ref, 2),
            ]
        )
        conf_snap = conf_ref.get()
        assert conf_snap.get("dataVersion") == 0

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    @patch("deployment._upgrade_data_v2")
    def test_upgrade_data_with_conf_data_version_1(
        self,
        mock_upgrade_data_v2,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"dataVersion": 1})
        data = {"dummy": "dummy"}

        # Run
        upgrade_data(db=self.db, auth=self.auth, data=data)

        # Check
        mock_upgrade_data_v1.assert_not_called()
        mock_upgrade_data_v2.assert_called_once_with(
            db=self.db, auth=self.auth, data=data
        )
        mock_set_data_version.assert_called_once_with(conf_ref, 2)
        conf_snap = conf_ref.get()
        assert conf_snap.get("dataVersion") == 1

    @patch("deployment._set_data_version")
    @patch("deployment._upgrade_data_v1")
    @patch("deployment._upgrade_data_v2")
    def test_upgrade_data_with_conf_data_version_2(
        self,
        mock_upgrade_data_v2,
        mock_upgrade_data_v1,
        mock_set_data_version,
    ):
        # Prepare
        conf_ref = self.db.collection("service").document("conf")
        conf_ref.set({"dataVersion": 2})
        data = {"dummy": "dummy"}

        # Run
        upgrade_data(db=self.db, auth=self.auth, data=data)

        # Check
        mock_upgrade_data_v1.assert_not_called()
        mock_upgrade_data_v2.assert_not_called()
        mock_set_data_version.assert_not_called()
        conf_snap = conf_ref.get()
        assert conf_snap.get("dataVersion") == 2

    @patch("deployment._set_ui_version")
    @patch("deployment.upgrade_data")
    @patch("deployment._get_deployment_handle", return_value=False)
    def test_deploy_with_error_of_get_deployment_handle(
        self,
        mock_get_deployment_handle,
        mock_upgrade_data,
        mock_set_ui_version,
    ):
        # Prepare
        clear_data(db=self.db, auth=self.auth)
        project_id = "id of project"
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=self.db,
            auth=self.auth,
            project_id=project_id,
            data=data,
        )

        # Check
        mock_get_deployment_handle.assert_called_once_with(self.db)
        mock_upgrade_data.assert_not_called()
        mock_set_ui_version.assert_not_called()

    @patch("deployment._set_ui_version")
    @patch("deployment.upgrade_data")
    @patch("deployment._get_deployment_handle", return_value=True)
    def test_deploy_in_production_environment(
        self,
        mock_get_deployment_handle,
        mock_upgrade_data,
        mock_set_ui_version,
    ):
        # Prepare
        clear_data(db=self.db, auth=self.auth)
        project_id = "id of project"
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=self.db,
            auth=self.auth,
            project_id=project_id,
            data=data,
        )

        # Check
        mock_get_deployment_handle.assert_called_once_with(self.db)
        mock_upgrade_data.assert_called_once_with(
            db=self.db,
            auth=self.auth,
            data=data,
        )
        mock_set_ui_version.assert_called_once_with(
            db=self.db,
            project_id=project_id,
        )

    def test_deploy_without_project_id(
        self,
    ):
        # Prepare
        clear_data(db=self.db, auth=self.auth)
        project_id = None
        data = {"dummy": "dummy"}

        # Run
        deploy(
            db=self.db,
            auth=self.auth,
            project_id=project_id,
            data=data,
        )

        # Check
        conf_ref = self.db.collection("service").document("conf")
        conf_snap = conf_ref.get()
        assert not conf_snap.exists
