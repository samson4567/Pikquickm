import 'package:pikquick/core/db/app_preference_service.dart';

abstract class TransactionLocalDatasources {}

class TransactionLoacalDatasourcesiImpl implements TransactionLocalDatasources {
  final AppPreferenceService appPreferenceService;

  TransactionLoacalDatasourcesiImpl({
    required this.appPreferenceService,
  });
}
