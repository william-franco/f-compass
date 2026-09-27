import 'package:f_compass/src/common/services/storage_service.dart';
import 'package:f_compass/src/features/compass/repositories/compass_repository.dart';
import 'package:f_compass/src/features/compass/view_models/compass_view_model.dart';
import 'package:f_compass/src/features/settings/repositories/setting_repository.dart';
import 'package:f_compass/src/features/settings/view_models/setting_view_model.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startStorageService();
  _startFeatureCompass();
  _startFeatureSetting();
}

void _startStorageService() {
  locator.registerLazySingleton<StorageService>(() => StorageServiceImpl());
}

void _startFeatureCompass() {
  locator.registerCachedFactory<CompassRepository>(() => CompassRepositoryImpl());
  locator.registerLazySingleton<CompassViewModel>(
    () => CompassViewModelImpl(compassRepository: locator<CompassRepository>()),
  );
}

void _startFeatureSetting() {
  locator.registerCachedFactory<SettingRepository>(
    () => SettingRepositoryImpl(storageService: locator<StorageService>()),
  );
  locator.registerLazySingleton<SettingViewModel>(
    () => SettingViewModelImpl(settingRepository: locator<SettingRepository>()),
  );
}

Future<void> initDependencies() async {
  await locator<StorageService>().initStorage();
  await locator<SettingViewModel>().getTheme();
}
