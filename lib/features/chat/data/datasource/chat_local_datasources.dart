import 'package:pikquick/core/db/app_preference_service.dart';

abstract class ChatLocalDatasources {}

class ChatLocalDatasourcesIml implements ChatLocalDatasources {
  final AppPreferenceService appPreferenceService;
  ChatLocalDatasourcesIml({required this.appPreferenceService});
}
