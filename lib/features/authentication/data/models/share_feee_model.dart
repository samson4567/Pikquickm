import 'package:pikquick/features/authentication/domain/entities/share_feed_entites.dart';

class ShareFeedbackModel extends ShareFeedbackEntity {
  const ShareFeedbackModel({
    required super.fullName,
    required super.email,
    required super.message,
  });

  factory ShareFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ShareFeedbackModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "email": email,
      "message": message,
    };
  }
}
