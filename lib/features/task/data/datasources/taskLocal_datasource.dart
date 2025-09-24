import 'package:pikquick/core/db/app_preference_service.dart';

abstract class TaskLocalDatasource {}

class TasklocalDatasourceDatasourceImpl implements TaskLocalDatasource {
  final AppPreferenceService appPreferenceService;
  TasklocalDatasourceDatasourceImpl({
    required this.appPreferenceService,
  });
}
