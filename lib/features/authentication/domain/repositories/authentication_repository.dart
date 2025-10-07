import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:dartz/dartz.dart';
import 'package:pikquick/features/authentication/data/models/share_feee_model.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/runner_verification_details_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/share_feed_entites.dart';
import 'package:pikquick/features/authentication/domain/entities/task_categores_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/varify_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, String>> newUserSignUp({
    required NewUserRequestModel newUserRequest,
  });
  Future<Either<Failure, VerifySignUpEntity>> verifySignUp(
      {required String email, required String otp});
  Future<Either<Failure, Map>> login(
      {required String email, required String password});
  Future<Either<Failure, String>> resendOtp({required String email});
  Future<Either<Failure, String>> forgotPassword({required String email});
  Future<Either<Failure, String>> changePassword(
      {required String currentPassword, required String newPassword});
  Future<Either<Failure, String>> verifyResetOtp(
      {required String email, required String otp});
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
  Future<Either<Failure, String>> refreshToken({required String refreshToken});
  Future<Either<Failure, List<CustomCategoryTaskEntity>>> taskCategories();
  Future<Either<Failure, ShareFeedbackEntity>> shareFeedback(
      {required ShareFeedbackModel shared});
  Future<Either<Failure, String>> uploadkycDocument(
      {required KycRequestEntity kycRequestEntity});
  Future<Either<Failure, RunnerVerificationDetailsEntity>>
      getRunnerVerificationDetails();
  Future<bool> getRemainLoggedinvalue();
  Future<void> storeRemainLoggedinvalue(bool rememberMe);
  Future<Either<Failure, String>> logOut();
  Future<void> cacheAuthToken(TokenModel tokenModel);
  Future<TokenModel?> getCachedAuthToken();
  Future<void> clearCachedAuthToken();

  Future<void> cacheUserData(UserModel userModel);
  Future<UserModel?> getCachedUserData();
  Future<void> clearCachedUserData();
  // ✅ New methods for refresh token
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getCachedRefreshToken();
  Future<void> clearCachedRefreshToken();
}

//VerifyResetOTPEvent
