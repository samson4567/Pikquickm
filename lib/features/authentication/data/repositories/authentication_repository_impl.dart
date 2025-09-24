import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:pikquick/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:pikquick/features/authentication/data/models/share_feee_model.dart';
import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';
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
}
