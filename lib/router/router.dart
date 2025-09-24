import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_constants.dart';
import 'package:pikquick/errand_runer.dart/newtask/available_runner.dart.dart';
import 'package:pikquick/errand_runer.dart/errand_dashboard/errand_dashboard.dart';
import 'package:pikquick/errand_runer.dart/errand_menu/errand_more.dart';
import 'package:pikquick/errand_runer.dart/errand_notification.dart';
import 'package:pikquick/errand_runer.dart/onboarding/create_account.dart';
import 'package:pikquick/errand_runer.dart/wallet/errand_wallet.dart';
import 'package:pikquick/errand_runer.dart/onboarding/errand_varify.dart';
import 'package:pikquick/errand_runer.dart/onboarding/welcome2.dart';
import 'package:pikquick/errand_runer.dart/wallet/payment.dart';
import 'package:pikquick/errand_runer.dart/profile/my_profile.dart';
import 'package:pikquick/errand_runer.dart/profile/profile_empty.dart';
import 'package:pikquick/errand_runer.dart/wallet/request_payout.dart';
import 'package:pikquick/errand_runer.dart/reviews.dart';
import 'package:pikquick/errand_runer.dart/serviced_categories.dart';
import 'package:pikquick/errand_runer.dart/newtask/task_details.dart';
import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';
import 'package:pikquick/features/task/presentation/task_event.dart';
import 'package:pikquick/hire_an_errand.dart/clinet_taskhistory/client_task_hostoy.dart';
import 'package:pikquick/errand_runer.dart/runner_tasklist/runner_task_overview.dart';
import 'package:pikquick/errand_runer.dart/wallet/verify_payment.dart';
import 'package:pikquick/googlemap/google_map_polygon.dart';
import 'package:pikquick/hire_an_errand.dart/MainNavigationPage%202.dart';
import 'package:pikquick/hire_an_errand.dart/MainNavigationPage.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/notification/notification.dart';
import 'package:pikquick/hire_an_errand.dart/task_creation/input-task.dart';
import 'package:pikquick/hire_an_errand.dart/task_creation/set-budget.dart';
import 'package:pikquick/hire_an_errand.dart/task_creation/task-review.dart';
import 'package:pikquick/hire_an_errand.dart/task_creation/task_location.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/add-funds.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/delivery.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/dashboard.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/map.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/more.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/pay-method.dart';
import 'package:pikquick/errand_runer.dart/available_runner/runner_list.dart';
import 'package:pikquick/errand_runer.dart/available_runner/runner_profile_hired.dart';
import 'package:pikquick/errand_runer.dart/available_runner/runner_prrofile.dart';
import 'package:pikquick/hire_an_errand.dart/dashboard/featurestask.dart';
import 'package:pikquick/hire_an_errand.dart/wallet/wallet.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/welcome.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/account_salection.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/create_account.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/create_password.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/forget_password.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/login.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/reset_password.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/spashcreen.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/selection_page.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/varify.dart';
import 'package:pikquick/hire_an_errand.dart/onboarding/verify_forget.dart';
import 'package:pikquick/errand_runer.dart/runner_tasklist/runner_taskhistory.dart';
import 'package:pikquick/hire_an_errand.dart/clinet_taskhistory/reviews.dart';
import 'package:pikquick/hire_an_errand.dart/clinet_taskhistory/client_task_overview_detais.dart';
import 'package:pikquick/prmp_map_widgets/google_place_map_screen.dart';
import 'package:pikquick/mapbox_anew/map_box_full_map_widget.dart';
import 'package:pikquick/mapbox_anew/pre_map_page_for_testing.dart';
import 'package:pikquick/router/router_config.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: MyAppRouteConstant.login,
    routes: [
      GoRoute(
        name: MyAppRouteConstant.splashScreen,
        path: MyAppRouteConstant.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: MyAppRouteConstant.mapBoxFullMapWidget,
        path: MyAppRouteConstant.mapBoxFullMapWidget,
        builder: (context, state) => const GooglePlaceMapScreen(),
      ),

      GoRoute(
        name: MyAppRouteConstant.preMapPageForTesting,
        path: MyAppRouteConstant.preMapPageForTesting,
        builder: (context, state) => const PreMapPageForTesting(),
      ),
      GoRoute(
        name: MyAppRouteConstant.ressetPassword,
        path: MyAppRouteConstant.ressetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return RessetPassword(
            email: extra['email'] ?? '',
            token: extra['token'] ?? '',
          );
        },
      ),

      GoRoute(
        name: MyAppRouteConstant.login,
        path: MyAppRouteConstant.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.createPassword,
        path: MyAppRouteConstant.createPassword,
        builder: (context, state) => const CreatePassword(),
      ),
      GoRoute(
        name: MyAppRouteConstant.selction,
        path: MyAppRouteConstant.selction,
        builder: (context, state) => const SelectionPage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.accountSelection,
        path: MyAppRouteConstant.accountSelection,
        builder: (context, state) => const AccountSelection(),
      ),

      GoRoute(
        name: MyAppRouteConstant.errandwelcome,
        path: MyAppRouteConstant.errandwelcome,
        builder: (context, state) => const ErrandWelcomePage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.accountCreation,
        path: MyAppRouteConstant.accountCreation,
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.runnerAccountCreation,
        path: MyAppRouteConstant.runnerAccountCreation,
        builder: (context, state) => const CreateRunnerAccount(),
      ),
      GoRoute(
        name: MyAppRouteConstant.welcome,
        path: MyAppRouteConstant.welcome,
        builder: (context, state) => WelcomePage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.profilempty,
        path: MyAppRouteConstant.profilempty,
        builder: (context, state) => EditProfileSetup(),
      ),
      GoRoute(
        name: MyAppRouteConstant.taskHOverview,
        path: MyAppRouteConstant.taskHOverview,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic> && extra['taskId'] is String) {
            return TaskOverview(taskId: extra['taskId'] as String);
          }
          return const Scaffold(
            body: Center(child: Text('Invalid route arguments')),
          );
        },
      ),

      GoRoute(
        name: MyAppRouteConstant.runnerProfile,
        path: MyAppRouteConstant.runnerProfile,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          if (extra['userId'] is String) {
            return RunnerProfile(
              userId: extra['userId'] as String,
              taskId: '',
            );
          }

          return const Scaffold(
            body: Center(child: Text('Invalid route arguments')),
          );
        },
      ),

      // GoRoute(
      //   name: MyAppRouteConstant.taskCompleted,
      //   path: MyAppRouteConstant.taskCompleted,
      //   builder: (context, state) => ClientTaskOverviewProgress(
      //     taskStatus: '',
      //   ),
      // ),

      GoRoute(
        name: MyAppRouteConstant.runner,
        path: MyAppRouteConstant.runner,
        builder: (context, state) => ErrandRunnerScreen(),
      ),
      // GoRoute(
      //   name: MyAppRouteConstant.taskdetailsPage,
      //   path: MyAppRouteConstant.taskdetailsPage,
      //   builder: (context, state) => TaskDetailsPage(),
      // ),
      GoRoute(
        name: MyAppRouteConstant.runnerProfileHired,
        path: MyAppRouteConstant.runnerProfileHired,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          if (extra['userId'] is String) {
            return RunnerProfileHired(
              userId: extra['userId'] as String,
              taskId: extra['taskId'] as String,
            );
          }

          return const Scaffold(
            body: Center(child: Text('Invalid route arguments')),
          );
        },
      ),

      GoRoute(
        path: MyAppRouteConstant.clientTaskOverviewProgress,
        name: MyAppRouteConstant.clientTaskOverviewProgress,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final taskId = extra['taskId'] as String;
          return ClientTaskOverviewProgress(
              taskId: taskId); // pass to the screen
        },
      ),
      GoRoute(
        name: MyAppRouteConstant.runnerTaskdetails,
        path: MyAppRouteConstant.runnerTaskdetails,
        builder: (context, state) => const HireRunnerPage(),
      ),

      GoRoute(
        name: MyAppRouteConstant.taskDetails,
        path: MyAppRouteConstant.taskDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic> && extra.containsKey('taskId')) {
            final taskId = extra['taskId'] as String?;
            final amount = extra['amount'] as String?; // now nullable

            if (taskId != null) {
              return TaskDetailsPage(
                taskId: taskId,
                amount: amount, // can be null
              );
            }
          }
          return const Scaffold(
            body: Center(
              child: Text('Invalid or missing task ID.'),
            ),
          );
        },
      ),

      GoRoute(
        name: MyAppRouteConstant.reviews,
        path: MyAppRouteConstant.reviews,
        builder: (context, state) {
          final extra = state.extra as GetTaskOverviewEntity;
          return Reviews(
            review: extra,
          );
        },
      ),

      GoRoute(
          name: MyAppRouteConstant.runnerviews,
          path: MyAppRouteConstant.runnerviews,
          builder: (context, state) {
            final extra = state.extra as RunnerTaskOverviewEntity;
            return ErrandRunnerReviews(task: extra);
          }),

      GoRoute(
        name: MyAppRouteConstant.editProfile,
        path: MyAppRouteConstant.editProfile,
        builder: (context, state) => const MyProfile(),
      ),
      GoRoute(
        name: MyAppRouteConstant.verifyEmail,
        path: MyAppRouteConstant.verifyEmail,
        builder: (context, state) {
          final email = state.extra;
          final safeEmail = email is String ? email : '';

          return VerifyEmail(email: safeEmail);
        },
      ),

      // GoRoute(
      //   name: MyAppRouteConstant.taskHistory,
      //   path: MyAppRouteConstant.taskHistory,
      //   builder: (context, state) => const RunnerTaskHistory(
      //     id: '',
      //   ),
      // ),

      GoRoute(
          name: MyAppRouteConstant.forgetPasswordVerifyOtp,
          path: MyAppRouteConstant.forgetPasswordVerifyOtp,
          builder: (context, state) {
            final email = state.extra;
            final safeEmail = email is String ? email : '';

            return VerifyResetOtp(email: safeEmail);
          }),

      GoRoute(
        name: MyAppRouteConstant.errandVerify,
        path: MyAppRouteConstant.errandVerify,
        builder: (context, state) {
          final email = state.extra;
          final safeEmail = email is String ? email : '';

          return ErrandVerifyEmail(email: safeEmail);
        },
      ),
      // GoRoute(
      //   name: MyAppRouteConstant.inpuTaskloction,
      //   path: MyAppRouteConstant.inpuTaskloction,
      //   builder: (context, state) => const Tasklocation(),
      // ),
      GoRoute(
        name: MyAppRouteConstant.setBudget,
        path: MyAppRouteConstant.setBudget,
        builder: (context, state) => Setbudget(data: state.extra as Map),
      ),
      GoRoute(
        name: MyAppRouteConstant.taskreview,
        path: MyAppRouteConstant.taskreview,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return TaskReview(data: data);
        },
      ),

      GoRoute(
        name: MyAppRouteConstant.addfunds,
        path: MyAppRouteConstant.addfunds,
        builder: (context, state) => const AddFunds(),
      ),

      GoRoute(
          name: MyAppRouteConstant.google,
          path: MyAppRouteConstant.google,
          builder: (context, state) => GoogleMapPolygon()),
      GoRoute(
        name: MyAppRouteConstant.addpayment,
        path: MyAppRouteConstant.addpayment,
        builder: (context, state) => const PaymentMethod(),
      ),
      GoRoute(
        name: MyAppRouteConstant.accountPage,
        path: MyAppRouteConstant.accountPage,
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        name: MyAppRouteConstant.deliveryScreen,
        path: MyAppRouteConstant.deliveryScreen,
        builder: (context, state) => const DeliveryScreen(),
      ),
      GoRoute(
        name: MyAppRouteConstant.availabeTask,
        path: MyAppRouteConstant.availabeTask,
        builder: (context, state) => const AvailableTask(),
      ),
      GoRoute(
        name: MyAppRouteConstant.requestpayout,
        path: MyAppRouteConstant.requestpayout,
        builder: (context, state) => const RequestPayout(),
      ),
      GoRoute(
        name: MyAppRouteConstant.forgetPassword,
        path: MyAppRouteConstant.forgetPassword,
        builder: (context, state) => ForgetPasswordScreen(),
      ),
      GoRoute(
        name: MyAppRouteConstant.verifyPayment,
        path: MyAppRouteConstant.verifyPayment,
        builder: (context, state) => const VerifyPayment(
          email: '',
        ),
      ),

      GoRoute(
        name: MyAppRouteConstant.errandNotification,
        path: MyAppRouteConstant.errandNotification,
        builder: (context, state) => NotificationScreen(),
      ),

      GoRoute(
        name: MyAppRouteConstant.paymetmethod,
        path: MyAppRouteConstant.paymetmethod,
        builder: (context, state) => const AddPaymentMethodPage(),
      ),
      // GoRoute(
      //   name: MyAppRouteConstant.errandwallet,
      //   path: MyAppRouteConstant.errandwallet,
      //   builder: (context, state) => const ErrandWallet(),
      // ),
      GoRoute(
        name: MyAppRouteConstant.servicesCategories,
        path: MyAppRouteConstant.servicesCategories,
        builder: (context, state) => SavedCategoriesScreen(),
      ),
      // GoRoute(
      //   name: MyAppRouteConstant.errandAccountPage,
      //   path: MyAppRouteConstant.errandAccountPage,
      //   builder: (context, state) => ErrandAccountPage(),
      // ),
      //<meta-data android:name="com.google.android.geo.API_KEY" android:value="AIzaSyC48Z59K9ZtF32PaS0fNsz4VHMSrs4m5CE"/>

      GoRoute(
        name: MyAppRouteConstant.feauturedCategoriesTask,
        path: MyAppRouteConstant.feauturedCategoriesTask,
        builder: (context, state) => const FeatureTaskCategories(),
      ),

      GoRoute(
        name: MyAppRouteConstant.map,
        path: MyAppRouteConstant.map,
        builder: (context, state) => const ProfessionalMapScreen(),
      ),
      GoRoute(
        name: MyAppRouteConstant.clientNotification,
        path: MyAppRouteConstant.clientNotification,
        builder: (context, state) => CleintNotificatiion(),
      ),
      GoRoute(
        name: MyAppRouteConstant.tasklocation,
        path: MyAppRouteConstant.tasklocation,
        builder: (context, state) => Tasklocation(data: state.extra as Map),
      ),
      GoRoute(
        name: MyAppRouteConstant.hirerunnerPage,
        path: MyAppRouteConstant.hirerunnerPage,
        builder: (context, state) => const HireRunnerPage(),
      ),

      // first rounte section for client app
      StatefulShellRoute.indexedStack(
        redirect: (context, state) {
          return null;
        },
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: sectionNavigatorKey,
            initialLocation: MyAppRouteConstant.dashboard,
            routes: <RouteBase>[
              GoRoute(
                  name: MyAppRouteConstant.dashboard,
                  path: MyAppRouteConstant.dashboard,
                  builder: (context, state) {
                    final extra = state.extra;

                    if (extra is Map<String, dynamic>) {
                      final String? taskId = extra['taskId'] as String?;
                      final String? bidId = extra['bidId'] as String?;

                      if (taskId != null && taskId.isNotEmpty) {
                        return DashboardPage(
                          taskId: taskId,
                          bidId: bidId ?? '', // optional, empty if missing
                        );
                      }
                    }

                    return const Scaffold(
                      body: Center(
                        child: Text('Invalid or missing task ID.'),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: MyAppRouteConstant.selectLocation,
                      builder: (context, state) => const DeliveryScreen(),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.task,
                path: MyAppRouteConstant.task,
                builder: (context, state) => const ClientTaskHistory(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.wallet,
                path: MyAppRouteConstant.wallet,
                builder: (context, state) => const Wallet(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.more,
                path: MyAppRouteConstant.more,
                builder: (context, state) => const AccountPage(),
              ),
            ],
          ),
        ],
      ),

      // second route ...
      StatefulShellRoute.indexedStack(
        redirect: (context, state) {
          return null;
        },
        builder: (context, state, navigationShell) {
          return MainPage2(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: sectionNavigatorKey,
            initialLocation: MyAppRouteConstant.dashBoardScreen,
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.dashBoardScreen,
                path: MyAppRouteConstant.dashBoardScreen,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.taskHistoryrunner,
                path: MyAppRouteConstant.taskHistoryrunner,
                builder: (context, state) => RunnerTaskHistory(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.errandwallet,
                path: MyAppRouteConstant.errandwallet,
                builder: (context, state) => const ErrandWallet(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: MyAppRouteConstant.errandAccountPage,
                path: MyAppRouteConstant.errandAccountPage,
                builder: (context, state) => const ErrandAccountPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
