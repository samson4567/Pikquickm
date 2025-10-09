import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/core/mapper/failure_mapper.dart';
import 'package:pikquick/features/profile/data/datasource/profile_local_datasources.dart';
import 'package:pikquick/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:pikquick/features/profile/data/model/auto_sub_daily.dart';
import 'package:pikquick/features/profile/data/model/create_model.dart';
import 'package:pikquick/features/profile/data/model/get_review_model.dart';
import 'package:pikquick/features/profile/data/model/invite_sent_model.dart';
import 'package:pikquick/features/profile/data/model/profile_model.dart';
import 'package:pikquick/features/profile/data/model/runnerdetails_model.dart';
import 'package:pikquick/features/profile/data/model/unto_auto_daily.dart';
import 'package:pikquick/features/profile/domain/entities/auto_deduct_entities.dart';
import 'package:pikquick/features/profile/domain/entities/create_profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/get_reviews%20_entites.dart';
import 'package:pikquick/features/profile/domain/entities/getrunner_entity.dart';
import 'package:pikquick/features/profile/domain/entities/invite_sent_entity.dart';
import 'package:pikquick/features/profile/domain/entities/profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart';
import 'package:pikquick/features/profile/domain/entities/runner_performance_entiy.dart';
import 'package:pikquick/features/profile/domain/entities/search_entity.dart';
import 'package:pikquick/features/profile/domain/entities/unto_entities.dart';
import 'package:pikquick/features/profile/domain/repositories/profile_repositires.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;
  final ProfileLocalDatasources profileLocalDatasources;

  ProfileRepositoryImpl({
    required this.profileRemoteDatasource,
    required this.profileLocalDatasources,
  });

  @override
  Future<Either<Failure, List<ProfileEntity>>> profileEdit(
      {required ProfileEditModel profileEditModel}) async {
    try {
      final result = await profileRemoteDatasource.profileEdit(
          profileEditModel: profileEditModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetRunnerProfileEntity>> getRunnerProfile(
      {required String userID}) async {
    try {
      final result =
          await profileRemoteDatasource.getRunnerProfile(userID: userID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RunnerPerformanceEntity>> getRunnerPerformance(
      {required String userID}) async {
    try {
      final result =
          await profileRemoteDatasource.getRunnerPerformance(userID: userID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CreateProfileEntity>>> createProfileSetp(
      {required ProfileModel profileModel}) async {
    try {
      final result = await profileRemoteDatasource.createProfile(
          profileModel: profileModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<RunnersAllDetailsEntity>>> getRunnerDetails({
    required double latitude,
    required double longitude,
    required double radius,
    required String transportMode,
    required int page,
    required int limit,
    required RunnersAllDetailsModel runnerDetails,
  }) async {
    try {
      final result = await profileRemoteDatasource.runnerDetails(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        transportMode: transportMode,
        page: page,
        limit: limit,
        runnerDetails: runnerDetails,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

// Abstract

// Implementation
  @override
  Future<Either<Failure, GetRunnerProfileEntity>> viewRunnerDetailsSent({
    required String userId,
    // required GetRunnerProfileModel runnerDetailsSent,
  }) async {
    try {
      final result = await profileRemoteDatasource.viewRunnerDetailsSent(
        userId: userId,
        // runnerDetailsSent: runnerDetailsSent,
      );
      return right(result); // result is a GetRunnerProfileModel
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SearchRunnerListEntity>> searchRunnerbydetais({
    required String query,
    required String page,
    required String liimit,
  }) async {
    try {
      final result = await profileRemoteDatasource.searchRunnerbydetaist(
        query: query,
        page: page,
        limit: liimit,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, InviteSentToRunnerEntity>> sendRunnerInvite(
      {required String taskId,
      required InviteSentToRunnerModel sendInvite}) async {
    try {
      final result = await profileRemoteDatasource.sendRunnerInvite(
          taskId: taskId, sendInvite: sendInvite);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MyDocumentEntity>>> getVerifiedDocuments() async {
    try {
      final result = await profileRemoteDatasource.getVerifiedDocuments();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SubscribeAutoDeductionEntity>> subscribeAutoDeduction({
    required SubscribeAutoDeductionModel model,
  }) async {
    try {
      final result =
          await profileRemoteDatasource.subscribeAutoDeduction(model: model);
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UnsubscribeAutoDeductionEntity>>
      unsubscribeAutoDeduction({
    required UnsubscribeAutoDeductionModel model,
  }) async {
    try {
      final result =
          await profileRemoteDatasource.unsubscribeAutoDeduction(model: model);
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(
      {required File file}) async {
    try {
      final result =
          await profileRemoteDatasource.uploadProfilePicture(file: file);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetReviewEntity>> getReview(
      {required GetReviewModel taskId}) async {
    try {
      final result = await profileRemoteDatasource.getReview(taskId: taskId);
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
