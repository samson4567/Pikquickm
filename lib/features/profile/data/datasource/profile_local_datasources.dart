import 'package:pikquick/core/db/app_preference_service.dart';

abstract class ProfileLocalDatasources {}

class ProfileLocalDatasourcesImpl implements ProfileLocalDatasources {
  final AppPreferenceService appPreferenceService;

  ProfileLocalDatasourcesImpl({
    required this.appPreferenceService,
  });
}
