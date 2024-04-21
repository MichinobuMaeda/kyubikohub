class MockDocRef:
    def __init__(self, path: str):
        self.path = path


class MockDocSnap:
    def __init__(self, path: str, data):
        self.reference = MockDocRef(path)
        self.data = data

    def get(self, key: str):
        return self.data[key]


class MockEvent:
    def __init__(self, project: str, data: MockDocSnap):
        self.project = project
        self.data = data


class MockResponse:
    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code

    def json(self):
        return self.json_data
