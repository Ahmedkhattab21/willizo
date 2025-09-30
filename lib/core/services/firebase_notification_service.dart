// import 'dart:convert';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_app/config/routes/routes.dart';
// import 'package:smart_app/core/services/cache_helper.dart';
// import 'package:smart_app/core/services/local_notification_service.dart';
// import 'package:smart_app/core/utils/constant_keys.dart';
// import 'package:smart_app/features/sponsor/sponsor_button_navigation_bar/logic/sponsor_button_navigation_bar_cubit.dart';
// import 'package:smart_app/my_app.dart';
//
// class FirebaseNotificationService {
//   static final _firebaseMessage = FirebaseMessaging.instance;
//
//   static Future<void> init() async {
//     try {
//       await _firebaseMessage.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//       await getDeviceToken();
//
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print(' on message  onMessage onMessage onMessage onMessage');
//         debugPrint("on Tap on Tap on Tap on Tap onMessage   ${message.data}");
//         // MyOrdersAdminCubit.get(context).getOrders();
//
//         if (!Platform.isIOS) {
//           LocalNotificationService.showNotification(
//             title: message.notification!.title.toString(),
//             body: message.notification!.body.toString(),
//             payload: message.data.map(
//               (key, value) => MapEntry(key.toString(), value.toString()),
//             ),
//           );
//         }
//       });
//
//       _firebaseMessage.getInitialMessage().then((RemoteMessage? message) async {
//         ///when open app get the
//         print(
//           "getInitialMessage getInitialMessage getInitialMessage${message?.data}",
//         );
//         // int userType = await CacheHelper.getInt(
//         //   ConstantKeys.saveUserTypoToShared,
//         // )??1;
//         if (message != null) {
//           ///user -- sponsor
//           ///chat details booking
//           //
//
//           String? userType = await CacheHelper.getSecuredString(
//             ConstantKeys.saveUserTypeToShared,
//           );
//
//           if (userType != null && navigatorKey.currentContext != null) {
//             if (userType == 'client') {
//               if (message.data['subject_type'] == 'chatroom') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': true,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'chatdirect') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': false,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'Booking') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.userMyBookingScreen,
//                 );
//               }
//             } else {
//               if (message.data['subject_type'] == 'chatroom') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                 );
//
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': true,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'chatdirect') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': false,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'Booking') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                   arguments: {'idGuest': false},
//                 );
//
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorMyBookingScreen,
//                   arguments: {'isPending': true},
//                 );
//               }
//             }
//           }
//         }
//       });
//
//       FirebaseMessaging.onMessageOpenedApp.listen((message) async {
//         ///on tap form back ground
//         debugPrint(
//           "on Tap on Tap on Tap on Tap onMessageOpenedApp  ${message.data}",
//         );
//         debugPrint("on Tap on Tap on Tap on Tap onMessageOpenedApp  $message");
//         debugPrint(
//           "on Tap on Tap on Tap on Tap onMessageOpenedApp  ${navigatorKey.currentContext}",
//         );
//
//         if (message != null) {
//           String? userType = await CacheHelper.getSecuredString(
//             ConstantKeys.saveUserTypeToShared,
//           );
//
//           if (userType != null && navigatorKey.currentContext != null) {
//             if (userType == 'client') {
//               if (message.data['subject_type'] == 'chatroom') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': true,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'chatdirect') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': false,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'Booking') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.buttonNavigationBarScreen,
//                   arguments: {'idGuest': false},
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.userMyBookingScreen,
//                 );
//               }
//             } else {
//               if (message.data['subject_type'] == 'chatroom') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                 );
//
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': true,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'chatdirect') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                 );
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.chatDetailsScreen,
//                   arguments: {
//                     'id':
//                         int.tryParse(message.data['subject_id'].toString()) ??
//                         0,
//                     'isRoom': false,
//                   },
//                 );
//               } else if (message.data['subject_type'] == 'Booking') {
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorButtonNavigationBarSceen,
//                   arguments: {'idGuest': false},
//                 );
//
//                 Navigator.pushNamed(
//                   navigatorKey.currentContext!,
//                   Routes.sponsorMyBookingScreen,
//                   arguments: {'isPending': true},
//                 );
//               }
//             }
//           }
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static Future<String> getDeviceToken() async {
//     String? token = await _firebaseMessage.getToken();
//     if (token == null) return "";
//     print("token $token");
//     return token;
//   }
// }
