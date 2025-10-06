import 'package:equatable/equatable.dart';
import 'package:pikquick/features/authentication/data/models/kyc_request_model.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:pikquick/features/authentication/data/models/refrresh_toke_model.dart';
import 'package:pikquick/features/authentication/data/models/share_feee_model.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class NewUserSignUpEvent extends AuthEvent {
  final NewUserRequestModel newUserRequest;

  const NewUserSignUpEvent({required this.newUserRequest});
}

final class VerifyNewSignUpEmailEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyNewSignUpEmailEvent({
    required this.email,
    required this.otp,
  });
}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

final class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent(
      {required this.currentPassword, required this.newPassword});

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class VerifyResetOTPEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyResetOTPEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}

class RessetPasswordEvent extends AuthEvent {
  final String email;
  final String token;
  final String newPassword;

  const RessetPasswordEvent({
    required this.token,
    required this.newPassword,
    required this.email,
  });
}

// auth_event.dart
class RefreshTokenEvent extends AuthEvent {
  final RefreshTokenModel model;
  const RefreshTokenEvent({required this.model});

  @override
  List<Object> get props => [model];
}

class TaskCategoryEvent extends AuthEvent {
  final CustomCategoryTaskModel categoryModel;

  const TaskCategoryEvent({required this.categoryModel});

  @override
  List<Object> get props => [];
}

//sharefeedBack

class ShareFeedbackEvent extends AuthEvent {
  final ShareFeedbackModel feedModel;
  const ShareFeedbackEvent({required this.feedModel});
  @override
  List<Object> get props => [feedModel];
}

class UploadkycDocumentEvent extends AuthEvent {
  final KycRequestEntity kycRequestEntity;
  const UploadkycDocumentEvent({required this.kycRequestEntity});
  @override
  List<Object> get props => [kycRequestEntity];
}

class GetRunnerVerificationDetailsEvent extends AuthEvent {
  const GetRunnerVerificationDetailsEvent();
  @override
  List<Object> get props => [];
}

class GetRemainLoggedinvalueEvent extends AuthEvent {
  const GetRemainLoggedinvalueEvent();
  @override
  List<Object> get props => [];
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
  @override
  List<Object> get props => [];
}



// GetRemainLoggedinvalue