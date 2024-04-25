class MockDocSnap:
    def __init__(self):
        self.reference = None
        self.exists = False
        self.id = None
        self.data = dict()

    def get(self, key: str):
        return self.data[key]


class MockDocRef:
    def __init__(self, path: str):
        self.path = path
        self.snap = MockDocSnap()
        self.snap.reference = self

    def get(self):
        return self.snap

    def set(self, data: dict):
        self.snap.data = data
        self.snap.exists = True

    def update(self, data: dict):
        if self.snap.exists:
            self.snap.data = {**self.snap.data, **data}


class MockCollectionRef:
    def __init__(self):
        self.db = None
        self.id = None
        self.doc_refs = dict()

    def document(self, id: str):
        return self.doc_refs[id]

    def add(self, data: dict):
        return (None, self.set_doc("test_doc", data))

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


class MockDb:
    def __init__(self):
        self.col_refs = dict()

    def collection(self, id: str):
        return self.col_refs[id]

    def set_doc(
        self,
        collection: str,
        doc: str,
        data: dict | None,
    ) -> MockDocSnap:
        col_ref = MockCollectionRef()
        col_ref.db = self
        col_ref.id = collection
        doc_snap = col_ref.set_doc(doc, data)
        self.col_refs[collection] = col_ref
        return doc_snap


class MockResponse:
    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code

    def json(self):
        return self.json_data
