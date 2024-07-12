from coverage import Coverage
from unittest import TestLoader
from unittest.result import TestResult
from google.cloud import firestore
from firebase_admin import auth
from deployment import upgrade_data
from test_data import set_test_data, test_param


def clear_data(
    db: firestore.Client,
    auth: auth.Client,
):
    for user in auth.list_users().iterate_all():
        auth.delete_user(user.uid)

    for col1 in db.collections():
        for doc1 in col1.stream():
            for col2 in doc1.reference.collections():
                for doc2 in col2.stream():
                    doc2.reference.delete()
            doc1.reference.delete()


def test_deploy(
    db: firestore.Client,
    auth: auth.Client,
):
    upgrade_data(db=db, auth=auth, data=test_param)
    set_test_data(db=db, auth=auth)


def run_test(
    cov: Coverage,
    db: firestore.Client,
    auth: auth.Client,
) -> bool:
    clear_data(db=db, auth=auth)
    test_deploy(db=db, auth=auth)
    result = (
        TestLoader()
        .discover(
            start_dir=".",
            pattern="*_test.py",
        )
        .run(result=TestResult())
    )
    cov.stop()
    cov.save()
    cov.lcov_report(outfile="coverage.lcov")
    cov.html_report(directory="htmlcov")
    for case, message in result.errors:
        print(case)
        print(message.replace("\\n", "\n"))
    for case, message in result.failures:
        print(case)
        print(message.replace("\\n", "\n"))
    return result.wasSuccessful()
