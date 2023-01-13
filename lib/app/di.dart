import 'package:get_it/get_it.dart';
import 'package:med/app/preferences.dart';
import 'package:med/domain/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  final NotificationService notificationService = NotificationService();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  instance.registerLazySingleton<AppPreferences>(
          () => AppPreferences(instance<SharedPreferences>()));

  instance.registerLazySingleton<NotificationService>(
          () => notificationService);
}
