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
  String get shiftsEditAction => 'Edit shift model';

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
  String get settingsExportSubtitle =>
      'Share or save all data as an unencrypted JSON file.';

  @override
  String get settingsImportSubtitle =>
      'Restore a backup. Replaces all current data.';

  @override
  String get settingsDeleteDataSubtitle =>
      'Removes all shifts, habits and settings from this device.';

  @override
  String get backupExportFailed => 'Export failed. Please try again.';

  @override
  String get backupImportTitle => 'Import backup?';

  @override
  String backupImportMessage(String date, int habits, int shiftTypes) {
    return 'The backup from $date contains $habits habits and $shiftTypes shift types. All current data will be replaced.';
  }

  @override
  String get backupImportConfirm => 'Import';

  @override
  String get backupImportDone => 'Backup restored.';

  @override
  String get backupImportInvalid => 'This file is not a valid Rytmavo backup.';

  @override
  String get backupImportFailed => 'Import failed. Your data was not changed.';

  @override
  String get backupDeleteTitle => 'Delete all local data?';

  @override
  String get backupDeleteMessage =>
      'Shifts, habits, completions and settings will be deleted permanently. Export a backup first if you want to keep them.';

  @override
  String get backupDeleteDone => 'All local data has been deleted.';

  @override
  String get backupDeleteFailed => 'Deleting failed.';

  @override
  String a11yShiftBadge(String shiftName) {
    return 'Shift: $shiftName';
  }

  @override
  String get onboardingTitle => 'Set up your shifts';

  @override
  String get onboardingEditTitle => 'Change shift system';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingPresetTitle => 'How do you work?';

  @override
  String get onboardingPresetBody =>
      'Pick a template. In the next step you can adjust every single day.';

  @override
  String get presetWeekly3Name => '3 shifts, weekly';

  @override
  String get presetWeekly3Desc =>
      '5 early · 2 off · 5 late · 2 off · 5 night · 2 off';

  @override
  String get presetWeekly2Name => '2 shifts, weekly';

  @override
  String get presetWeekly2Desc => '5 early · 2 off · 5 late · 2 off';

  @override
  String get presetConti4Name => 'Continuous, 4 crews';

  @override
  String get presetConti4Desc => '2 early · 2 late · 2 night · 2 off';

  @override
  String get presetConti5Name => 'Continuous, 5 crews';

  @override
  String get presetConti5Desc => '2 early · 2 late · 2 night · 4 off';

  @override
  String get presetCustomName => 'Custom rhythm';

  @override
  String get presetCustomDesc => 'Build your cycle yourself, day by day.';

  @override
  String get presetCurrentName => 'Current rhythm';

  @override
  String get presetCurrentDesc => 'Keep adjusting your existing cycle.';

  @override
  String cycleLength(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRhythmTitle => 'Your rhythm';

  @override
  String get onboardingRhythmBody => 'Tap a day to change its shift.';

  @override
  String onboardingDayN(int number) {
    return 'Day $number';
  }

  @override
  String get onboardingAddDay => 'Add day';

  @override
  String get onboardingRemoveDay => 'Remove last day';

  @override
  String get onboardingTodayTitle => 'Which day is today?';

  @override
  String get onboardingTodayBody =>
      'Choose where in your cycle you are today. Rytmavo works out every other day from that.';

  @override
  String get onboardingPreview => 'Preview';

  @override
  String get onboardingTimesTitle => 'Shift times';

  @override
  String get onboardingTimesBody =>
      'These times appear in the day view and the calendar.';

  @override
  String get onboardingNightHint =>
      'A night shift belongs to the day on which it starts.';

  @override
  String get onboardingEditHint =>
      'Changes apply from today. Past days stay as they were.';

  @override
  String get onboardingSaveError => 'Saving failed. Please try again.';

  @override
  String get shiftStart => 'Start';

  @override
  String get shiftEnd => 'End';

  @override
  String shiftTimeRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get shiftEndsNextDay => 'ends the next day';

  @override
  String get todayNextDays => 'Coming days';

  @override
  String todayOverriddenFrom(String shiftName) {
    return 'Changed · rhythm says $shiftName';
  }

  @override
  String get todayNoEntry => 'No entry';

  @override
  String get todayDayOffBody => 'You\'re off today.';

  @override
  String todayNextShift(String shiftName, String date) {
    return 'Next shift: $shiftName, $date';
  }

  @override
  String get calendarPrevMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarChanged => 'changed';

  @override
  String calendarDayA11y(String date, String shiftName) {
    return '$date, $shiftName';
  }

  @override
  String daySheetRotation(String shiftName) {
    return 'Rhythm says: $shiftName';
  }

  @override
  String get daySheetChange => 'Shift for this day';

  @override
  String get daySheetReset => 'Restore rhythm';

  @override
  String daySheetSaved(String date) {
    return 'Shift on $date changed';
  }

  @override
  String daySheetResetDone(String date) {
    return 'Rhythm restored for $date';
  }

  @override
  String get settingsSectionShifts => 'Shift system';

  @override
  String get settingsEditShifts => 'Change rhythm and times';

  @override
  String get settingsShiftsNotSet => 'Not set up yet';

  @override
  String get habitNewTitle => 'New habit';

  @override
  String get habitEditTitle => 'Edit habit';

  @override
  String get habitName => 'Name';

  @override
  String get habitNameHint => 'e.g. walk 20 minutes';

  @override
  String get habitNameRequired => 'Please enter a name.';

  @override
  String get habitDescription => 'Note (optional)';

  @override
  String get habitIcon => 'Icon';

  @override
  String get habitColor => 'Colour';

  @override
  String get habitDueOn => 'Due on';

  @override
  String get habitDueEveryDay => 'Every day';

  @override
  String get habitDueOnShifts => 'Only on certain shifts';

  @override
  String get habitWeekdays => 'Only on weekdays (optional)';

  @override
  String get habitWeekdaysAny => 'Any weekday';

  @override
  String get habitRuleHint =>
      'Changes to the due rule apply from today. Past days are not re-evaluated.';

  @override
  String get habitArchive => 'Archive';

  @override
  String get habitArchiveBody =>
      'The habit disappears from the list. Its history stays in the statistics.';

  @override
  String get habitArchived => 'Habit archived';

  @override
  String get habitDelete => 'Delete permanently';

  @override
  String get habitDeleteBody =>
      'Every completion of this habit will be deleted. This cannot be undone.';

  @override
  String get habitDeleted => 'Habit deleted';

  @override
  String get habitSaved => 'Habit saved';

  @override
  String get habitShowArchived => 'Show archived';

  @override
  String get habitRestore => 'Restore';

  @override
  String get habitDueSummaryEveryDay => 'Every day';

  @override
  String habitDueSummaryShifts(String shifts) {
    return 'On: $shifts';
  }

  @override
  String get habitReorder => 'Reorder';

  @override
  String get todayHabitsSection => 'Habits today';

  @override
  String get todayHabitsNone => 'No habit is due today.';

  @override
  String todayHabitsProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String todayHabitDone(String name) {
    return '$name done';
  }

  @override
  String todayHabitUndone(String name) {
    return '$name reopened';
  }

  @override
  String a11yHabitToggle(String name, String state) {
    return '$name, $state';
  }

  @override
  String get a11yStateDone => 'done';

  @override
  String get a11yStateOpen => 'open';

  @override
  String get statsPeriod7 => '7 days';

  @override
  String get statsPeriod30 => '30 days';

  @override
  String get statsPeriod90 => '90 days';

  @override
  String get statsOverall => 'Overall';

  @override
  String get statsRate => 'Success rate';

  @override
  String statsDueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count due days',
      one: '1 due day',
    );
    return '$_temp0';
  }

  @override
  String statsCompleted(int done, int total) {
    return '$done of $total';
  }

  @override
  String get statsNotDue => 'Not due in this period';

  @override
  String get statsStreak => 'Current streak';

  @override
  String get statsBestStreak => 'Best streak';

  @override
  String statsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get statsByShift => 'By shift';

  @override
  String statsPercent(int value) {
    return '$value%';
  }

  @override
  String get reminderBodyPlain => 'Due today.';

  @override
  String reminderBodyWithShift(String shiftName) {
    return 'Due today ($shiftName).';
  }

  @override
  String get settingsRemindersToggle => 'Reminders';

  @override
  String get settingsRemindersOn => 'On – you\'ll be reminded of due habits.';

  @override
  String get settingsRemindersDenied =>
      'Permission denied. Enable notifications for Rytmavo in the system settings.';

  @override
  String get settingsRemindersHint =>
      'Reminders are set per habit. Android may deliver them a few minutes late to save battery.';

  @override
  String get habitReminder => 'Reminder';

  @override
  String get habitReminderOff => 'No reminder';

  @override
  String get habitReminderAt => 'Remind at';

  @override
  String get habitReminderPerShift => 'Time per shift';

  @override
  String get habitReminderGlobalOff => 'Reminders are turned off in Settings.';

  @override
  String get settingsVersionUnknown => 'Unknown';

  @override
  String get infoPrivacyTitle => 'Privacy';

  @override
  String get infoPrivacyBody =>
      'Last updated: October 2026\n\n# 1. Controller\n\nThe controller within the meaning of the General Data Protection Regulation (GDPR) is:\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nGermany\n\nPhone: +49 176 43594878\nE-mail: kontakt@resinovo.de\n\n# 2. Data protection officer\n\nNo data protection officer has been appointed, as the legal requirements for one are not met.\n\n# 3. The essentials\n\nRytmavo works entirely offline. There is no user account, no advertising, no tracking and no provider server. All data stays on your device. Data leaves the device only when you export or share a backup yourself.\n\n# 4. Local processing on the device\n\nThe app stores the following data only locally in the app\'s storage on your device: shift types with times and colours, rotation patterns and anchor date, day overrides, habits with rules and reminder times, daily completions, and app settings (language, theme, reminder status). This data is not transmitted to the provider. You can delete it item by item in the app, delete everything under Settings → Data, or uninstall the app. Whether device backups (e.g. iCloud, Google backup) include this data depends on your device and on Apple\'s or Google\'s rules.\n\nLegal basis: Art. 6 (1) (b) GDPR (providing the app\'s functions).\n\n# 5. Reminders (notifications)\n\nOn request the app schedules local reminders through your device\'s notification system and asks once for notification permission. No push service and no server is used; reminders are created and stay on the device. You can turn them off at any time in the app\'s or the device\'s settings.\n\n# 6. Device calendar (optional)\n\nOnly if you turn on “Show calendar appointments” under Settings → Device calendar does the app ask for access to your device calendar. It then reads the titles and times of appointments in the calendars you choose, to show them in the calendar view, flag overlaps with your shifts and, if you wish, remind you the evening before. Appointments are evaluated on the device only, never changed, not stored in the app and not transmitted. You can turn the feature off in the app or revoke access in the system settings at any time.\n\nLegal basis: Art. 6 (1) (a) GDPR (your consent by turning on the feature and granting calendar access).\n\n# 7. Backup, import and sharing\n\nA backup (JSON file) is created only on your instruction. When sharing, the app hands the file to the destination you choose (e.g. Files app, e-mail, cloud storage); from there the respective provider\'s privacy terms apply. On import the app reads only the file you select. The provider does not receive these files. The file is unencrypted.\n\n# 8. Purchase through the app stores\n\nThe app is purchased exclusively through the Apple App Store or Google Play. Apple or Google process your data as independent controllers under their own privacy policies. The provider receives no personal purchase data.\n\n# 9. No processing on provider servers\n\nAll features run on the device. Should server-based features be added in future, this privacy notice will be updated beforehand and shown in the app.\n\n# 10. Recipients and transfers to third countries\n\nNo data is transferred to third parties except to the destinations you choose when sharing, and to Apple or Google in the course of the purchase. The provider does not transfer data to third countries.\n\n# 11. Retention\n\nLocal data remains stored until you delete it or uninstall the app. E-mail enquiries to the provider are deleted once the matter is settled and no statutory retention obligations apply.\n\n# 12. No automated decision-making\n\nThere is no automated decision-making or profiling.\n\n# 13. Minors\n\nThe app is aimed at working adults. It is not intended for children under 13; no personal data of children is knowingly collected.\n\n# 14. Your rights\n\nYou have the right of access (Art. 15 GDPR), rectification (Art. 16), erasure (Art. 17), restriction of processing (Art. 18) and data portability (Art. 20), and the right to withdraw consent with effect for the future. Where processing is based on legitimate interests you may object at any time (Art. 21 GDPR). An e-mail to kontakt@resinovo.de is sufficient. As the app\'s data lives only on your device, you can view, export and delete it directly in the app.\n\n# 15. Right to lodge a complaint\n\nYou have the right to lodge a complaint with a data protection supervisory authority. The competent authority is the Landesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen, Kavalleriestraße 2–4, 40213 Düsseldorf, Germany.\n\n# 16. Changes to this privacy notice\n\nThis notice is updated when the legal situation, the technology or the app\'s features change. The current version is always available in the app under Settings → Privacy.';

  @override
  String get infoImprintTitle => 'Imprint';

  @override
  String get infoImprintBody =>
      'Information pursuant to § 5 DDG (German Digital Services Act)\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nGermany\n\n# Contact\n\nPhone: +49 176 43594878\nE-mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Legal form\n\nSole proprietorship\n\n# VAT ID\n\nVAT identification number pursuant to § 27a UStG: DE462344595\n\n# Responsible for content\n\nTim Kremers (address as above), also within the meaning of § 18 (2) MStV.\n\n# Consumer dispute resolution\n\nWe are neither obliged nor willing to take part in dispute resolution proceedings before a consumer arbitration board. The European Commission\'s online dispute resolution platform was discontinued on 20 July 2025.\n\n# Accessibility\n\nResinovo is a micro-enterprise within the meaning of the German Accessibility Improvement Act (BFSG) and therefore exempt from its requirements under § 3 (3) BFSG. We nevertheless aim for an accessible app (system font sizes, light and dark design, screen-reader labels). Please report barriers to kontakt@resinovo.de.\n\n# Liability for content\n\nAs a service provider we are responsible for our own content in this app under general law. The content was created with care; shift plans and statistics are planning aids and do not replace your employer\'s information.\n\n# Copyright\n\nContent and works created by the provider in this app are subject to German copyright law. Reproduction, editing, distribution and any kind of use beyond the limits of copyright require written consent. Third-party brand and product names are used for description only and remain the property of their owners.\n\n“Rytmavo” is a provisional working name.';

  @override
  String get infoSupportTitle => 'Support';

  @override
  String infoSupportBody(String version) {
    return 'For questions or problems, reach us at:\n\nE-mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Helpful in a request\n\nApp version: $version\n\nDescribe what you did and what happened instead. Please do not attach a backup file unless you want to share the data in it.\n\n# Back up your data\n\nYou can create a backup any time under Settings → Data → Export data.';
  }

  @override
  String get settingsSectionCalendar => 'Device calendar';

  @override
  String get calendarSyncToggle => 'Show calendar appointments';

  @override
  String get calendarSyncOn =>
      'On – appointments appear in the calendar; overlaps with shifts are flagged.';

  @override
  String get calendarSyncOff => 'Off – Rytmavo does not read any appointments.';

  @override
  String get calendarSyncDenied =>
      'No calendar access. Allow it for Rytmavo in the system settings.';

  @override
  String get calendarSyncOpenSettings => 'Open system settings';

  @override
  String get calendarSyncCalendars => 'Calendars';

  @override
  String get calendarSyncAllCalendars => 'All calendars';

  @override
  String calendarSyncSomeCalendars(int count, int total) {
    return '$count of $total calendars';
  }

  @override
  String get calendarSyncPickTitle => 'Choose calendars';

  @override
  String get calendarSyncPickApply => 'Apply';

  @override
  String get calendarSyncNoCalendars => 'No calendars found on this device.';

  @override
  String get calendarSyncReminder => 'Remind me the evening before';

  @override
  String get calendarSyncReminderOn =>
      'Notification at 6 pm on the day before the shift.';

  @override
  String get calendarSyncReminderNeedsReminders => 'Turn on reminders first.';

  @override
  String get calendarSyncHint =>
      'Rytmavo reads appointments only on this device, never changes them and does not store them. All-day events are shown but do not count as conflicts.';

  @override
  String get conflictsTitle => 'Appointment conflicts';

  @override
  String conflictDuringShift(String time, String shiftName) {
    return '$time · during $shiftName';
  }

  @override
  String get conflictUntitled => 'Untitled appointment';

  @override
  String reminderConflictTitle(String shiftName) {
    return 'Tomorrow: appointment during $shiftName';
  }

  @override
  String reminderConflictBodyOne(String title, String time, String shiftTime) {
    return '“$title” ($time) overlaps your shift ($shiftTime).';
  }

  @override
  String reminderConflictBodyMany(int count, String shiftTime) {
    return '$count appointments overlap your shift ($shiftTime).';
  }

  @override
  String get calendarHasEvents => 'Appointments';

  @override
  String get daySheetEvents => 'Appointments';

  @override
  String get eventAllDay => 'All day';
}
