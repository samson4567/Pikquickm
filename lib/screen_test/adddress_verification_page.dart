import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/component/fancy_text.dart';
import 'package:pikquick/errand_runer.dart/newtask/available_runner.dart.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';
// import 'fancy_text.dart'; // Assuming fancy_text.dart is in the same directory
// import 'fancy_container.dart'; // Assuming fancy_container.dart is in the same directory

class AddressDocumentUploadScreen extends StatefulWidget {
  const AddressDocumentUploadScreen({super.key});

  @override
  State<AddressDocumentUploadScreen> createState() =>
      _AddressDocumentUploadScreenState();
}

class _AddressDocumentUploadScreenState
    extends State<AddressDocumentUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button¿
              buildBackArrow(context),
              // IconButton(
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   icon: const Icon(Icons.arrow_back_ios),
              //   onPressed: () {
              //     // TODO: Implement navigation back
              //   },
              // ),
              const SizedBox(height: 48),

              // Title
              FancyText(
                'Upload files',
                size: 32,
                weight: FontWeight.w900,
                textColor: Colors.black,
              ),
              const SizedBox(height: 8),

              // Subtitle
              FancyText(
                'Select and upload your utility bill or bank statement',
                size: 16,
                textColor: Colors.grey.shade600,
              ),
              const SizedBox(height: 40),

              // File Upload Area
              Expanded(
                child: (_selectedImage == null)
                    ? Center(child: _buildEmptyDocumentIcon(context))
                    : BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
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
                        return Column(
                          children: [
                            UploadStatusWidget(
                              fileName: _selectedImage!.path.split("/").last,
                              uploadedSize:
                                  "${(_selectedImage!.lengthSync() / (1024)).toStringAsFixed(0)} kb",
                              totalSize:
                                  "${(_selectedImage!.lengthSync() / (1024)).toStringAsFixed(0)} kb",
                              onDelete: () {
                                _selectedImage = null;
                                setState(() {});
                              },
                            ),
                          ],
                        );
                      }),
              ),
              const SizedBox(height: 24), // Add some bottom space
            ],
          ),
        ),
      ),
    );
  }

  File? _selectedImage;
// userModelG;
  FancyContainer2 _buildEmptyDocumentIcon(BuildContext context) {
    userModelG;
    return FancyContainer2(
      width: double.infinity,
      radius: 16,
      hasBorder: true,
      borderColor: Colors.grey.shade400,
      borderwidth: 2,
      // Use a dashed border visually by overriding the border with a custom painter if needed,
      // but for simplicity and using only provided widgets, we rely on a solid line here.
      // For the dashed effect, one would typically use a CustomPainter or a dedicated package.
      child: Container(
        padding: const EdgeInsets.all(40),
        // The child container is used to center the content within the FancyContainer
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cloud Icon
            const Icon(
              Icons.cloud_upload_outlined,
              size: 60,
              color: Colors.black,
            ),
            const SizedBox(height: 16),

            // Choose a file text
            FancyText(
              'Choose a file',
              size: 18,
              weight: FontWeight.w700,
              textColor: Colors.black,
            ),
            const SizedBox(height: 4),

            // Format info text
            FancyText(
              'JPEG, PNG, and PDF formats, up to 50MB',
              size: 14,
              textColor: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Browse File Button
            _buildBrowseFileButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseFileButton(BuildContext context) {
    // The button has a light background and a rounded shape
    return FancyContainer2(
      action: () async {
        await _showImagePickerOptions();

        addressVerificationKycRequestEntity!.file = _selectedImage;

        // addressDocumentUploadScreen
        context.read<AuthBloc>().add(
              UploadkycDocumentEvent(
                  kycRequestEntity: addressVerificationKycRequestEntity!),
            );
        print('Browse File button pressed');
      },
      isAsync: false,
      backgroundColor: Colors.grey.shade100,
      radius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: FancyText(
        'Browse File',
        size: 16,
        weight: FontWeight.w600,
        textColor: Colors.black,
      ),
    );
  }

  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      await _pickImageFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      await _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF6C5CE7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, size: 30, color: Color(0xFF6C5CE7)),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  ImagePicker? _picker;
  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker?.pickImage(
        source: ImageSource.camera,
        // maxWidth: 800,
        // maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        // imageData = await image.readAsBytes();
        // if (kIsWeb) {

        // }else{

        // }
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture captured successfully!'),
            backgroundColor: Color(0xFF6C5CE7),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: ${e.toString()}')),
      );
    }
  }

  Future _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker?.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        // imageData = await image.readAsBytes();
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture selected successfully!'),
            backgroundColor: Color(0xFF6C5CE7),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }
}

