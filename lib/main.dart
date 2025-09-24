import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/features/task/presentation/task_bloc.dart';
import 'package:pikquick/features/transaction/presentation/transaction_bloc.dart';
import 'package:pikquick/features/wallet/presentation/wallet_bloc.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_cubit.dart';
import 'package:pikquick/router/router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

bool hasInternet = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MapboxOptions.setAccessToken(MAPBOX_ACCESS_TOKEN);
  await init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final InternetConnectionCheckerPlus internetConnection =
  //     InternetConnectionCheckerPlus.createInstance();
  // StreamSubscription<InternetConnectionStatus>? streamSubscription;

  @override
  void initState() {
    super.initState();

    // internetConnection.hasConnection.then((value) {
    //   hasInternet = value;
    //   debugPrint("Initial Internet Access: $value");
    // });

    // streamSubscription = internetConnection.onStatusChange.listen((status) {
    //   hasInternet = status == InternetConnectionStatus.connected;
    //   debugPrint("Internet status changed: $status");
    // });
  }

  @override
  void dispose() {
    // streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getItInstance<AuthBloc>()),
        BlocProvider(create: (_) => getItInstance<ProfileBloc>()),
        BlocProvider(create: (_) => getItInstance<TaskBloc>()),
        BlocProvider(create: (_) => getItInstance<WalletBloc>()),
        BlocProvider(create: (_) => getItInstance<TransactionBloc>()),
        BlocProvider(create: (_) => PrmpMapCubit())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'PikQuick',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
