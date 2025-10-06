import 'package:pikquick/core/db/app_preference_service.dart';

abstract class WalletLocalDatasources {}

class WalletLocalDatasourcesIml implements WalletLocalDatasources {
  final AppPreferenceService appPreferenceService;
  WalletLocalDatasourcesIml({required this.appPreferenceService});
}
