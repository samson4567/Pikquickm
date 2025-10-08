import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pikquick/core/api/pickquick_network_client.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:pikquick/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pikquick/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/chat/data/datasource/chat_local_datasources.dart';
import 'package:pikquick/features/chat/data/datasource/chat_romote_datasources.dart';
import 'package:pikquick/features/chat/domain/repositories/chat_repository.dart';
import 'package:pikquick/features/chat/presentation/chat_bloc.dart';
import 'package:pikquick/features/profile/data/datasource/profile_local_datasources.dart';
import 'package:pikquick/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:pikquick/features/profile/data/repositories/profile_repositories.dart';
import 'package:pikquick/features/profile/domain/repositories/profile_repositires.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/task/data/repositories/task_repository_impl.dart';
import 'package:pikquick/features/task/data/datasources/taskLocal_datasource.dart';
import 'package:pikquick/features/task/data/datasources/task_remote_datasource.dart';
import 'package:pikquick/features/task/domain/repository/repository.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/transaction/data/datasources/transaction_local_datasources.dart';
import 'package:pikquick/features/transaction/data/datasources/transaction_remote_datasources.dart';
import 'package:pikquick/features/transaction/data/repositories/trannsaction_repo.dart';
import 'package:pikquick/features/transaction/domain/repositories/transaction_repo.dart';
import 'package:pikquick/features/transaction/presentation/transaction_bloc.dart';
import 'package:pikquick/features/wallet/data/datasource/wallet_local_datasources.dart';
import 'package:pikquick/features/wallet/data/datasource/wallet_romote_datasources.dart';
import 'package:pikquick/features/wallet/data/repositories/wallet_repositoryImpl.dart';
import 'package:pikquick/features/wallet/domain/repositories/walle_repo.dart';
import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';

final getItInstance = GetIt.I;

Future<void> init() async {
  // Register AppPreferenceService as an async singleton
  getItInstance.registerSingletonAsync<AppPreferenceService>(() async {
    final service = AppPreferenceService();
    await service.init();
    return service;
  });

  await getItInstance.isReady<AppPreferenceService>();

  getItInstance.registerLazySingleton<Dio>(() => Dio());

  getItInstance.registerLazySingleton<PikquickNetworkClient>(() =>
      PikquickNetworkClient(
          dio: getItInstance<Dio>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));
// Authentication
  getItInstance.registerLazySingleton<AuthenticationRemoteDatasource>(() =>
      AuthenticationRemoteDatasourceImpl(
          networkClient: getItInstance<PikquickNetworkClient>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<AuthenticationLocalDatasource>(() =>
      AuthenticationLocalDatasourceImpl(
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(
          authenticationRemoteDatasource:
              getItInstance<AuthenticationRemoteDatasource>(),
          authenticationLocalDatasource:
              getItInstance<AuthenticationLocalDatasource>()));

  getItInstance.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authenticationRepository: getItInstance<AuthenticationRepository>(),
    ),
  );

  // profile
  // Profile

  getItInstance.registerLazySingleton<ProfileRemoteDatasource>(() =>
      ProfileRemoteDatasourceImpl(
          networkClient: getItInstance<PikquickNetworkClient>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<ProfileLocalDatasources>(() =>
      ProfileLocalDatasourcesImpl(
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance
      .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
            profileRemoteDatasource: getItInstance<ProfileRemoteDatasource>(),
            profileLocalDatasources: getItInstance<ProfileLocalDatasources>(),
          ));

  getItInstance.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      profileRepository: getItInstance<ProfileRepository>(),
    ),
  );

  //transaction
  getItInstance.registerLazySingleton<TransactionRemoteDatasources>(() =>
      TransactionRemoteDatasourcesImpl(
          networkClient: getItInstance<PikquickNetworkClient>(),
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<TransactionLocalDatasources>(() =>
      TransactionLoacalDatasourcesiImpl(
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<TransactionRepository>(
      () => TrannsactionRepositoryImpl(
            transactionRemoteDatasources:
                getItInstance<TransactionRemoteDatasources>(),
            transactionLocalDatasources:
                getItInstance<TransactionLocalDatasources>(),
          ));

  getItInstance.registerLazySingleton<TransactionBloc>(
    () => TransactionBloc(
      transactionRepository: getItInstance<TransactionRepository>(),
    ),
  );

// Task
  getItInstance.registerLazySingleton<TaskRemoteDatasource>(
      () => TaskRemoteDatasourceIpl(
            networkClient: getItInstance<PikquickNetworkClient>(),
            appPreferenceService: getItInstance<AppPreferenceService>(),
          ));
  getItInstance.registerLazySingleton<TaskLocalDatasource>(() =>
      TasklocalDatasourceDatasourceImpl(
          appPreferenceService: getItInstance<AppPreferenceService>()));

  getItInstance.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
      taskRemoteDatasource: getItInstance<TaskRemoteDatasource>(),
      taskLocalDatasource: getItInstance<TaskLocalDatasource>()));
  getItInstance.registerLazySingleton<TaskBloc>(() => TaskBloc(
        taskRepository: getItInstance<TaskRepository>(),
      ));

  // wallet
  getItInstance.registerLazySingleton<WalletRomoteDatasources>(
      () => WalletRemoteDatasourcesImpl(
            networkClient: getItInstance<PikquickNetworkClient>(),
            appPreferenceService: getItInstance<AppPreferenceService>(),
          ));

  getItInstance.registerLazySingleton<WalletLocalDatasources>(
      () => WalletLocalDatasourcesIml(
            appPreferenceService: getItInstance<AppPreferenceService>(),
          ));
  getItInstance.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      walletRemoteDatasource: getItInstance<WalletRomoteDatasources>(),
      walletLocalDatasource: getItInstance<WalletLocalDatasources>(),
    ),
  );
  getItInstance.registerLazySingleton<WalletBloc>(() => WalletBloc(
        walletRepository: getItInstance<WalletRepository>(),
      ));

  // Chat
  // getItInstance.registerLazySingleton<ChatRomoteDatasources>(
  //     () => ChatRemoteDatasourcesImpl(
  //           networkClient: getItInstance<PikquickNetworkClient>(),
  //           appPreferenceService: getItInstance<AppPreferenceService>(),
  //         ));

  // getItInstance.registerLazySingleton<ChatLocalDatasources>(
  //     () => ChatLocalDatasourcesIml(
  //           appPreferenceService: getItInstance<AppPreferenceService>(),
  //         ));
  // getItInstance.registerLazySingleton<ChatRepository>(
  //   () => ChatRepositoryImpl(
  //     ChatRemoteDatasource: getItInstance<ChatRomoteDatasources>(),
  //     ChatLocalDatasource: getItInstance<ChatLocalDatasources>(),
  //   ),
  // );
  getItInstance.registerLazySingleton<ChatBloc>(() => ChatBloc(

      //  : getItInstance<ChatRepository>(),
      ));
}
