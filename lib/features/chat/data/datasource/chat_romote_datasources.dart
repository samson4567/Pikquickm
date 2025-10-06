import 'package:pikquick/core/db/app_preference_service.dart';

abstract class ChatRomoteDatasources {}

class ChatRomoteDatasourcesIml implements ChatRomoteDatasources {
  final AppPreferenceService appPreferenceService;
  ChatRomoteDatasourcesIml({required this.appPreferenceService});
}
