import 'package:pikquick/features/profile/domain/entities/profile_uplaod_entites.dart';

class ProfileUploadModel extends ProfileUploadEntity {
  final String filePath; // actual local file path

  const ProfileUploadModel({
    required this.filePath,
    required super.message,
  });

  factory ProfileUploadModel.fromJson(Map<String, dynamic> json) {
    return ProfileUploadModel(
      filePath: '', // don’t overwrite real path from API response
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "file": filePath,
      "message": message,
    };
  }
}
