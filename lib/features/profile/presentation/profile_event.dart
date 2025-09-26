import 'package:equatable/equatable.dart';
import 'package:pikquick/features/profile/data/model/create_model.dart';
import 'package:pikquick/features/profile/data/model/get_runner_profile_model.dart';
import 'package:pikquick/features/profile/data/model/invite_sent_model.dart';
import 'package:pikquick/features/profile/data/model/profile_model.dart';
import 'package:pikquick/features/profile/data/model/profile_upload_model.dart';
import 'package:pikquick/features/profile/data/model/runnerdetails_model.dart'
    show RunnersAllDetailsModel;
import 'package:pikquick/features/profile/domain/entities/profile_uplaod_entites.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileSetupEvent extends ProfileEvent {
  final ProfileEditModel profileEditModel;

  const ProfileSetupEvent({required this.profileEditModel});

  @override
  List<Object> get props => [profileEditModel];
}

class GetrunnerProfileEvent extends ProfileEvent {
  // final GetRunnerProfileModel getRunnerprofileEvent;
  final String userID;
  const GetrunnerProfileEvent({
    required this.userID,
  });
  @override
  List<Object> get props => [userID];
}

class GetrunnerPerformanceEvent extends ProfileEvent {
  final String userID;
  const GetrunnerPerformanceEvent({
    required this.userID,
  });
  @override
  List<Object> get props => [userID];
}

//CreateunnerProfile
class CreateunnerProfileEvent extends ProfileEvent {
  final ProfileModel profileModel;

  const CreateunnerProfileEvent({required this.profileModel});

  @override
  List<Object> get props => [profileModel];
}

class RunnerDetailsEvent extends ProfileEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final String transportMode;
  final int page;
  final int limit;
  final RunnersAllDetailsModel runnerDetails;

  const RunnerDetailsEvent({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.transportMode,
    required this.page,
    required this.limit,
    required this.runnerDetails, // Added
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
        radius,
        transportMode,
        page,
        limit,
        runnerDetails,
      ];
}

// viewrunnerProfile
class RunnerDetailsInviteSentEvent extends ProfileEvent {
  final String userId;
  // final GetRunnerProfileModel runnerDetailsSent;
  const RunnerDetailsInviteSentEvent({
    required this.userId,
    // this.runnerDetailsSent
  });

  @override
  List<Object> get props => [
        userId,

        // runnerDetailsSent
      ];
}

// SearchRunnerErrorState
class SearchRunnerEvent extends ProfileEvent {
  final String query;
  final String page;
  final String limit;

  const SearchRunnerEvent({
    required this.query,
    required this.page,
    required this.limit,
  });
}

//  IniteSent

class InviteSentEvent extends ProfileEvent {
  final String taskId;
  final InviteSentToRunnerModel sendInvite;
  const InviteSentEvent({required this.taskId, required this.sendInvite});
}

// provileuplod
class ProfileUploadFileEvent extends ProfileEvent {
  final ProfileUploadModel profileUpload;

  const ProfileUploadFileEvent({required this.profileUpload});
}
