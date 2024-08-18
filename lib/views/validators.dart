import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../l10n/app_localizations.dart';
import '../config.dart';

typedef TextInputValue = Either<String, String>;

typedef TextInputParam = ({
  String key,
  ValueNotifier<TextInputValue> notifier,
  String label,
  String helperText,
  int maxLines,
  TextInputValue Function(String value) validator,
});

TextInputValue emptyInputText() => Either.of('');

bool validateAll(List<TextInputParam> inputParams) => inputParams.every(
      (param) => param.notifier.value.match(
        (l) => false,
        (r) => param.validator(r).isRight(),
      ),
    );

TextInputValue nullValidator(TextInputValue v) => v;

TextInputValue validateRequired(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) =>
          r.isNotEmpty ? Either.right(r) : Either.left(t.errorOf(t.required)),
    );

TextInputValue validateAlphaNumerics(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regAlphaNumerics).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.alphaNumerics)),
    );

TextInputValue validateLCasesAndNumerics(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regLCasesAndNumerics).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.lCasesAndNumerics)),
    );

TextInputValue validateUCasesAndNumerics(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regUCasesAndNumerics).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.uCasesAndNumerics)),
    );

TextInputValue validateEmail(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regEmail).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.emailFormat)),
    );

TextInputValue validateTel(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regTel).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.telFormat)),
    );

TextInputValue validateZip(
  TextInputValue v,
  AppLocalizations t,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || RegExp(regZip).hasMatch(r)
          ? Either.right(r)
          : Either.left(t.errorOf(t.zipFormat)),
    );

TextInputValue validateLengthNotMoreThan(
  TextInputValue v,
  AppLocalizations t,
  int length,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || r.length <= length
          ? Either.right(r)
          : Either.left(t.errorOf(t.lengthNotMoreThan(length))),
    );

TextInputValue validateLengthNotLessThan(
  TextInputValue v,
  AppLocalizations t,
  int length,
) =>
    v.match(
      (l) => v,
      (r) => r.isEmpty || r.length >= length
          ? Either.right(r)
          : Either.left(t.errorOf(t.lengthNotLessThan(length))),
    );
