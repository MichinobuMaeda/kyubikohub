import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fpdart/fpdart.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../views/validators.dart';

class SubscribeRepository {
  final AppLocalizations t;
  final ValueNotifier<TextInputValue> Function(TextInputValue v) useState;
  final List<TextInputParam> params;

  SubscribeRepository({
    required this.t,
    required this.useState,
  }) : params = [
          (
            key: 'site',
            notifier: useState(emptyInputText()),
            label: t.siteId,
            helperText: '${t.required} ${t.lCasesAndNumerics}',
            maxLines: 1,
            validator: (String v) => validateLCasesAndNumerics(
                  validateRequired(Either.of(v), t),
                  t,
                ),
          ),
          (
            key: 'name',
            notifier: useState(emptyInputText()),
            label: t.subscriberName,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v), t),
          ),
          (
            key: 'email',
            notifier: useState(emptyInputText()),
            label: t.subscriberEmail,
            helperText: '${t.required} ${t.emailFormat}',
            maxLines: 1,
            validator: (String value) => validateEmail(
                  validateRequired(Either.of(value), t),
                  t,
                ),
          ),
          (
            key: 'tel',
            notifier: useState(emptyInputText()),
            label: t.tel,
            helperText: t.telFormat,
            maxLines: 1,
            validator: (String v) => validateTel(Either.of(v), t),
          ),
          (
            key: 'zip',
            notifier: useState(emptyInputText()),
            label: t.zip,
            helperText: '${t.required} ${t.zipFormat}',
            maxLines: 1,
            validator: (String v) => validateZip(
                  validateRequired(Either.of(v), t),
                  t,
                ),
          ),
          (
            key: 'prefecture',
            notifier: useState(emptyInputText()),
            label: t.prefecture,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v), t),
          ),
          (
            key: 'city',
            notifier: useState(emptyInputText()),
            label: t.city,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v), t),
          ),
          (
            key: 'address1',
            notifier: useState(emptyInputText()),
            label: t.address1,
            helperText: t.required,
            maxLines: 1,
            validator: (String v) => validateRequired(Either.of(v), t),
          ),
          (
            key: 'address2',
            notifier: useState(emptyInputText()),
            label: t.address2,
            helperText: t.address2HelperText,
            maxLines: 1,
            validator: (String v) => Either.of(v),
          ),
          (
            key: 'desc',
            notifier: useState(emptyInputText()),
            label: t.purposeSubscription,
            helperText: t.lengthNotLessThan(200),
            maxLines: 6,
            validator: (String v) => validateLengthNotLessThan(
                  validateRequired(Either.of(v), t),
                  t,
                  200,
                ),
          ),
          (
            key: 'managerName',
            notifier: useState(emptyInputText()),
            label: '${t.manager} ${t.displayName}',
            helperText: t.notForIndividualApplication,
            maxLines: 1,
            validator: (String v) => nullValidator(Either.right(v)),
          ),
          (
            key: 'managerEmail',
            notifier: useState(emptyInputText()),
            label: '${t.manager} ${t.email}',
            helperText: t.notForIndividualApplication,
            maxLines: 1,
            validator: (String v) => validateEmail(Either.of(v), t),
          ),
        ];

  Future<Either<String, void>> run() async {
    final Map<String, String?> data = {};
    for (final param in params) {
      data[param.key] = param.notifier.value.toNullable();
    }
    return TaskEither<String, void>(
      () async {
        try {
          final result = await FirebaseFunctions.instanceFor(
            region: functionsRegion,
          ).httpsCallable('subscribe').call(data);
          switch (result.data as String) {
            case 'ok':
              return Either.right(null);
            case 'required: site':
              return Either.left(t.itemIsRequired(t.siteId));
            case 'required: name':
              return Either.left(t.itemIsRequired(t.subscriberName));
            case 'required: email':
              return Either.left(t.itemIsRequired(t.subscriberEmail));
            case 'required: zip':
              return Either.left(t.itemIsRequired(t.zip));
            case 'required: prefecture':
              return Either.left(t.itemIsRequired(t.prefecture));
            case 'required: city':
              return Either.left(t.itemIsRequired(t.city));
            case 'required: address1':
              return Either.left(t.itemIsRequired(t.address1));
            case 'required: desc':
              return Either.left(t.itemIsRequired(t.purposeSubscription));
            case 'duplicate: site':
              return Either.left(t.itemIsDuplicated(t.siteId));
            default:
              if (result.data.toString().startsWith('too many requests')) {
                final from = result.data.toString().split(':').last.trim();
                return Either.left(t.tooManyRequestsFrom(from));
              } else {
                return Either.left(t.systemError(t.unknown));
              }
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