class FileUploadProgressIndicator extends StatefulWidget {
  final Future<void> Function(ValueSetter<double> onProgress) uploadFile;

  const FileUploadProgressIndicator({super.key, required this.uploadFile});

  @override
  State<FileUploadProgressIndicator> createState() =>
      _FileUploadProgressIndicatorState();
}

class _FileUploadProgressIndicatorState
    extends State<FileUploadProgressIndicator> {
  // progress will be between 0.0 and 1.0 (inclusive)
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _uploadStatus;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  void _startUpload() async {
    setState(() {
      _isUploading = true;
      _uploadStatus = 'Starting upload...';
    });

    try {
      await widget.uploadFile(_updateProgress);
      // If the upload completes successfully
      setState(() {
        _uploadProgress = 1.0;
        _isUploading = false;
        _uploadStatus = 'Upload Complete! 🎉';
      });
    } catch (e) {
      // Handle upload errors
      setState(() {
        _isUploading = false;
        _uploadStatus = 'Upload Failed: $e 😞';
      });
    }
  }

  // Callback function to update the progress
  void _updateProgress(double newProgress) {
    if (mounted) {
      setState(() {
        // Ensure progress is clamped between 0.0 and 0.99
        // until the upload is actually finished (to prevent jumping to 1.0 too early)
        _uploadProgress = newProgress < 1.0 ? newProgress : 0.99;
        _uploadStatus = 'Uploading...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Progress Bar
        LinearProgressIndicator(
          value: _uploadProgress, // Use the state variable
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 8),

        // 2. Progress Text
        Text(
          '${(_uploadProgress * 100).toStringAsFixed(0)}% Complete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // 3. Status Text
        if (_uploadStatus != null)
          Text(
            _uploadStatus!,
            style: TextStyle(
              color: _uploadStatus!.contains('Complete')
                  ? Colors.green
                  : (_uploadStatus!.contains('Failed')
                      ? Colors.red
                      : Colors.black54),
            ),
          ),
      ],
    );
  }
}

// This widget displays the status of a file upload,
// including its name, size progress, and completion status.
class UploadStatusWidget extends StatelessWidget {
  final String fileName;
  final String uploadedSize;
  final String totalSize;
  final bool isCompleted;
  final Function()? onDelete;

  const UploadStatusWidget({
    super.key,
    required this.fileName,
    required this.uploadedSize,
    required this.totalSize,
    this.isCompleted = true,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // The main container for the card-like structure
    return FancyContainer2(
      width: double.infinity,
      radius: 12,
      backgroundColor: Colors.grey.shade50, // Light background for the card
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // shadows: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.03),
      //     spreadRadius: 0,
      //     blurRadius: 10,
      //     offset: const Offset(0, 5),
      //   ),
      // ],
      child: Row(
        children: [
          // 1. File Type Icon (PDF in this case)
          _buildFileIcon(),
          const SizedBox(width: 12),

          // 2. File Info (Name and Status)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // File Name
                FancyText(
                  fileName.substring(0, 20),
                  size: 13,
                  weight: FontWeight.w600,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 4),

                // File Status/Progress
                Row(
                  children: [
                    FancyText(
                      '$uploadedSize of $totalSize',
                      size: 14,
                      textColor: Colors.grey.shade600,
                    ),
                    FancyText(
                      ' • ',
                      size: 14,
                      textColor: Colors.grey.shade600,
                    ),
                    if (isCompleted)
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          FancyText(
                            'Completed',
                            size: 10,
                            textColor: Colors.black,
                            weight: FontWeight.w500,
                          ),
                        ],
                      )
                    else
                      // Simple progress text for incomplete state (if needed)
                      FancyText(
                        'Uploading...',
                        size: 14,
                        textColor: Colors.blue.shade600,
                      ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Delete Icon
          FancyContainer2(
            action: onDelete,
            isAsync: false,
            child: Icon(
              Icons.delete_outline_rounded,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileIcon() {
    // A simplified visual representation of the PDF icon
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Main document shape
        Icon(
          Icons.insert_drive_file_outlined,
          size: 40,
          color: Colors.grey.shade300,
        ),
        // PDF tag
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FancyText(
              'PDF',
              size: 10,
              weight: FontWeight.bold,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Example Usage:
/*
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Status Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            UploadStatusWidget(
              fileName: 'Bank statement',
              uploadedSize: '60 KB',
              totalSize: '120 KB',
              isCompleted: true,
              onDelete: () {
                print('Delete Bank statement');
              },
            ),
            const SizedBox(height: 16),
            UploadStatusWidget(
              fileName: 'Passport Photo',
              uploadedSize: '1 MB',
              totalSize: '4 MB',
              isCompleted: false, // Example of in-progress/pending
              onDelete: () {
                print('Delete Passport Photo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/