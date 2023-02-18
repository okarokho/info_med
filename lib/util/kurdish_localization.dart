import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

/// A custom set of date patterns for the `nn` locale.
///
/// These are not accurate and are just a clone of the date patterns for the
/// `no` locale to demonstrate how one would write and use custom date patterns.
// #docregion Date
const kuLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
// #enddocregion Date
  'LLLL': 'LLLL',
  'M': 'L.',
  'Md': 'd.M.',
  'MEd': 'EEE d.M.',
  'MMM': 'LLL',
  'MMMd': 'd. MMM',
  'MMMEd': 'EEE d. MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd. MMMM',
  'MMMMEEEEd': 'EEEE d. MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M.y',
  'yMd': 'd.M.y',
  'yMEd': 'EEE d.MM.y',
  'yMMM': 'MMM y',
  'yMMMd': 'd. MMM y',
  'yMMMEd': 'EEE d. MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd. MMMM y',
  'yMMMMEEEEd': 'EEEE d. MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

/// A custom set of date symbols for the `nn` locale.
///
/// These are not accurate and are just a clone of the date symbols for the
/// `no` locale to demonstrate how one would write and use custom date symbols.
// #docregion Date2
const kuDateSymbols = {
  'NAME': 'ku',
  'ERAS': <dynamic>[
    'پ.ز',
    'د.ز',
  ],
// #enddocregion Date2
  'ERANAMES': <dynamic>[
    'پێش زایین',
    'دوای زاین',
  ],
  
  'NARROWMONTHS': <dynamic>[
    'ک',
    'ش',
    'ئ',
    'ن',
    'م',
    'ح',
    'ت',
    'ئ',
    'ئ',
    'ت',
    'ت',
    'ک',
  ],
  'STANDALONENARROWMONTHS': <dynamic>[
    'کانوونی دووەم',
    'شوبات',
    'ئادار',
    'نیسان',
    'مایس',
    'حوزەیران',
    'تەموز',
    'ئاب',
    'ئەیلوول',
    'تشرینی یەکەم',
    'تشرینی دووەم',
    'کانوونی یەکەم',
  ],
  'MONTHS': <dynamic>[
    'کانوونی دووەم',
    'شوبات',
    'ئادار',
    'نیسان',
    'مایس',
    'حوزەیران',
    'تەموز',
    'ئاب',
    'ئەیلوول',
    'تشرینی یەکەم',
    'تشرینی دووەم',
    'کانوونی یەکەم',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'کانوونی دووەم',
    'شوبات',
    'ئادار',
    'نیسان',
    'مایس',
    'حوزەیران',
    'تەموز',
    'ئاب',
    'ئەیلوول',
    'تشرینی یەکەم',
    'تشرینی دووەم',
    'کانوونی یەکەم',
  ],
  'SHORTMONTHS': <dynamic>[
    'کانوونی دووەم',
    'شوبات',
    'ئادار',
    'نیسان',
    'مایس',
    'حوزەیران',
    'تەموز',
    'ئاب',
    'ئەیلوول',
    'تشرینی یەکەم',
    'تشرینی دووەم',
    'کانوونی یەکەم',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'کانوونی دووەم',
    'شوبات',
    'ئادار',
    'نیسان',
    'مایس',
    'حوزەیران',
    'تەموز',
    'ئاب',
    'ئەیلوول',
    'تشرینی یەکەم',
    'تشرینی دووەم',
    'کانوونی یەکەم',
  ],
  'WEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'یەک شەمە',
    'دوو شەمە',
    'سێ شەمە',
    'چوار شەمە',
    'پێنج شەمە',
    'هەینی',
    'شەمە',
  ],
  'SHORTQUARTERS': <dynamic>[
    'چارەکی یەکەم',
    'چارەکی دووەم',
    'چارەکی سێیەم',
    'چارەکی چوارەم',
  ],
  'QUARTERS': <dynamic>[
    'چارەکی یەکەم',
    'چارەکی دووەم',
    'چارەکی سێیەم',
    'چارەکی چوارەم',
  ],
  'AMPMS': <dynamic>[
    'پێش نیوەڕۆ',
    'دوا نیوەڕؤ',
  ],
  'DATEFORMATS': <dynamic>[
    'EEEE d. MMMM y',
    'd. MMMM y',
    'd. MMM y',
    'dd.MM.y',
  ],
  'TIMEFORMATS': <dynamic>[
    'HH:mm:ss zzzz',
    'HH:mm:ss z',
    'HH:mm:ss',
    'HH:mm',
  ],
  'AVAILABLEFORMATS': null,
  'FIRSTDAYOFWEEK': 6,
  'WEEKENDRANGE': <dynamic>[
    4,
    5,
  ],
  'FIRSTWEEKCUTOFFDAY': 3,
  'DATETIMEFORMATS': <dynamic>[
    '{1} {0}',
    '{1} \'لە\'. {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

// #docregion Delegate
class _KuMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KuMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    // The locale (in this case `nn`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: kuLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(kuDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      KuMaterialLocalizations(
        localeName: localeName,
        // The `intl` library's NumberFormat class is generated from CLDR data
        // (see https://github.com/dart-lang/intl/blob/master/lib/number_symbols_data.dart).
        // Unfortunately, there is no way to use a locale that isn't defined in
        // this map and the only way to work around this is to use a listed
        // locale's NumberFormat symbols. So, here we use the number formats
        // for 'en_US' instead.
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        // DateFormat here will use the symbols and patterns provided in the
        // `date_symbol_data_custom.initializeDateFormattingCustom` call above.
        // However, an alternative is to simply use a supported locale's
        // DateFormat symbols, similar to NumberFormat above.
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(_KuMaterialLocalizationsDelegate old) => false;
}
// #enddocregion Delegate

