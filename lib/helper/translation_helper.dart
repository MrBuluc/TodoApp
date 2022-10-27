import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper {
  TranslationHelper._();

  static LocaleType getDeviceLanguage(BuildContext context) {
    String deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();

    switch (deviceLanguage) {
      case "tr":
        return LocaleType.tr;
      default:
        return LocaleType.en;
    }
  }
}
