import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class RunnerVerificationDetailsEntity extends Equatable {
  int? totalRequired;
  int? totalSubmitted;
  int? totalVerified;
  int? totalRejected;

  //  String password;
  bool? isFullyVerified;

  //  String password;

  RunnerVerificationDetailsEntity({
    this.totalRejected,
    this.totalRequired,
    this.totalSubmitted,
    this.totalVerified,
    this.isFullyVerified,
  });

  @override
  List<Object?> get props => [
        totalRejected,
        totalRequired,
        totalSubmitted,
        totalVerified,
        isFullyVerified,
      ];
}

//  {
//         "total_required": 3,
//         "total_submitted": 0,
//         "total_verified": 0,
//         "total_rejected": 0,
//         "is_fully_verified": false
//     }