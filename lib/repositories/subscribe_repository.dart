import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../validators.dart';

class SubscribeRepository {
  final AppLocalizations t;
  final ValueNotifier<TextInputValue> Function(TextInputValue v) useState;
  final List<TextInputParam> params;

  SubscribeRepository({
    required this.t,
    required this.useState,
  }) : params = [
          (
            key: 'siteId',
            notifier: useState(emptyInputText()),
            label: t.siteId,
            helperText: '${t.required} ${t.lCasesAndNumerics}',
            maxLines: 1,
            validator: (String v) => validateLCasesAndNumerics(
                  validateRequired(Either.of(v.trim()), t),
                  t,
                ),
          ),
          (
            key: 'siteName',
            notifier: useState(emptyInputText()),
            label: t.siteName,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v.trim()), t),
          ),
          (
            key: 'name',
            notifier: useState(emptyInputText()),
            label: t.fullName,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v.trim()), t),
          ),
          (
            key: 'email',
            notifier: useState(emptyInputText()),
            label: t.email,
            helperText: '${t.required} ${t.emailFormat}',
            maxLines: 1,
            validator: (String v) =>
                validateEmail(validateRequired(Either.of(v.trim()), t), t),
          ),
          (
            key: 'tel',
            notifier: useState(emptyInputText()),
            label: t.tel,
            helperText: t.telFormat,
            maxLines: 1,
            validator: (String v) => validateTel(Either.of(v.trim()), t),
          ),
          (
            key: 'zip',
            notifier: useState(emptyInputText()),
            label: t.zip,
            helperText: '${t.required} ${t.zipFormat}',
            maxLines: 1,
            validator: (String v) =>
                validateZip(validateRequired(Either.of(v.trim()), t), t),
          ),
          (
            key: 'pref',
            notifier: useState(emptyInputText()),
            label: t.prefecture,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v.trim()), t),
          ),
          (
            key: 'city',
            notifier: useState(emptyInputText()),
            label: t.city,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v.trim()), t),
          ),
          (
            key: 'addr',
            notifier: useState(emptyInputText()),
            label: t.address,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v.trim()), t),
          ),
          (
            key: 'bldg',
            notifier: useState(emptyInputText()),
            label: t.bldg,
            helperText: t.address2HelperText,
            maxLines: 1,
            validator: (String v) => Either.of(v.trim()),
          ),
          (
            key: 'desc',
            notifier: useState(emptyInputText()),
            label: t.purposeSubscription,
            helperText: t.lengthNotLessThan(200),
            maxLines: 6,
            validator: (String v) => validateLengthNotLessThan(
                validateRequired(Either.of(v.trim()), t), t, 200),
          ),
        ];

  Future<Either<String, String>> run() async {
    final Map<String, String?> data = {};
    for (final param in params) {
      data[param.key] = param.notifier.value.toNullable();
    }
    return TaskEither<String, String>(
      () async {
        try {
          final result = await FirebaseFunctions.instanceFor(
            region: functionsRegion,
          ).httpsCallable('subscribe').call(data);
          switch (result.data.err) {
            case null:
              // Receive the new subscriber ID
              return Either.right(result.data.val as String);
            case 'required: siteId':
              return Either.left(t.itemIsRequired(t.siteId));
            case 'required: siteName':
              return Either.left(t.itemIsRequired(t.siteName));
            case 'required: name':
              return Either.left(t.itemIsRequired(t.fullName));
            case 'required: email':
              return Either.left(t.itemIsRequired(t.email));
            case 'required: zip':
              return Either.left(t.itemIsRequired(t.zip));
            case 'required: pref':
              return Either.left(t.itemIsRequired(t.prefecture));
            case 'required: city':
              return Either.left(t.itemIsRequired(t.city));
            case 'required: addr':
              return Either.left(t.itemIsRequired(t.address));
            case 'required: desc':
              return Either.left(t.itemIsRequired(t.purposeSubscription));
            case 'too short: desc':
              return Either.left(t.itemIsDuplicated(t.siteId));
            case 'invalid: siteId':
              return Either.left(t.itemIsInvalid(t.siteId));
            case 'invalid: email':
              return Either.left(t.itemIsInvalid(t.email));
            case 'invalid: tel':
              return Either.left(t.itemIsInvalid(t.tel));
            case 'invalid: zip':
              return Either.left(t.itemIsInvalid(t.zip));
            case 'duplicate: site':
              return Either.left(t.itemIsDuplicated(t.siteId));
            case 'too many request from: email':
              return Either.left(t.itemIsDuplicated(t.siteId));
            default:
              return Either.left(t.systemError(t.unknown));
          }
        } on FirebaseFunctionsException catch (e, s) {
          debugPrint(e.code);
          debugPrint(e.message);
          debugPrint(e.details);
          debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
          return Either.left(
              t.systemError('${e.code} ${e.message} ${e.details}'));
        } catch (e, s) {
          debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
          return Either.left(t.systemError(e.toString()));
        }
      },
    ).run();
  }
}
