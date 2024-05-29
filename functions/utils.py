from google.cloud import firestore


def is_active_doc(
    doc: firestore.DocumentSnapshot,
) -> bool:
    return doc.exists and (
        "deletedAt" not in doc.to_dict() or doc.get("deletedAt") is None
    )


def delete_doc(
    doc_ref: firestore.DocumentReference,
):
    doc_ref.update({"deletedAt": firestore.SERVER_TIMESTAMP})


def restore_doc(
    doc_ref: firestore.DocumentReference,
):
    doc_ref.update({"deletedAt": None})
