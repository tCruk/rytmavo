// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rytmavo';

  @override
  String get navToday => 'Today';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navHabits => 'Habits';

  @override
  String get navStats => 'Insights';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsOpen => 'Open settings';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonLoading => 'Loading …';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody =>
      'The data could not be loaded. Please try again.';

  @override
  String get todayTitle => 'Today';

  @override
  String get todayEmptyTitle => 'No shift plan yet';

  @override
  String get todayEmptyBody =>
      'Set up your shift system so Rytmavo can show your shifts and habits.';

  @override
  String get todaySetupAction => 'Set up shift system';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarJumpToToday => 'Jump to today';

  @override
  String get habitsTitle => 'Habits';

  @override
  String get habitsEmptyTitle => 'No habits yet';

  @override
  String get habitsEmptyBody =>
      'Create habits that fit your shifts – for example “20-minute walk after the night shift”.';

  @override
  String get habitsAddAction => 'Create habit';

  @override
  String get statsTitle => 'Insights';

  @override
  String get statsEmptyTitle => 'Nothing to show yet';

  @override
  String get statsEmptyBody =>
      'Once you check off habits, you will see your success rate across planned days here.';

  @override
  String get shiftEarly => 'Early';

  @override
  String get shiftLate => 'Late';

  @override
  String get shiftNight => 'Night';

  @override
  String get shiftOff => 'Off';

  @override
  String get shiftEarlyShort => 'E';

  @override
  String get shiftLateShort => 'L';

  @override
  String get shiftNightShort => 'N';

  @override
  String get shiftOffShort => '–';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System language';

  @override
  String get settingsLanguageGerman => 'German';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSectionReminders => 'Reminders';

  @override
  String get settingsRemindersStatus => 'Reminder status';

  @override
  String get settingsRemindersOff => 'Off – reminders are not enabled.';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsExport => 'Export data';

  @override
  String get settingsImport => 'Import data';

  @override
  String get settingsDeleteData => 'Delete local data';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsImprint => 'Imprint';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsComingSoon => 'Available in a later phase.';

  @override
  String a11yShiftBadge(String shiftName) {
    return 'Shift: $shiftName';
  }
}
