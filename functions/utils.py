import re
from google.cloud import firestore


# Validation: data format


def is_alpha_numerics(val: str) -> bool:
    return val is None or val == "" or re.fullmatch(r"[a-zA-Z0-9]+", val) is not None


def is_lower_cases_and_numerics(val: str) -> bool:
    return val is None or val == "" or re.fullmatch(r"[a-z0-9]+", val) is not None


def is_upper_cases_and_numerics(val: str) -> bool:
    return val is None or val == "" or re.fullmatch(r"[A-Z0-9]+", val) is not None


def is_email_format(val: str) -> bool:
    return (
        val is None
        or val == ""
        or (
            re.fullmatch(
                r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+",
                val,
            )
            is not None
        )
    )


def is_tel_format(val: str) -> bool:
    return (
        val is None or val == "" or re.fullmatch(r"([0-9]+)(-[0-9]+)*", val) is not None
    )


def is_zip_format(val: str) -> bool:
    return (
        val is None or val == "" or re.fullmatch(r"([0-9]+)(-[0-9]+)*", val) is not None
    )


# Validation: required fields


def has_string_value_of_key(data: dict, key: str) -> bool:
    return key in data and data[key] is not None and len(data[key]) > 0


# Firestore: document operations


def is_active_doc(
    doc: firestore.DocumentSnapshot,
) -> bool:
    return doc.exists and (
        "deletedAt" not in (doc.to_dict() or {}) or doc.get("deletedAt") is None
    )


def delete_doc(
    doc_ref: firestore.DocumentReference,
):
    doc_ref.update({"deletedAt": firestore.SERVER_TIMESTAMP})


def restore_doc(
    doc_ref: firestore.DocumentReference,
):
    doc_ref.update({"deletedAt": None})
