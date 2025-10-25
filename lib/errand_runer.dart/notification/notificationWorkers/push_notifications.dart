import 'dart:convert';

// import 'package:local_notification/local_notification.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/errand_runer.dart/notification/notificationModel.dart';
import 'package:pikquick/errand_runer.dart/notification/notificationWorkers/local_notification.dart';
import 'package:pikquick/router/router_config.dart';

class PushNotificationsService {
  //create an instance of the firebase messaging plugin
  static final _firebaseMessaging = FirebaseMessaging.instance;

  //initialize the firebase messaging (request permission for notifications)

  static Future<void> init() async {
    print("sjdbjdbshdsdjhsdbabsd");
    //request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    print("sjdbjdbshdsdjhsdbabsd-2");
    //check if the permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print("sjdbjdbshdsdjhsdbabsd-3");

    //get the FCM (Firebase Cloud Messagin) token from the device
    String? token = await _firebaseMessaging.getToken();
    print("sjdbjdbshdsdjhsdbabsd-token_is>>${token}");
    thetoken = token
        // this is for testing.
        ??
        "";

    // print('FCM Token: $token');
  }

  // static storeToken(token) {
  //   userHandlerGlobal.userDetail["FCMToken"] = token;
  //   SimplePersistentOfflineStorageHandler().save<String>("FCMToken", token);
  //   FirebaseDBHandler().updateData(
  //       "users", userHandlerGlobal.PID, userHandlerGlobal.userDetail);
  // }

  //funtion that will listen for incoming messages in background
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      // message.notification.;
      NotificationModel incomingNotificationModel =
          NotificationModel.fromRemoteNotificationObject(
              notification: message.notification!, remoteMessage: message);
      // HandlerOfNotification()
      //     .listOfNotifications
      //     .add(incomingNotificationModel);

      // print('Background message: ${message.notification!.title}');
    }
  }

  // on background notification tapped function (pass the payload data to the message opener screen)
  static Future<void> onBackgroundNotificationTapped(
      RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
    GoRouter.of(navigatorKey.currentState!.context).push(
      (userModelG?.role == "client")
          ? MyAppRouteConstant.clientNotification
          : MyAppRouteConstant.errandNotification,
    );

    // navigatorKey.currentState!.context.pushNamed(
    //   MyAppRouteConstant.notificationPage,
    //   // '/message', arguments: message
    // );
  }

  //handle foreground notifications
  static Future<void> onForeroundNotificationTapped(
    RemoteMessage message,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    String payloadData = jsonEncode(message.data);

    print("Got the message in foreground");
    print("String payloadData = jsonEncode(message.data);>>${message.data}");

    if (message.notification != null) {
      await LocalNotificationService.showInstantNotificationWithPayload(
        title: message.notification?.title ?? "anon",
        body: message.notification?.body ?? "anon message",
        payload: payloadData,
      );

      // TODO:Here to click the notification we can toggle the :onDidReceiveNotificationResponse: property in the localnotifications init function but will teach that in the lesson to avoid coflicts
      // here is the methode
// LocalNotificationService.flutterLocalNotificationsPlugin.initialize();
      // on tap local notification in foreground
      // static void onNotificationTap(NotificationResponse notificationResponse) {
      //   navigatorKey.currentState!
      //       .pushNamed("/message", arguments: notificationResponse);
      // }
//  LocalNotificationService.onDidReceiveBackgroundNotificationResponse= void onNotificationTap(NotificationResponse notificationResponse) {
//       navigatorKey.currentState!
//           .pushNamed("/message", arguments: notificationResponse);
      // }
      //this will automatically display the payload page

      // await navigatorKey.currentState!.context.pushNamed(
      //   MyAppRouteConstant.notificationPage,
      //   // extra: message
      // );
    }
  }
}

String? thetoken;
