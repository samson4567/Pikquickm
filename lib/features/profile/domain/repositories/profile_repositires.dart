import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pikquick/core/error/failure.dart';
import 'package:pikquick/features/profile/data/model/auto_sub_daily.dart';
import 'package:pikquick/features/profile/data/model/create_model.dart';
import 'package:pikquick/features/profile/data/model/get_review_model.dart';
import 'package:pikquick/features/profile/data/model/get_runner_profile_model.dart';
import 'package:pikquick/features/profile/data/model/invite_sent_model.dart';
import 'package:pikquick/features/profile/data/model/profile_model.dart';
import 'package:pikquick/features/profile/data/model/runnerdetails_model.dart';
import 'package:pikquick/features/profile/data/model/unto_auto_daily.dart';
import 'package:pikquick/features/profile/domain/entities/auto_deduct_entities.dart';
import 'package:pikquick/features/profile/domain/entities/create_profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/get_reviews%20_entites.dart';
import 'package:pikquick/features/profile/domain/entities/getrunner_entity.dart';
import 'package:pikquick/features/profile/domain/entities/invite_sent_entity.dart'
    show InviteSentToRunnerEntity;
import 'package:pikquick/features/profile/domain/entities/profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart';
import 'package:pikquick/features/profile/domain/entities/runner_performance_entiy.dart';
import 'package:pikquick/features/profile/domain/entities/search_entity.dart';
import 'package:pikquick/features/profile/domain/entities/unto_entities.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<ProfileEntity>>> profileEdit(
      {required ProfileEditModel profileEditModel});

  Future<Either<Failure, GetRunnerProfileEntity>> getRunnerProfile(
      {required String userID});
  Future<Either<Failure, RunnerPerformanceEntity>> getRunnerPerformance(
      {required String userID});
  Future<Either<Failure, List<CreateProfileEntity>>> createProfileSetp(
      {required ProfileModel profileModel});

  Future<Either<Failure, List<RunnersAllDetailsEntity>>> getRunnerDetails({
    required double latitude,
    required double longitude,
    required double radius,
    required String transportMode,
    required int page,
    required int limit,
    required RunnersAllDetailsModel runnerDetails,
  });

  Future<Either<Failure, GetRunnerProfileEntity>> viewRunnerDetailsSent({
    required String userId,
    // required GetRunnerProfileModel runnerDetailsSent,
  });

  Future<Either<Failure, SearchRunnerListEntity>> searchRunnerbydetais({
    required String query,
    required String page,
    required String liimit,
  });

  Future<Either<Failure, InviteSentToRunnerEntity>> sendRunnerInvite(
      {required String taskId, required InviteSentToRunnerModel sendInvite});

  Future<Either<Failure, List<MyDocumentEntity>>> getVerifiedDocuments();

  Future<Either<Failure, SubscribeAutoDeductionEntity>> subscribeAutoDeduction({
    required SubscribeAutoDeductionModel model,
  });
  Future<Either<Failure, UnsubscribeAutoDeductionEntity>>
      unsubscribeAutoDeduction({
    required UnsubscribeAutoDeductionModel model,
  });
  Future<Either<Failure, String>> uploadProfilePicture({
    required File file,
  });

  Future<Either<Failure, GetReviewEntity>> getReview({
    required GetReviewModel taskId,
  });
}
