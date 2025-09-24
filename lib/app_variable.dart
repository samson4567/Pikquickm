import 'package:flutter/foundation.dart';
// import 'package:location/location.dart';
import 'package:pikquick/features/authentication/domain/entities/user_entity.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'package:pikquick/features/profile/domain/entities/getrunner_entity.dart';
import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart';
import 'package:pikquick/features/profile/domain/entities/runner_performance_entiy.dart';
import 'package:pikquick/features/task/data/model/taskcreation_model.dart';
import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/bid_history_entities.dart';
import 'package:pikquick/features/transaction/domain/entities/client_reviews_entity.dart';
import 'package:pikquick/features/transaction/domain/entities/user_address_enties.dart';
import 'package:pikquick/features/transaction/presentation/transaction_event.dart';
// import 'package:pikquick/mapbox/location_model.dart';
// import 'package:pikquick/mapbox/place.dart';
import 'package:pikquick/router/router_config.dart';

UserEntity? userModelG;
RunnerPerformanceEntity? runnerPerformance;
GetRunnerProfileEntity? getRunner;
RunnersAllDetailsEntity? allDetails;
PickupDropoffEntity? userAddress;
BidHistoryEntity? taskId;
ClientReviewEntity? review;
GetTaskOverviewEntity? taskoverview;

Map userDetail = {};

String currency = "₦";
String? serviceBeingFilled;

List<String> twoAddressedTaskCategory = [
  "Pick Up & Delivery",
  "Document & Dispatch",
  "Gift & Parcel",
];

Map unitsAndTheirShorts = {"liters": "L", "KG": "KG"};
// approiprate size
s(num size, context) {}
TaskModel? taskModelbeingCreated;
Color getFigmaColor(String value, [int percentageOpacity = 100]) {
  // 0xffvalue;
  return Color(int.parse("0xff$value"))
      .withAlpha((((255 * percentageOpacity) / 100).toInt()));
}

// iOSGoogleMapsApiKey: 'AIzaSyA9nGnj2gBvTVaOs7JGQJ-k7MSb38s5XOU',
//       androidGoogleMapsApiKey: 'AIzaSyC48Z59K9ZtF32PaS0fNsz4VHMSrs4m5CE',
//       webGoogleMapsApiKey: 'AIzaSyB8HleMVIdCs63wUFJHovORfuZ_vFD3S0M',

/// TODO:need to add company's detail
String get googleMapsApiKey {
  if (kIsWeb) {
    return 'AIzaSyB8HleMVIdCs63wUFJHovORfuZ_vFD3S0M';
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return '';
    case TargetPlatform.iOS:
      return 'AIzaSyA9nGnj2gBvTVaOs7JGQJ-k7MSb38s5XOU';
    case TargetPlatform.android:
      return 'AIzaSyC48Z59K9ZtF32PaS0fNsz4VHMSrs4m5CE';
    default:
      return 'AIzaSyB8HleMVIdCs63wUFJHovORfuZ_vFD3S0M';
  }
}

/// #IMPORTANT #URGENT #CRUCIAL ............

// FFPlace? ffPlace;
String? localFilePath;

Widget fancyContainer({
  Widget? child,
  double? radius,
  Color? backgroundColor,
  Color? borderColor,
  bool? hasBorder,
  double? height,
  double? width,
  Function(Object?)? action,
}) {
  hasBorder ??= false;
  borderColor ??= const Color(0xFF000000);
  return GestureDetector(
    onTap: () async {
      await action?.call(null);
    },
    child: Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8),
        color: backgroundColor,
        border: hasBorder
            ? Border.all(
                color: borderColor,
              )
            : null,
      ),
      child: child,
    ),
  );
}

class FancyContainer extends StatefulWidget {
  Widget? child;
  double? radius;
  Color? backgroundColor;
  Color? borderColor;
  bool? hasBorder;
  bool? isAsync;
  double? elevation;
  BorderRadius? rawBorderRadius;

  double? height;
  double? width;
  double? borderwidth;

  Function()? action;
  FancyContainer(
      {super.key,
      this.child,
      this.radius,
      this.backgroundColor,
      this.borderColor,
      this.hasBorder,
      this.height,
      this.width,
      this.action,
      this.borderwidth,
      this.elevation,
      this.isAsync,
      this.rawBorderRadius});

  @override
  State<FancyContainer> createState() => _FancyContainerState();
}

