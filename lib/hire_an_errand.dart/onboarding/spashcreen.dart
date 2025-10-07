import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/core/di/injector.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
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
        bool isloggedIn = await context
            .read<AuthBloc>()
            .authenticationRepository
            .getRemainLoggedinvalue();
        if (isloggedIn) {
          UserModel? user = userModelG = await context
              .read<AuthBloc>()
              .authenticationRepository
              .getCachedUserData();

          if (user!.role == 'client') {
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
