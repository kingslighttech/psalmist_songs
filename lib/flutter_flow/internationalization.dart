import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'fr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? frText = '',
  }) =>
      [enText, frText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'ypjgmfi3': {
      'en': '',
      'fr': '',
    },
    'k17phof0': {
      'en': 'TOP VIDEOS',
      'fr': '',
    },
    'uv7fu725': {
      'en': 'More >',
      'fr': '',
    },
    't9bjilml': {
      'en': 'TOP AUDIOS',
      'fr': '',
    },
    '56iuntlu': {
      'en': 'More >',
      'fr': '',
    },
    'fvapw4lh': {
      'en': 'RECENTLY ADDED',
      'fr': '',
    },
    'yqa5jjk5': {
      'en': 'More >',
      'fr': '',
    },
    'fmzkxokg': {
      'en': 'ALBUMS',
      'fr': '',
    },
    '1p7mjaxa': {
      'en': 'More >',
      'fr': '',
    },
    'vx0g32tk': {
      'en': 'FAVOURITES',
      'fr': '',
    },
    '4lasxjqt': {
      'en': 'More >',
      'fr': '',
    },
    'ovg5cpe3': {
      'en': 'WORSHIP',
      'fr': '',
    },
    'tyvekddq': {
      'en': 'More >',
      'fr': '',
    },
    'tox5mfea': {
      'en': 'PRAISE',
      'fr': '',
    },
    'gn6i1p6z': {
      'en': 'More >',
      'fr': '',
    },
    'q7ldxgiu': {
      'en': 'WARFARE',
      'fr': '',
    },
    'h6w7g9bg': {
      'en': 'More >',
      'fr': '',
    },
    'kgv9zmr3': {
      'en': 'INDIGENOUS',
      'fr': '',
    },
    'zmkcbf8e': {
      'en': 'More >',
      'fr': '',
    },
    'u16wb58z': {
      'en': 'THANKSGIVING',
      'fr': '',
    },
    'v8upeguu': {
      'en': 'More >',
      'fr': '',
    },
    'gtt61ovn': {
      'en': 'PRAYER/REQUEST',
      'fr': '',
    },
    '1jl78n6r': {
      'en': 'More >',
      'fr': '',
    },
    'k1ki906b': {
      'en': '',
      'fr': '',
    },
    'bhqjin43': {
      'en': 'VIDEO',
      'fr': '',
    },
    '9ss8dotq': {
      'en': 'AUDIO',
      'fr': '',
    },
    'b1slwmtv': {
      'en': 'VIDEO',
      'fr': '',
    },
    'w8lt283y': {
      'en': 'VOTE\nNOW',
      'fr': '',
    },
    '06t1y2s9': {
      'en': 'STATUS : ',
      'fr': '',
    },
    'quzivno3': {
      'en': 'Free Version',
      'fr': '',
    },
    '056l4jkn': {
      'en': 'Notifications',
      'fr': '',
    },
    'lfjd1262': {
      'en': 'SIGN OUT',
      'fr': '',
    },
    'sc56qv4d': {
      'en': 'Admin',
      'fr': '',
    },
    'nonaooz2': {
      'en': 'subscription',
      'fr': '',
    },
    'pcje0gyc': {
      'en': 'customer support',
      'fr': '',
    },
    'br13h16t': {
      'en': 'Delete Account',
      'fr': '',
    },
    'obnjqnzq': {
      'en': 'Terms & Policies',
      'fr': '',
    },
    '4fdh7m0i': {
      'en': 'Psalmist Songs',
      'fr': '',
    },
  },
  // Onboarding
  {
    '7cvza7wq': {
      'en': 'Welcome!',
      'fr': '',
    },
    'ky1iliet': {
      'en':
          'Thanks for joining! Access or create your account below, and get started on your music streaming journey!',
      'fr': '',
    },
    '54f5kbjt': {
      'en': 'I have read and agree to the Terms of Service and Privacy Policy',
      'fr': '',
    },
    'h2tse17a': {
      'en': 'Get Started',
      'fr': '',
    },
    'g1j81t1m': {
      'en': 'Home',
      'fr': '',
    },
  },
  // subscription_page
  {
    '0vl2r03r': {
      'en': 'MFM PSALMISTS',
      'fr': '',
    },
    '357v02ki': {
      'en': 'Choose a Subscription Plan',
      'fr': '',
    },
    'qvtfgdy5': {
      'en': 'Please select a plan...',
      'fr': '',
    },
    '0viwl8fk': {
      'en': 'Search for an item...',
      'fr': '',
    },
    'stfgh1zn': {
      'en': 'MONTHLY PLAN',
      'fr': '',
    },
    'x5oj20xo': {
      'en': 'YEARLY PLAN',
      'fr': '',
    },
    'b3v2coud': {
      'en': 'Please select type...',
      'fr': '',
    },
    '3gnu8bm4': {
      'en': 'Search for an item...',
      'fr': '',
    },
    'bpeti1jx': {
      'en': 'One Time Option',
      'fr': '',
    },
    'oq36n4p2': {
      'en': 'RECURRING',
      'fr': '',
    },
    'tz6m2kh2': {
      'en': 'Subscribe Now',
      'fr': '',
    },
    'wgz24nbq': {
      'en': 'OR',
      'fr': '',
    },
    'ujtav3gn': {
      'en': 'Input Voucher Code',
      'fr': '',
    },
    'cxptx3ym': {
      'en': 'Input Code...',
      'fr': '',
    },
    'k9afq40e': {
      'en': 'Validate',
      'fr': '',
    },
    '0g0jhsm4': {
      'en': 'Later',
      'fr': '',
    },
    'v07v7zxu': {
      'en': 'Home',
      'fr': '',
    },
  },
  // Account_Page
  {
    'c36eaold': {
      'en': 'Create an account',
      'fr': '',
    },
    'uv89wvv5': {
      'en': 'Let\'s get started by filling out the form below.',
      'fr': '',
    },
    'fcz6vqgb': {
      'en': 'Email',
      'fr': '',
    },
    'ed2whlcm': {
      'en': 'Password',
      'fr': '',
    },
    'uuxo47n3': {
      'en': 'Confirm Password',
      'fr': '',
    },
    '3eke7kzb': {
      'en': 'Create Account',
      'fr': '',
    },
    'gyh67pfu': {
      'en': 'OR',
      'fr': '',
    },
    'kh9o49lq': {
      'en': 'Already have an account? ',
      'fr': '',
    },
    'z9uflvlk': {
      'en': ' Log In here',
      'fr': '',
    },
    'gu22a6m3': {
      'en': 'Log In',
      'fr': '',
    },
    'kx83nn5d': {
      'en': 'Let\'s get started by filling out the form below.',
      'fr': '',
    },
    'e1e56e08': {
      'en': 'Email',
      'fr': '',
    },
    'lhcijnz0': {
      'en': 'Password',
      'fr': '',
    },
    'cq3cmt22': {
      'en': 'Log In',
      'fr': '',
    },
    '52lv68fy': {
      'en': 'OR',
      'fr': '',
    },
    '1z6wq90u': {
      'en': 'Don\'t have an account? ',
      'fr': '',
    },
    'zq407f39': {
      'en': ' Sign Up here',
      'fr': '',
    },
    'xdhn6jt9': {
      'en': 'Forgot password?',
      'fr': '',
    },
    'qn2jw0qf': {
      'en': 'Forgot Password?',
      'fr': '',
    },
    '70w7co2g': {
      'en':
          'Enter your email address below and we\'ll send you a link to reset your password.',
      'fr': '',
    },
    'v6e8r2ti': {
      'en': 'Email',
      'fr': '',
    },
    'g3xmok5e': {
      'en': 'Reset Password',
      'fr': '',
    },
    'by2og7v2': {
      'en': 'Remember your password? ',
      'fr': '',
    },
    'jzsb4w4j': {
      'en': 'Sign In',
      'fr': '',
    },
    'zx26jgrx': {
      'en': 'Psalmists Songs',
      'fr': '',
    },
    'twacsmma': {
      'en': 'Home',
      'fr': '',
    },
  },
  // Notifications
  {
    '0el7tynj': {
      'en': 'Notifications',
      'fr': '',
    },
  },
  // voting
  {
    'vcwlwx0t': {
      'en': 'VOTING',
      'fr': '',
    },
    'pjk0jj2d': {
      'en': 'BEST WORSHIP SONG',
      'fr': '',
    },
    'h1fmjf8m': {
      'en': 'VOTE',
      'fr': '',
    },
    'r549h8tk': {
      'en': 'BEST PRAISE SONG',
      'fr': '',
    },
    'upmjdtb8': {
      'en': 'VOTE',
      'fr': '',
    },
    'z704h9ij': {
      'en': 'BEST WARFARE SONG',
      'fr': '',
    },
    '67czpziq': {
      'en': 'VOTE',
      'fr': '',
    },
    '8zv8aw79': {
      'en': 'BEST INDIGENOUS SONG',
      'fr': '',
    },
    'v4wh08pc': {
      'en': 'VOTE',
      'fr': '',
    },
    'mk7koun7': {
      'en': 'Home',
      'fr': '',
    },
  },
  // playerpage
  {
    'nvpxgu4m': {
      'en': 'RELATED  SONGS',
      'fr': '',
    },
    'a539yytr': {
      'en': 'Home',
      'fr': '',
    },
  },
  // admin
  {
    '5ddss6r6': {
      'en': 'Dashboard Overview',
      'fr': '',
    },
    'lf7ul9u9': {
      'en': 'Total Users',
      'fr': '',
    },
    'ne6zswz1': {
      'en': 'Active Plans',
      'fr': '',
    },
    'zzx87bij': {
      'en': 'Manage Content',
      'fr': '',
    },
    'ir27yxy3': {
      'en': 'Edit Artists',
      'fr': '',
    },
    '7whb6mrr': {
      'en': 'Reported Comments',
      'fr': '',
    },
    '02u6fot8': {
      'en': 'Add song',
      'fr': '',
    },
    'e9efwe21': {
      'en': 'Adverts',
      'fr': '',
    },
    'f9bm1q71': {
      'en': 'Subscription Management',
      'fr': '',
    },
    'svyg4be5': {
      'en': 'Manage Vouchers',
      'fr': '',
    },
    'eijry0it': {
      'en': 'Subscription Price',
      'fr': '',
    },
    'prfyac08': {
      'en': 'Voting',
      'fr': '',
    },
    'ipnuhp8j': {
      'en': 'Admin Dashboard',
      'fr': '',
    },
  },
  // TermsPolicies
  {
    'ase74u06': {
      'en': 'Terms of Service',
      'fr': '',
    },
    '0a8h33fk': {
      'en':
          '📜 Terms of Service\nEffective Date: [Insert Date]\n\nWelcome to NIJA WISE DEAL! By using our gospel streaming app, you agree to these Terms of Service. Please read them carefully.\n\n1. Account Registration\nTo access the features of the app, you must create an account using your name and email address. You are responsible for maintaining the confidentiality of your login credentials.\n\n2. Content Usage\nYou may stream and share music available on the platform for personal, non-commercial purposes only. Redistribution or unauthorized commercial use of any content is strictly prohibited.\n\n3. User Conduct\nYou agree not to post any content (comments, playlists, uploads, etc.) that is illegal, offensive, infringing, or harmful to others.\n\n4. Subscriptions & Payments\nWe offer monthly and yearly subscription plans. Payments are processed through Google Play Store or Apple App Store. Subscriptions auto-renew unless canceled.\n\n5. Advertisements\nUsers on the free plan will see ads. Premium users enjoy an ad-free experience.\n\n6. Termination\nWe reserve the right to suspend or terminate your access if you violate these terms or misuse the app in any way.\n\n7. Intellectual Property\nAll music, graphics, text, and other content are the property of NIJA WISE DEAL or its licensors and are protected under copyright laws.\n\n8. Modifications\nWe may update these Terms of Service at any time. Continued use of the app after changes are posted means you accept the updated terms.\n\n9. Governing Law\nThese terms are governed by the laws of the Federal Republic of Nigeria, without regard to conflict of law principles.\n\nIf you do not agree to these terms, please do not use our services.\n\n',
      'fr': '',
    },
    'puozgi5v': {
      'en': 'Privacy Policy',
      'fr': '',
    },
    '7sjf6dkg': {
      'en':
          '🔒 Privacy Policy\nEffective Date: [Insert Date]\n\nAt NIJA WISE DEAL, we respect your privacy and are committed to protecting your personal information.\n\n1. Data We Collect\nWe only collect:\n\nName\n\nEmail address\n\nThis information is required to create and manage your account.\n\n2. How We Use Your Data\nWe use your data to:\n\nSet up and manage your user account\n\nDeliver personalized content and app features\n\nSend relevant notifications and updates\n\n3. Third-Party Services\nWe use:\n\nFirebase for secure authentication and data storage\n\nAd networks (e.g., AdMob) that may collect anonymous data to serve relevant ads\n\n4. Data Sharing\nWe do not sell or rent your personal information. We may share it:\n\nTo comply with legal obligations\n\nTo enforce our Terms of Service\n\nWith your explicit consent\n\n5. Data Security\nWe take reasonable measures to protect your data using Firebase\'s secure cloud infrastructure and access controls.\n\n6. Your Rights\nYou may:\n\nRequest a copy of your personal data\n\nRequest correction or deletion of your data\n\nWithdraw consent at any time\n\nFor any of these, email: gkevos@gmail.com\n\n7. Children\'s Privacy\nThis app is not intended for children under 13. We do not knowingly collect personal information from children.\n\n8. Policy Updates\nWe may update this Privacy Policy from time to time. We will notify users of significant changes.',
      'fr': '',
    },
    '9ko9qetp': {
      'en': 'DMCA Policy',
      'fr': '',
    },
    'dc1gbsym': {
      'en':
          'NIJA WISE DEAL respects copyright law and expects all users to do the same. In accordance with the Digital Millennium Copyright Act (DMCA),\nwe respond to valid takedown requests. \n\nTo file a notice of infringement, please provide the following:\n\n1. Identification of the copyrighted work.\n2. URL or description of the infringing material.\n3. A statement of good faith belief that the use is unauthorized.\n4. Your contact information.\n5. A statement under penalty of perjury that the information is accurate.\n6. Your physical or electronic signature.\n\nPlease send all notices to:  \nEmail: gkevos@gmail.com  \nSubject: \"DMCA Takedown Notice\"\n\nUpon receiving a valid request, we will act promptly to remove or disable access to the infringing content.\n',
      'fr': '',
    },
    'tz3aw0pr': {
      'en': 'Cookie Policy',
      'fr': '',
    },
    'c10crduv': {
      'en':
          'NIJA WISE DEAL uses cookies to enhance user experience, provide social media features, and analyze traffic.\n\nCookies are small data files stored on your device. We use them to:\n- Keep you signed in\n- Remember preferences\n- Understand how the app is used\n- Serve relevant ads\n\nBy using our app, you consent to our use of cookies. You may disable cookies in your browser settings, though some features may not work properly.\n',
      'fr': '',
    },
    'cltk4mkg': {
      'en': 'End User License Agreement (EULA)',
      'fr': '',
    },
    'cdqycm54': {
      'en':
          'This EULA is a legal agreement between you and NIJA WISE DEAL for the use of our gospel streaming app.\n\n1. License Grant: You are granted a limited, non-transferable, non-exclusive license to use the app.\n2. Restrictions: You may not reverse engineer, distribute, or sell the app or its content.\n3. User Content: You are responsible for any content (comments, uploads, etc.) you submit.\n4. Termination: We may suspend or terminate your access if you violate these terms.\n5. Liability: The app is provided \"as is\" with no warranties. We are not liable for damages arising from use.\n6. Governing Law: This agreement is governed by the laws of the Federal Republic of Nigeria.\n\nBy installing or using the app, you agree to this EULA.\n',
      'fr': '',
    },
    'felyaek9': {
      'en': 'Terms & Policies',
      'fr': '',
    },
  },
  // album
  {
    'i9gjrugm': {
      'en': 'Play All',
      'fr': '',
    },
    '44pkb4u3': {
      'en': 'Shuffle',
      'fr': '',
    },
  },
  // search
  {
    '9qgv9uc5': {
      'en': 'Search videos and audio...',
      'fr': '',
    },
  },
  // comment_tab
  {
    '4pnj0dn9': {
      'en': 'type comment...',
      'fr': '',
    },
  },
  // subscribe
  {
    'dkqka5be': {
      'en': 'Visit our website to view more contents and features',
      'fr': '',
    },
    'c715g1lr': {
      'en':
          'You need to Subscribe to get premium package and unlimited access!!!',
      'fr': '',
    },
    'w7po14eg': {
      'en': 'SUBSCRIBE NOW',
      'fr': '',
    },
    'y6c15gri': {
      'en': 'LATER',
      'fr': '',
    },
  },
  // ARTIST_BIO
  {
    'u3t0y0fh': {
      'en': 'Artist Bio',
      'fr': '',
    },
    'dm2diuj8': {
      'en': 'SUPPORT YOUR ARTIST',
      'fr': '',
    },
  },
  // votecard
  {
    'ak0vym5u': {
      'en': 'VOTE CHARGES',
      'fr': '',
    },
    'unxxbulk': {
      'en': 'Vote Price',
      'fr': '',
    },
    'p2wjqqma': {
      'en': 'NO. of Votes',
      'fr': '',
    },
    'wve0gwkj': {
      'en': 'Total',
      'fr': '',
    },
    '454rzocr': {
      'en': 'CONFIRM VOTE',
      'fr': '',
    },
  },
  // help_center
  {
    't7tfv265': {
      'en': 'Email Support Center',
      'fr': '',
    },
    'o39kw9ti': {
      'en': 'How can we assist you today?',
      'fr': '',
    },
    'terp1bct': {
      'en': 'Subject',
      'fr': '',
    },
    'jfmbzcvg': {
      'en': 'What\'s this about?',
      'fr': '',
    },
    'lzuvds3e': {
      'en': 'Message',
      'fr': '',
    },
    'tn5je10u': {
      'en': 'Describe your issue or question',
      'fr': '',
    },
    'yf86labx': {
      'en': 'Send Message',
      'fr': '',
    },
    '7q73jy18': {
      'en': 'Or get in touch directly:',
      'fr': '',
    },
    'vq6xjvb9': {
      'en': '+234 912 674 5773',
      'fr': '',
    },
    '2a6jeiev': {
      'en': 'whitekingtec@gmail.com',
      'fr': '',
    },
  },
  // add_song
  {
    'kslhf9wr': {
      'en': 'Add New Song',
      'fr': '',
    },
    'mpdv8b80': {
      'en': 'Artist ID',
      'fr': '',
    },
    'fxdb3s4f': {
      'en': 'Album ID',
      'fr': '',
    },
    'y3shkzy1': {
      'en': 'Artist Name',
      'fr': '',
    },
    'cln2cnvb': {
      'en': 'Bio',
      'fr': '',
    },
    'dwy6ohal': {
      'en': 'Song title',
      'fr': '',
    },
    '6kfyjeet': {
      'en': 'Album title',
      'fr': '',
    },
    '6mx3nq2g': {
      'en': 'Genre',
      'fr': '',
    },
    '4mbf0ntk': {
      'en': 'Select genre...',
      'fr': '',
    },
    'tmwr48eu': {
      'en': 'Search...',
      'fr': '',
    },
    'cs5l1he5': {
      'en': 'PRAISE',
      'fr': '',
    },
    'el8ojgpl': {
      'en': 'WORSHIP',
      'fr': '',
    },
    '3tu7cd5v': {
      'en': 'WARFARE',
      'fr': '',
    },
    'nvv2r7qc': {
      'en': 'INDIGENOUS',
      'fr': '',
    },
    '4fua2kt8': {
      'en': 'THANKSGIVING',
      'fr': '',
    },
    'wxbn576p': {
      'en': 'PRAYER/REQUEST',
      'fr': '',
    },
    '2pdt48et': {
      'en': 'File type',
      'fr': '',
    },
    '8k6xmnev': {
      'en': 'VIDEO',
      'fr': '',
    },
    'qphr9joq': {
      'en': 'AUDIO',
      'fr': '',
    },
    'plnu99pw': {
      'en': 'Add song art',
      'fr': '',
    },
    'egwg0r0e': {
      'en': 'Add artist image',
      'fr': '',
    },
    'cc1ytr6c': {
      'en': 'Add album art',
      'fr': '',
    },
    '52jho3sm': {
      'en': 'Add music file',
      'fr': '',
    },
    'xa47q2l2': {
      'en': 'Add Song',
      'fr': '',
    },
  },
  // artistSupport
  {
    '6d9bxoqh': {
      'en': 'Artist Support',
      'fr': '',
    },
    '0oi726b3': {
      'en': 'Gift your favorite artists',
      'fr': '',
    },
    '61lv5fm8': {
      'en': 'Currency',
      'fr': '',
    },
    '7el9e7i5': {
      'en': '₦',
      'fr': '',
    },
    'nxx5z21e': {
      'en': '\$',
      'fr': '',
    },
    'p1ocjcw1': {
      'en': 'Enter amount here...',
      'fr': '',
    },
    'r85zwokn': {
      'en': 'Support Now',
      'fr': '',
    },
    'cvsmaex5': {
      'en': 'By supporting, you agree to our ',
      'fr': '',
    },
    'uaxmgp55': {
      'en': 'Terms of Service',
      'fr': '',
    },
  },
  // reportedcomment
  {
    '7bhpt3je': {
      'en': 'Reported Comments',
      'fr': '',
    },
    '1njr3mpe': {
      'en': 'Spam',
      'fr': '',
    },
    'vx56p4ys': {
      'en': 'Dismiss',
      'fr': '',
    },
    'see5009t': {
      'en': 'Remove',
      'fr': '',
    },
  },
  // comment_actions
  {
    'tcunxua1': {
      'en': 'Block',
      'fr': '',
    },
    'lx77ngup': {
      'en': 'Report',
      'fr': '',
    },
    'wgox87dg': {
      'en': 'Delete',
      'fr': '',
    },
  },
  // manage_song
  {
    '1bnqhpuf': {
      'en': 'Edit song information',
      'fr': '',
    },
    'rocikkb2': {
      'en': 'Song Details',
      'fr': '',
    },
    'b0nmcy7d': {
      'en': 'DELETE SONG',
      'fr': '',
    },
    'qnoh3ucu': {
      'en': '',
      'fr': '',
    },
    'reauad3e': {
      'en': 'Search...',
      'fr': '',
    },
    'ama5w3h0': {
      'en': 'VIDEO',
      'fr': '',
    },
    'qp219gjl': {
      'en': 'AUDIO',
      'fr': '',
    },
    'i0mi7iup': {
      'en': 'Song File',
      'fr': '',
    },
    'i9mot5hh': {
      'en': 'Genre',
      'fr': '',
    },
    'rnq5g8ro': {
      'en': 'PRAISE',
      'fr': '',
    },
    '0pzp6w8u': {
      'en': 'WORSHIP',
      'fr': '',
    },
    'lhxbb4kw': {
      'en': 'WARFARE',
      'fr': '',
    },
    'yd2rlg7w': {
      'en': 'INDIGENOUS',
      'fr': '',
    },
    'pa9qixgl': {
      'en': 'THANKSGIVING',
      'fr': '',
    },
    'w9j14wc2': {
      'en': 'PRAYER',
      'fr': '',
    },
    'ixrq0nee': {
      'en': 'Cancel',
      'fr': '',
    },
    'w3510qrd': {
      'en': 'Save Changes',
      'fr': '',
    },
    'o3fr6xm2': {
      'en': 'Edit artist information',
      'fr': '',
    },
    '5u5ah8o5': {
      'en': 'Artist Details',
      'fr': '',
    },
    'ieryql5l': {
      'en': 'Bio',
      'fr': '',
    },
    '9jr1iva5': {
      'en': 'TextField',
      'fr': '',
    },
    'yc0wm8ba': {
      'en': 'Cancel',
      'fr': '',
    },
    'afdq4js4': {
      'en': 'Save Changes',
      'fr': '',
    },
    'jvx06bat': {
      'en': 'Edit album information',
      'fr': '',
    },
    '231xghir': {
      'en': 'Album Details',
      'fr': '',
    },
    'x5836nc4': {
      'en': '',
      'fr': '',
    },
    '93xzdpsc': {
      'en': 'Cancel',
      'fr': '',
    },
    'z5vfw96c': {
      'en': 'Save Changes',
      'fr': '',
    },
  },
  // Miscellaneous
  {
    'i577th0y': {
      'en':
          'We use your camera so you can take and upload profile pictures or content images.',
      'fr': '',
    },
    'cmnnslp3': {
      'en':
          'We access your photo library so you can choose a profile picture or upload images for your comments.',
      'fr': '',
    },
    'rwu4nic4': {
      'en': '',
      'fr': '',
    },
    'ldkn1h8a': {
      'en': '',
      'fr': '',
    },
    '5ornj1ci': {
      'en': '',
      'fr': '',
    },
    'nb7bg7uo': {
      'en': '',
      'fr': '',
    },
    'pjaph3nk': {
      'en': '',
      'fr': '',
    },
    'gj8hiu93': {
      'en': '',
      'fr': '',
    },
    '3o74kily': {
      'en': '',
      'fr': '',
    },
    'n49m3edn': {
      'en': '',
      'fr': '',
    },
    'ld0asmk7': {
      'en': '',
      'fr': '',
    },
    'llw1c4ro': {
      'en': '',
      'fr': '',
    },
    'k1glhl1v': {
      'en': '',
      'fr': '',
    },
    '7a6otp1j': {
      'en': '',
      'fr': '',
    },
    'u1vns9wx': {
      'en': '',
      'fr': '',
    },
    '12qy3lzu': {
      'en': '',
      'fr': '',
    },
    '1jo9ydyw': {
      'en': '',
      'fr': '',
    },
    '4kz2ormg': {
      'en': '',
      'fr': '',
    },
    'oxmww7zi': {
      'en': '',
      'fr': '',
    },
    'goo9qtiy': {
      'en': '',
      'fr': '',
    },
    'ybtkns0w': {
      'en': '',
      'fr': '',
    },
    'hmbjegyl': {
      'en': '',
      'fr': '',
    },
    '0x5jr767': {
      'en': '',
      'fr': '',
    },
    'dzign8el': {
      'en': '',
      'fr': '',
    },
    'dh3us69z': {
      'en': '',
      'fr': '',
    },
    'g5q2t34x': {
      'en': '',
      'fr': '',
    },
    'd7hauabk': {
      'en': '',
      'fr': '',
    },
  },
].reduce((a, b) => a..addAll(b));
