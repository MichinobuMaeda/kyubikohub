bool validateRequired(String? value) => value is String && value.isNotEmpty;

bool validateAlphaNumerics(String? value) =>
    value == null || value.isEmpty || !RegExp(r"[^a-zA-Z0-9]").hasMatch(value);

bool validateLowercasesAndNumerics(String? value) =>
    value == null || value.isEmpty || !RegExp(r"[^a-z0-9]").hasMatch(value);

bool validateEmail(String? value) =>
    value == null ||
    value.isEmpty ||
    RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);

bool validateTel(String? value) =>
    value == null ||
    value.isEmpty ||
    RegExp(r"^([0-9]+)(-[0-9]+)*$").hasMatch(value);
