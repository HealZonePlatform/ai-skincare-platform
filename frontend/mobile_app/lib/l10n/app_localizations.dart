import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'loginTitle': 'Welcome back!',
      'loginSubtitle': 'Sign in to keep your routines, reminders, and scan history in sync.',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'signInCta': 'Sign in',
      'signUpCta': 'Create account',
    },
    'vi': {
      'loginTitle': 'Chào mừng trở lại!',
      'loginSubtitle': 'Đăng nhập để đồng bộ chu trình, nhắc nhở và lịch sử phân tích da.',
      'emailLabel': 'Email',
      'passwordLabel': 'Mật khẩu',
      'signInCta': 'Đăng nhập',
      'signUpCta': 'Tạo tài khoản',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
