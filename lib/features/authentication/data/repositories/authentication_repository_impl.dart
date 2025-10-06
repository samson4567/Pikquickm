import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:pikquick/features/authentication/data/models/share_feee_model.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/runner_verification_details_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/share_feed_entites.dart';
import 'package:pikquick/features/authentication/domain/entities/task_categores_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/varify_entity.dart';
import 'package:pikquick/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.authenticationRemoteDatasource,
    required this.authenticationLocalDatasource,
  });
  final AuthenticationRemoteDatasource authenticationRemoteDatasource;
  final AuthenticationLocalDatasource authenticationLocalDatasource;

  @override
  Future<Either<Failure, String>> newUserSignUp(
      {required NewUserRequestModel newUserRequest}) async {
    try {
      final result = await authenticationRemoteDatasource.newUserSignUp(
          newUserRequest: newUserRequest);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, VerifySignUpEntity>> verifySignUp(
      {required String email, required String otp}) async {
    try {
      final result = await authenticationRemoteDatasource.verifySignUp(
          email: email, otp: otp);
      return right(VerifySignUpEntity(message: result));
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map>> login(
      {required String email, required String password}) async {
    try {
      final result = await authenticationRemoteDatasource.login(
          email: email, password: password);

      await authenticationLocalDatasource.cacheAuthToken(TokenModel(
        accessToken: result['access_token'],
      ));
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    try {
      final result =
          await authenticationRemoteDatasource.resendOtp(email: email);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final result =
          await authenticationRemoteDatasource.forgotPassword(email: email);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await authenticationRemoteDatasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetOtp(
      {required String email, required String otp}) async {
    try {
      final result = await authenticationRemoteDatasource.verifyResetOtp(
          email: email, otp: otp);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
      {required String email,
      required String token,
      required String newPassword}) async {
    try {
      final result = await authenticationRemoteDatasource.resetPassword(
          email: email, token: token, newPassword: newPassword);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(
      {required String refreshToken}) async {
    try {
      final result = await authenticationRemoteDatasource.refreshToken(
          refreshToken: refreshToken);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CustomCategoryTaskEntity>>>
      taskCategories() async {
    try {
      final result = await authenticationRemoteDatasource.taskCategories();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShareFeedbackEntity>> shareFeedback(
      {required ShareFeedbackModel shared}) async {
    try {
      final result =
          await authenticationRemoteDatasource.shareFeedBack(feedModel: shared);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadkycDocument(
      {required KycRequestEntity kycRequestEntity}) async {
    try {
      final result = await authenticationRemoteDatasource.uploadkycDocument(
          kycRequestEntity: kycRequestEntity);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerVerificationDetailsEntity>>
      getRunnerVerificationDetails() async {
    try {
      final result =
          await authenticationRemoteDatasource.getRunnerVerificationDetails();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<bool> getRemainLoggedinvalue() async {
    try {
      final result =
          await authenticationLocalDatasource.getRemainLoggedinvalue();
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> storeRemainLoggedinvalue(bool rememberMe) async {
    try {
      final result = await authenticationLocalDatasource
          .storeRemainLoggedinvalue(rememberMe);
      return result;
    } catch (e) {}
  }

  @override
  Future<Either<Failure, String>> logOut() async {
    try {
      final result = await authenticationRemoteDatasource.logOut();
      await authenticationLocalDatasource.clearCachedAuthToken();
      await authenticationLocalDatasource.clearCachedRefreshToken();
      await authenticationLocalDatasource.clearCachedUserData();

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> cacheAuthToken(TokenModel tokenModel) async {
    try {
      final result =
          await authenticationLocalDatasource.cacheAuthToken(tokenModel);
      return result;
    } catch (e) {}
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      final result =
          await authenticationLocalDatasource.cacheRefreshToken(refreshToken);
      return result;
    } catch (e) {}
  }

  @override
  Future<void> cacheUserData(UserModel userModel) async {
    try {
      final result =
          await authenticationLocalDatasource.cacheUserData(userModel);
      return result;
    } catch (e) {}
  }

  @override
  Future<void> clearCachedAuthToken() async {
    try {
      final result = await authenticationLocalDatasource.clearCachedAuthToken();
      return result;
    } catch (e) {}
  }

  @override
  Future<void> clearCachedRefreshToken() async {
    try {
      final result =
          await authenticationLocalDatasource.clearCachedRefreshToken();
      return result;
    } catch (e) {
      print("debug_print-clearCachedRefreshToken-error_is${e}");
      // return null;
    }
  }

  @override
  Future<void> clearCachedUserData() async {
    try {
      final result = await authenticationLocalDatasource.clearCachedUserData();
      return result;
    } catch (e) {
      print("debug_print-clearCachedRefreshToken-error_is${e}");
    }
  }

  @override
  Future<TokenModel?> getCachedAuthToken() async {
    try {
      final result = await authenticationLocalDatasource.getCachedAuthToken();
      return result;
    } catch (e) {
      print("debug_print-clearCachedRefreshToken-error_is${e}");
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      final result =
          await authenticationLocalDatasource.getCachedRefreshToken();
      return result;
    } catch (e) {
      print("debug_print-clearCachedRefreshToken-error_is${e}");
    }
  }

  @override
  Future<UserModel?> getCachedUserData() async {
    try {
      final result = await authenticationLocalDatasource.getCachedUserData();
      return result;
    } catch (e) {
      print("debug_print-clearCachedRefreshToken-error_is${e}");
    }
  }
}
