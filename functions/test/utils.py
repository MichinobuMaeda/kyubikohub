from datetime import datetime
from google.cloud import firestore


class MockUserRecord:
    def __init__(
        self,
        uid: str = None,
        email: str = None,
        password: str = None,
    ):
        self.uid = datetime.now().isoformat() if uid is None else uid
        self.email = email
        self.password = password


class MockAuth:
    def create_user(
        self,
        uid: str = None,
        email: str = None,
        password: str = None,
    ):
        return MockUserRecord(uid=uid, email=email, password=password)

    def get_user_by_email(email: str):
        return MockUserRecord(email=email)


class MockDocSnap:
    def __init__(self):
        self.reference = None
        self.exists = False
        self.id = None
        self.data = dict()

    def get(self, key: str):
        return self.data[key]

    def to_dict(self):
        return self.data


class MockQuery:
    def stream(self):
        pass


class MockCollectionRef:
    def __init__(self):
        self.db = None
        self.id = None
        self.doc_refs = dict()

    def document(self, id: str):
        return self.doc_refs[id]

    def add(self, data: dict):
        return (None, self.set_doc("test_doc", data))

    def where(filter: firestore.FieldFilter) -> MockQuery:
        return MockQuery()

    def set_doc(
        self,
        doc: str,
        data: dict,
    ) -> MockDocSnap:
        doc_ref = MockDocRef(f"{self.id}/{doc}")
        doc_ref.snap.exists = data is not None
        doc_ref.snap.id = doc
        doc_ref.snap.data = data
        self.doc_refs[doc] = doc_ref
        return doc_ref.snap


class MockDocRef:
    def __init__(self, path: str):
        self.path = path
        self.snap = MockDocSnap()
        self.snap.reference = self
        self.col_refs = dict()

    def get(self):
        return self.snap

    def set(self, data: dict):
        self.snap.data = data
        self.snap.exists = True

    def update(self, data: dict):
        if self.snap.exists:
            self.snap.data = {**self.snap.data, **data}

    def collection(self, id: str):
        return self.col_refs[id]

    def set_collection(
        self,
        collection: str,
    ) -> MockCollectionRef:
        col_ref = MockCollectionRef()
        col_ref.db = self
        col_ref.id = collection
        self.col_refs[collection] = col_ref
        return col_ref

    def set_doc(
        self,
        collection: str,
        doc: str,
        data: dict | None,
    ) -> MockDocSnap:
        col_ref = self.set_collection(collection)
        doc_snap = col_ref.set_doc(doc, data)
        return doc_snap


class MockDb:
    def __init__(self):
        self.col_refs = dict()

    def collection(self, id: str):
        return self.col_refs[id]

    def set_collection(
        self,
        collection: str,
    ) -> MockCollectionRef:
        col_ref = MockCollectionRef()
        col_ref.db = self
        col_ref.id = collection
        self.col_refs[collection] = col_ref
        return col_ref

    def set_doc(
        self,
        collection: str,
        doc: str,
        data: dict | None,
    ) -> MockDocSnap:
        col_ref = self.set_collection(collection)
        doc_snap = col_ref.set_doc(doc, data)
        return doc_snap


class MockResponse:
    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code

    def json(self):
        return self.json_data
