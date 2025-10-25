import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/security/secure_key.dart';
import 'package:pikquick/errand_runer.dart/notification/notificationWorkers/push_notifications.dart';
import 'package:pikquick/features/authentication/data/models/refrresh_toke_model.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/profile/presentation/profile_bloc.dart';
import 'package:pikquick/router/router_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        print("jdasjdbksjdkabjd>>started");
        bool isloggedIn = await context
            .read<AuthBloc>()
            .authenticationRepository
            .getRemainLoggedinvalue();

        print("jdasjdbksjdkabjd>>isloggedIn>>${isloggedIn}");
        if (isloggedIn) {
          context.read<AuthBloc>().add(AddOrUpdateFCMTokenEvent(
                  fcmToken:
                      thetoken!) // theToken must have been initialized here

              );

          UserModel? user = userModelG = await context
              .read<AuthBloc>()
              .authenticationRepository
              .getCachedUserData();
          await refreshAccessToken();
          // context.read<AuthBloc>().authenticationRepository.cacheUserData();
          print("jdasjdbksjdkabjd>>user_${user}");
          if (user!.role == 'client') {
            userModelG = await context
                .read<ProfileBloc>()
                .profileRepository
                .getUserProflePlain(userID: user.id, isByRunner: false);
            context.go(
              MyAppRouteConstant.dashboard,
              extra: {
                'taskId': '39a9e988-1a3c-414e-9f1c-84c8ada685c3',
                'bidId': '8fb5eba5-6764-4493-bf5f-046998010bf1'
              },
            );
            return;
          }

          if (user.role == 'runner') {
            userModelG = await context
                .read<ProfileBloc>()
                .profileRepository
                .getUserProflePlain(userID: user.id, isByRunner: true);
            context.go(MyAppRouteConstant.dashBoardScreen);
            return;
          }
        } else {
          context.goNamed(MyAppRouteConstant.selction);
          context.push(MyAppRouteConstant.login);
        }
      },
    );
  }

  Future<void> refreshAccessToken() async {
    print("dskndkjshdajsbdkbd-refreshAccessToken-started");
    final appPref = AppPreferenceService();
    final refreshToken = appPref.getValue<String>(SecureKey.refreshTokenKey);
    print(
        "dskndkjshdajsbdkbd-refreshAccessToken-refreshToken_is>>${refreshToken}");
    if (refreshToken != null && refreshToken.isNotEmpty) {
      String erow = await context
          .read<AuthBloc>()
          .authenticationRepository
          .refreshTokenPlain(refreshToken: refreshToken);
      print("dskndkjshdajsbdkbd-refreshAccessToken-erow_is>>${erow}");
      await appPref.saveValue<String>(SecureKey.loginAuthTokenKey, erow);
      print("dskndkjshdajsbdkbd-refreshAccessToken-saveValue_done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
