import 'package:equatable/equatable.dart';
import 'package:pikquick/features/authentication/domain/entities/Refresh_entiy.dart';
import 'package:pikquick/features/authentication/domain/entities/runner_verification_details_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/share_feed_entites.dart';
import 'package:pikquick/features/authentication/domain/entities/task_categores_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

// Sign Up States
final class NewUserSignUpLoadingState extends AuthState {
  const NewUserSignUpLoadingState();
}

final class NewUserSignUpSuccessState extends AuthState {
  final String message;

  const NewUserSignUpSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class NewUserSignUpErrorState extends AuthState {
  final String errorMessage;

  const NewUserSignUpErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Verify States
final class VerifyNewSignUpEmailLoadingState extends AuthState {
  const VerifyNewSignUpEmailLoadingState();
}

final class VerifyNewSignUpEmailSuccessState extends AuthState {
  final String message;

  const VerifyNewSignUpEmailSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class VerifyNewSignUpEmailErrorState extends AuthState {
  final String errorMessage;

  const VerifyNewSignUpEmailErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Login States
final class LoginLoadingState extends AuthState {
  const LoginLoadingState();
}

final class LoginSuccessState extends AuthState {
  final String accessToken;

  final UserEntity user;
  final String message;

  const LoginSuccessState({
    required this.accessToken,
    required this.user,
    required this.message,
  });

  @override
  List<Object> get props => [accessToken, user, message];
}

final class LoginErrorState extends AuthState {
  final String errorMessage;

  const LoginErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Resend OTP States
final class ResendOtpLoadingState extends AuthState {
  const ResendOtpLoadingState();
}

final class ResendOtpSuccessState extends AuthState {
  final String message;

  const ResendOtpSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ResendOtpErrorState extends AuthState {
  final String errorMessage;

  const ResendOtpErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ForgotPasswordLoadingState extends AuthState {}

final class ForgotPasswordSuccessState extends AuthState {
  const ForgotPasswordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ForgotPasswordErrorState extends AuthState {
  const ForgotPasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}
// change password

final class ChangePasswordLoadingState extends AuthState {}

final class ChangePasswordSuccessState extends AuthState {
  const ChangePasswordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ChangePasswordErrorState extends AuthState {
  const ChangePasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

///VerifyResetOTP

final class VerifyResetOTPLoadingState extends AuthState {}

final class VerifyResetOTPSuccessState extends AuthState {
  const VerifyResetOTPSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class VerifyResetOTPErrorState extends AuthState {
  const VerifyResetOTPErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// UploadkycDocument
// ResetPassword

class ResetPassowordLoading extends AuthState {}

final class ResetPassowordSuccessState extends AuthState {
  const ResetPassowordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ResetPassowordErrorState extends AuthState {
  const ResetPassowordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// auth_state.dart
final class RefreshTokenInitialState extends AuthState {}

final class RefreshTokenLoadingState extends AuthState {}

final class RefreshTokenSuccessState extends AuthState {
  final RefreshTokenEntity token;
  const RefreshTokenSuccessState({required this.token});

  @override
  List<Object> get props => [token];
}

final class RefreshTokenErrorState extends AuthState {
  final String message;
  const RefreshTokenErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

///TaskCategory

final class TaskCategoryLoadingState extends AuthState {}

final class TaskCategorySuccessState extends AuthState {
  const TaskCategorySuccessState({required this.categories});
  final List<CustomCategoryTaskEntity> categories;
  @override
  List<Object> get props => [categories];
}

final class TaskCategoryErrorState extends AuthState {
  const TaskCategoryErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// share feed back
final class ShareFeedBackInitial extends AuthState {
  const ShareFeedBackInitial();
}

final class ShareFeedbackLoading extends AuthState {}

final class ShareFeedbackSucessState extends AuthState {
  final ShareFeedbackEntity feedBack;
  const ShareFeedbackSucessState({required this.feedBack});
  @override
  List<Object> get props => [feedBack];
}

// ignore: must_be_immutable
final class ShareFeedbackErrorState extends AuthState {
  String errorMessage;
  ShareFeedbackErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// UploadkycDocument

final class UploadkycDocumentLoadingState extends AuthState {}

final class UploadkycDocumentSuccessState extends AuthState {
  const UploadkycDocumentSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class UploadkycDocumentErrorState extends AuthState {
  const UploadkycDocumentErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// GetRunnerVerificationDetails

final class GetRunnerVerificationDetailsLoadingState extends AuthState {}

final class GetRunnerVerificationDetailsSuccessState extends AuthState {
  const GetRunnerVerificationDetailsSuccessState(
      {required this.runnerVerificationDetailsEntity});
  final RunnerVerificationDetailsEntity runnerVerificationDetailsEntity;
  @override
  List<Object> get props => [runnerVerificationDetailsEntity];
}

final class GetRunnerVerificationDetailsErrorState extends AuthState {
  const GetRunnerVerificationDetailsErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}



// GetRunnerVerificationDetails





///LogOut

final class LogOutLoadingState extends AuthState {}

final class LogOutSuccessState extends AuthState {
  const LogOutSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class LogOutErrorState extends AuthState {
  const LogOutErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}