class _FancyContainerState extends State<FancyContainer> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    widget.hasBorder ??= false;
    widget.borderColor ??= const Color(0xFF000000);
    return GestureDetector(
      onTap: (widget.action != null)
          ? ((widget.isAsync ?? false)
              ? () async {
                  isLoading = true;
                  setState(() {});
                  await widget.action?.call();
                  isLoading = false;
                  setState(() {});
                }
              : () async {
                  await widget.action?.call();
                })
          : null,
      child: Container(
        alignment: Alignment.center,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            borderRadius: widget.rawBorderRadius ??
                BorderRadius.circular(widget.radius ?? 8),
            color: widget.backgroundColor,
            border: widget.hasBorder!
                ? Border.all(
                    color: widget.borderColor!,
                    width: widget.borderwidth ?? 1,
                  )
                : null,
            boxShadow: ((widget.elevation ?? 0) > 0)
                ? List.filled(
                    4,
                    BoxShadow(
                        offset: Offset(0, widget.elevation! * .7),
                        blurRadius: 1,
                        color: Colors.black.withAlpha(50)))
                : null),
        child: isLoading
            ? const AspectRatio(
                aspectRatio: 1 / 1,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : widget.child,
      ),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> sectionNavigatorKey =
    GlobalKey<NavigatorState>();

bool toPop = false;

// Widget buildBackArrow(BuildContext context) {
//   return Visibility(
//     visible: !(ModalRoute.of(context)?.isFirst ?? true),
//     child: Padding(
//       padding: const EdgeInsets.only(left: 18.0),
//       child: SizedBox(
//         height: 30,
//         width: 30,
//         child: GestureDetector(
//             onTap: () {
//               context.pop();
//             },
//             child: Image.asset(
//               "assets/icons/arrow.png",
//               fit: BoxFit.contain,
//             )),
//       ),
//     ),
//   );
// }

Widget buildBackArrow(
  BuildContext context, {
  Function()? replaceFunction,
  Function()? supplimentFunctionBefore,
  Function()? supplimentFunctionAfter,
}) {
  return Visibility(
    visible: !(ModalRoute.of(context)?.isFirst ?? true),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: SizedBox(
        height: 30,
        width: 30,
        child: GestureDetector(
            onTap: replaceFunction ??
                () {
                  supplimentFunctionBefore?.call();
                  context.pop();
                  supplimentFunctionAfter?.call();
                },
            child: Image.asset(
              "assets/icons/arrow.png",
              fit: BoxFit.contain,
            )),
      ),
    ),
  );
}

/// Global scaffold popup matter
GlobalKey<ScaffoldMessengerState> globalScaffoldKey =
    GlobalKey<ScaffoldMessengerState>();
SnackBar generalSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.blue,
  );
}

showSnackBar(String message, {BuildContext? context}) {
  final snackBar = generalSnackBar(message);
  ScaffoldMessenger.of(context ?? globalScaffoldKey.currentState!.context)
      .showSnackBar(snackBar);
  // ScaffoldMessenger.of()
  //     .showSnackBar(
  //   SnackBar(content: Text(message)),
  // );
}

// dart_firebase_admin config props

// incorrect

// otpStuff
String otpEmailVar = '';

// prelogin variable
bool isLoggedIn = false;

/// server detail
String baseURL = "https://flud-server.vercel.app";

dynamic handleJsonResponse(http.Response response,
    {Function(dynamic)? loggerFunction}) {
  print("zzz");
  dynamic jsonResponse;

  // custom_print(response., 'to inspect');

  jsonResponse = json.decode(response.body);
  print("yyyyy");
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
  } else {
    // avoid_print('Error: ${response.statusCode}');
  }
  print("xxxxx");

  try {
    jsonResponse = json.decode(jsonResponse);
  } catch (e) {}
  print("xxxxx");

  custom_print(jsonResponse, 'runtimeType');

  return jsonResponse;
}

void custom_print(Object? body, Object? s) {}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * .8,
      width: MediaQuery.of(context).size.width * .8,
      child: const Center(
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * .8,
      width: MediaQuery.of(context).size.width * .8,
      child: const Center(
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
    );
  }
}

// current location getter
// Location currentLocationHandler = Location();

String MAPBOX_ACCESS_TOKEN =
    "pk.eyJ1Ijoia2VkZXJreSIsImEiOiJjbWJveWx2eDkwMnNkMmpzYTlrZWFna3JtIn0.VDpxGWUJc345NFpU8XlugA";

/// this is to diff the service categories from each other

Map serviceNameAndTheNameOfTheirCategories = {
  // "serviceName":"CategoryName"
  "Car Wash": "Wash Type",
  "Fuel": "Delivery Type",
};

///device id shens

convertIntToBool(int integer) {
  if (integer > 0) return true;
  return false;
}

convertBoolToInt(bool bol) {
  if (bol) return 1;
  return 0;
}

/// empty widget
Widget buildEmptyWidget(String message, [Widget? actionChild]) {
  return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(
      Icons.emoji_objects_sharp,
      size: 50,
      color: Colors.blue,
    ),
    const SizedBox(height: 20),
    Text(message),
    const SizedBox(height: 20),
    if (actionChild != null) actionChild
  ]));
}

double taxes = 100;

double? amountToAdd;

Object? functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
    Object? decodedData) {
  return (decodedData == null)
      ? decodedData
      : json.decode(decodedData as String);
}

// LocationModel dummyVendorLocationModel = LocationModel(
//     latLng: [7.5174, 4.5228],
//     fullAddress: "fullAddress",
//     id: const Uuid().v4());
// LocationModel testLocationModel = LocationModel(
//     latLng: [7.482055525912886, 4.56014292432563],
//     fullAddress: "fullAddress",
//     id: const Uuid().v4());

// datePikerFunction

Future<DateTime?> pickDateTime(BuildContext context) async {
  DateTime? selectedDateTime;
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }
  return selectedDateTime;
}

String homeRoute = MyAppRouteConstant.dashBoardScreen;

// Location currentLocationHandler = Location();
