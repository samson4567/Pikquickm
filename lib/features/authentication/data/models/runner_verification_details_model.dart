import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pikquick/features/authentication/domain/entities/runner_verification_details_entity.dart';

// RunnerVerificationDetailsEntity
class RunnerVerificationDetailsModel extends RunnerVerificationDetailsEntity {
  //  String password;

  RunnerVerificationDetailsModel({
    required super.totalRejected,
    required super.totalRequired,
    required super.totalSubmitted,
    required super.totalVerified,
    required super.isFullyVerified,
  });

  factory RunnerVerificationDetailsModel.fromJson(Map<String, dynamic> json) {
    return RunnerVerificationDetailsModel(
      totalRejected: json["total_rejected"],
      totalRequired: json["total_required"],
      totalSubmitted: json["total_submitted"],
      totalVerified: json["total_verified"],
      isFullyVerified: json["is_fully_verified"],
    );
  }
  RunnerVerificationDetailsModel? fromEntity(
      RunnerVerificationDetailsEntity runnerVerificationDetailsEntity) {
    return RunnerVerificationDetailsModel(
      totalRejected: runnerVerificationDetailsEntity.totalRejected,
      totalRequired: runnerVerificationDetailsEntity.totalRequired,
      totalSubmitted: runnerVerificationDetailsEntity.totalSubmitted,
      totalVerified: runnerVerificationDetailsEntity.totalVerified,
      isFullyVerified: runnerVerificationDetailsEntity.isFullyVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_rejected": totalRejected,
      "total_required": totalRequired,
      "total_submitted": totalSubmitted,
      "total_verified": totalVerified,
      "is_fully_verified": isFullyVerified,
    };
  }
}

//  {
//         "total_required": 3,
//         "total_submitted": 0,
//         "total_verified": 0,
//         "total_rejected": 0,
//         "is_fully_verified": false
//     }