/// A custom set of localizations for the 'nn' locale. In this example, only
/// the value for openAppDrawerTooltip was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class KuMaterialLocalizations extends GlobalMaterialLocalizations {
  const KuMaterialLocalizations({
    super.localeName = 'ku',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

// #docregion Getters
  @override
  String get moreButtonTooltip => r'زیاتر';

  @override
  String get aboutListTileTitleRaw => r'دەربارەی $applicationName';

  @override
  String get alertDialogLabel => r'ئاگاداری';

// #enddocregion Getters

  @override
  String get anteMeridiemAbbreviation => r'پێش نیوەڕؤ';

  @override
  String get backButtonTooltip => r'گەڕانەوە';

  @override
  String get cancelButtonLabel => r'پاشگەزبوونەوە';

  @override
  String get closeButtonLabel => r'داخستن';

  @override
  String get closeButtonTooltip => r'داخستن';

  @override
  String get collapsedIconTapHint => r'کردنەوە';

  @override
  String get continueButtonLabel => r'بەردەوامبوون';

  @override
  String get copyButtonLabel => r'کۆپی';

  @override
  String get cutButtonLabel => r'کەت';

  @override
  String get deleteButtonTooltip => r'سڕینەوە';

  @override
  String get dialogLabel => r'دایالۆگ';

  @override
  String get drawerLabel => r'Navigation menu';

  @override
  String get expandedIconTapHint => r'Collapse';

  @override
  String get firstPageTooltip => r'First page';

  @override
  String get hideAccountsLabel => r'Hide accounts';

  @override
  String get lastPageTooltip => r'Last page';

  @override
  String get licensesPageTitle => r'Licenses';

  @override
  String get modalBarrierDismissLabel => r'Dismiss';

  @override
  String get nextMonthTooltip => r'Next month';

  @override
  String get nextPageTooltip => r'Next page';

  @override
  String get okButtonLabel => r'OK';

  @override
  // A custom drawer tooltip message.
  String get openAppDrawerTooltip => r'Custom Navigation Menu Tooltip';

// #docregion Raw
  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow of $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow of about $rowCount';
// #enddocregion Raw

  @override
  String get pasteButtonLabel => r'PASTE';

  @override
  String get popupMenuLabel => r'Popup menu';

  @override
  String get menuBarMenuLabel => r'Menu Bar Label';

  @override
  String get postMeridiemAbbreviation => r'دوا نیوەڕؤ';

  @override
  String get previousMonthTooltip => r'Previous month';

  @override
  String get previousPageTooltip => r'Previous page';

  @override
  String get refreshIndicatorSemanticLabel => r'Refresh';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String get remainingTextFieldCharacterCountOne => r'1 character remaining';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount characters remaining';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String get remainingTextFieldCharacterCountZero => r'No characters remaining';

  @override
  String get reorderItemDown => r'Move down';

  @override
  String get reorderItemLeft => r'Move left';

  @override
  String get reorderItemRight => r'Move right';

  @override
  String get reorderItemToEnd => r'Move to the end';

  @override
  String get reorderItemToStart => r'Move to the start';

  @override
  String get reorderItemUp => r'Move up';

  @override
  String get rowsPerPageTitle => r'Rows per page:';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => r'Search';

  @override
  String get selectAllButtonLabel => r'SELECT ALL';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String get selectedRowCountTitleOne => r'1 item selected';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount items selected';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String get selectedRowCountTitleZero => r'No items selected';

  @override
  String get showAccountsLabel => r'Show accounts';

  @override
  String get showMenuTooltip => r'Show menu';

  @override
  String get signedInLabel => r'Signed in';

  @override
  String get tabLabelRaw => r'Tab $tabIndex of $tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => r'Select hours';

  @override
  String get timePickerMinuteModeAnnouncement => r'Select minutes';

  @override
  String get viewLicensesButtonLabel => r'VIEW LICENSES';

  @override
  List<String> get narrowWeekdays =>
      const <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  int get firstDayOfWeekIndex => 0;

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _KuMaterialLocalizationsDelegate();

  @override
  String get calendarModeButtonLabel => r'Switch to calendar';

  @override
  String get dateHelpText => r'mm/dd/yyyy';

  @override
  String get dateInputLabel => r'Enter Date';

  @override
  String get dateOutOfRangeLabel => r'Out of range.';

  @override
  String get datePickerHelpText => r'SELECT DATE';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'End date $fullDate';

  @override
  String get dateRangeEndLabel => r'End Date';

  @override
  String get dateRangePickerHelpText => 'SELECT RANGE';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'Start date \$fullDate';

  @override
  String get dateRangeStartLabel => 'Start Date';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'Switch to dial picker mode';

  @override
  String get inputDateModeButtonLabel => 'Switch to input';

  @override
  String get inputTimeModeButtonLabel => 'Switch to text input mode';

  @override
  String get invalidDateFormatLabel => 'Invalid format.';

  @override
  String get invalidDateRangeLabel => 'Invalid range.';

  @override
  String get invalidTimeLabel => 'Enter a valid time';

  @override
  String get licensesPackageDetailTextOther => '\$licenseCount licenses';

  @override
  String get saveButtonLabel => 'SAVE';

  @override
  String get selectYearSemanticsLabel => 'Select year';

  @override
  String get timePickerDialHelpText => 'SELECT TIME';

  @override
  String get timePickerHourLabel => 'Hour';

  @override
  String get timePickerInputHelpText => 'ENTER TIME';

  @override
  String get timePickerMinuteLabel => 'Minute';

  @override
  String get unspecifiedDate => 'Date';

  @override
  String get unspecifiedDateRange => 'Date Range';

  @override
  String get keyboardKeyAlt => throw UnimplementedError();

  @override
  String get keyboardKeyAltGraph => throw UnimplementedError();

  @override
  String get keyboardKeyBackspace => throw UnimplementedError();

  @override
  String get keyboardKeyCapsLock => throw UnimplementedError();

  @override
  String get keyboardKeyChannelDown => throw UnimplementedError();

  @override
  String get keyboardKeyChannelUp => throw UnimplementedError();

  @override
  String get keyboardKeyControl => throw UnimplementedError();

  @override
  String get keyboardKeyDelete => throw UnimplementedError();

  String get keyboardKeyEisu => throw UnimplementedError();

  @override
  String get keyboardKeyEject => throw UnimplementedError();

  @override
  String get keyboardKeyEnd => throw UnimplementedError();

  @override
  String get keyboardKeyEscape => throw UnimplementedError();

  @override
  String get keyboardKeyFn => throw UnimplementedError();

  @override
  String get keyboardKeyHome => throw UnimplementedError();

  @override
  String get keyboardKeyInsert => throw UnimplementedError();

  @override
  String get keyboardKeyMeta => throw UnimplementedError();

  @override
  String get keyboardKeyMetaMacOs => throw UnimplementedError();

  @override
  String get keyboardKeyMetaWindows => throw UnimplementedError();

  @override
  String get keyboardKeyNumLock => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad0 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad1 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad2 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad3 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad4 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad5 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad6 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad7 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad8 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpad9 => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadAdd => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadComma => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadDecimal => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadDivide => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadEnter => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadEqual => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadMultiply => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadParenLeft => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadParenRight => throw UnimplementedError();

  @override
  String get keyboardKeyNumpadSubtract => throw UnimplementedError();

  @override
  String get keyboardKeyPageDown => throw UnimplementedError();

  @override
  String get keyboardKeyPageUp => throw UnimplementedError();

  @override
  String get keyboardKeyPower => throw UnimplementedError();

  @override
  String get keyboardKeyPowerOff => throw UnimplementedError();

  @override
  String get keyboardKeyPrintScreen => throw UnimplementedError();

  @override
  String get keyboardKeyScrollLock => throw UnimplementedError();

  @override
  String get keyboardKeySelect => throw UnimplementedError();

  @override
  String get keyboardKeySpace => throw UnimplementedError();
}