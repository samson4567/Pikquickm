import 'package:equatable/equatable.dart';

class ShareFeedbackEntity extends Equatable {
  final String fullName;
  final String email;
  final String message;

  const ShareFeedbackEntity({
    required this.fullName,
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [fullName, email, message];
}
