import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/component/free.dart';
import 'package:pikquick/core/constants/svgs.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:pikquick/screen_test/test_site.dart';

class SelfieVerificationPage extends StatefulWidget {
  const SelfieVerificationPage({super.key});

  @override
  State<SelfieVerificationPage> createState() => _SelfieVerificationPageState();
}

class _SelfieVerificationPageState extends State<SelfieVerificationPage> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // .then((_) {
        //   if (!mounted) {
        //     return;
        //   }
        //   setState(() {});
        // }).catchError((Object e) {
        //   if (e is CameraException) {
        //     switch (e.code) {
        //       case 'CameraAccessDenied':
        //         // Handle access errors here.
        //         break;
        //       default:
        //         // Handle other errors here.
        //         break;
        //     }
        //   }
        // });
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          // buildWhole(),
          Center(
        child: buildWhole(),
      ),
    );
  }

  Stack _buildSelectedImagePage() {
    return Stack(
      children: [
        if (imagePath != null) Center(child: Image.file(File(imagePath!))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FancyContainer2(
                  action: () {
                    imagePath = null;
                    setState(() {});
                  },
                  width: 58,
                  height: 58,
                  radius: 58,
                  backgroundColor: Colors.white.withOpacity(.2),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                  if (state is UploadkycDocumentErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                  if (state is UploadkycDocumentSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    context.pop();
                  }
                }, builder: (context, state) {
                  return FancyContainer2(
                    action: () async {
                      // UploadkycDocumentEvent
                      File fileToBeUplloaded = File(imagePath!);

                      if (fileToBeUplloaded.lengthSync() / (1024 * 1024) > .7) {
                        String fileName =
                            fileToBeUplloaded.path.split('/').last;
                        String newFileName =
                            "${fileName.split('.').sublist(0, fileName.split('.').length - 1).join('.')}_compressed.${fileName.split('.').last}";
                        String newFilePath =
                            "${fileToBeUplloaded.path.split('/').sublist(0, fileToBeUplloaded.path.split('/').length - 1).join('/')}$newFileName";
                        fileToBeUplloaded = await compressAndGetFile(
                                fileToBeUplloaded, newFilePath) ??
                            fileToBeUplloaded;
                      }
                      selfieVerificationKycRequestEntity!.file =
                          fileToBeUplloaded;
                      context.read<AuthBloc>().add(
                            UploadkycDocumentEvent(
                                kycRequestEntity:
                                    selfieVerificationKycRequestEntity!),
                          );

                      // context.pop(imagePath!);
                      // KycRequestEntity;
                    },
                    width: 58,
                    height: 58,
                    radius: 58,
                    backgroundColor: Colors.white.withOpacity(.2),
                    child: state is UploadkycDocumentLoadingState
                        ? CircularProgressIndicator.adaptive()
                        : Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          ),
                  );
                }),

                // FancyContainer2(
                //   action: () {
                //     context.pop(imagePath!);
                //   },
                //   width: 58,
                //   height: 58,
                //   radius: 58,
                //   backgroundColor: Colors.white.withOpacity(.2),
                //   child: Icon(
                //     Icons.check_rounded,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bool isfront = false;
  Padding _buildFrontWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(captureFrame_selfie),
          SizedBox(height: 10),
          FancyText(
            "Align your face in the middle",
            textColor: Colors.white,
            size: 20,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          FancyText(
            "Make sure your face is within the box and capture a photo.",
            textColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          _buildSnapButton()
        ],
      ),
    );
  }

  FancyContainer2 _buildSnapButton() {
    return FancyContainer2(
      action: () async {
        final file = await controller?.takePicture();
        imagePath = file?.path;
        print("adklasdljsdn>>${file?.path}");
        setState(() {});
      },
      radius: 40,
      borderwidth: 2,
      nulledAlign: true,
      hasBorder: true,
      borderColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FancyContainer2(
          height: 55,
          width: 55,
          radius: 55,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  FutureBuilder<String?> buildWhole() {
    return FutureBuilder<String?>(
        future: () async {
          _cameras = await availableCameras();
          controller = CameraController(
            _cameras[isfront ? 0 : 1],
            ResolutionPreset.max,
          );
          await controller!.initialize();
          return "";
        }.call(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: (imagePath == null)
                    ? Container(
                        color: Colors.black,
                        child: Stack(
                          children: [
                            Center(child: CameraPreview(controller!)),
                            _buildFrontWidget(),
                          ],
                        ),
                      )
                    : _buildSelectedImagePage()
                // FancyContainer2(
                //     action: () {
                //       imagePath = null;
                //       setState(() {});
                //     },
                //     child: Image.file(File(imagePath!)))
                );
          }
          return CircularProgressIndicator.adaptive();
        });
  }

  FancyContainer2 _cameraWidget() {
    return FancyContainer2(
        action: () async {
          final file = await controller?.takePicture();
          imagePath = file?.path;
          print("adklasdljsdn>>${file?.path}");
          setState(() {});
        },
        backgroundColor: Colors.red,
        child:
            //  Text("data,${controller?.description}")
            CameraPreview(controller!)
        //     CameraPreview(
        //   controller!,
        //   // child:
        //   // Text("data,${controller?.description}"),
        // ),
        );
  }

  String? imagePath;
}
