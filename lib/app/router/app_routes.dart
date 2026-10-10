/// Route paths and names. Keep every navigation call on these constants.
abstract final class AppRoutes {
  static const String today = '/today';
  static const String calendar = '/calendar';
  static const String habits = '/habits';
  static const String insights = '/insights';
  static const String settings = '/settings';
  static const String settingsInfo = '/settings/info/:kind';
  static String settingsInfoPath(String kind) => '/settings/info/$kind';
  static const String onboarding = '/onboarding';
  static const String habitNew = '/habits/new';
  static const String habitEdit = '/habits/:id/edit';

  static String habitEditPath(String id) => '/habits/$id/edit';
}
