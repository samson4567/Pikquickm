import 'package:equatable/equatable.dart';
import 'package:pikquick/features/profile/domain/entities/create_profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/getrunner_entity.dart';
import 'package:pikquick/features/profile/domain/entities/invite_sent_entity.dart';
import 'package:pikquick/features/profile/domain/entities/profile_entity.dart';
import 'package:pikquick/features/profile/domain/entities/runner_details_model.dart';
import 'package:pikquick/features/profile/domain/entities/runner_performance_entiy.dart';
import 'package:pikquick/features/profile/domain/entities/search_entity.dart'
    show SearchRunnerListEntity;
import 'package:pikquick/features/task/data/model/my_document_model.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {
  const ProfileSuccessState({required this.profileSetup});
  final List<ProfileEntity> profileSetup;
  @override
  List<Object> get props => [profileSetup];
}

final class ProfileErrorState extends ProfileState {
  const ProfileErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// getrunner profile

final class GetrunnerProfileinitial extends ProfileState {
  const GetrunnerProfileinitial();
}

final class GetrunnerProfileLoadingState extends ProfileState {}

final class GetrunnerProfileSuccessState extends ProfileState {
  const GetrunnerProfileSuccessState({
    required this.getProfile,
    required this.runnerID,
  });
  final GetRunnerProfileEntity getProfile;
  final String runnerID;

  @override
  List<Object> get props => [getProfile];
}

final class GetrunnerProfileErrorState extends ProfileState {
  const GetrunnerProfileErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// runner Performance & statics
final class GetrunnerPerformanceinitial extends ProfileState {
  const GetrunnerPerformanceinitial();
}

final class GetrunnerPerformanceLoadingState extends ProfileState {}

final class GetrunnerPerformanceeSuccessState extends ProfileState {
  const GetrunnerPerformanceeSuccessState(
      {required this.getProfilePerformance});
  final RunnerPerformanceEntity getProfilePerformance;
  @override
  List<Object> get props => [getProfilePerformance];
}

final class GetrunnerPerformanceeErrorState extends ProfileState {
  const GetrunnerPerformanceeErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// create profile

final class CreateunnerProfileinitial extends ProfileState {
  const CreateunnerProfileinitial();
}

final class CreateunnerProfileLoadingState extends ProfileState {}

final class CreateunnerProfileSuccessState extends ProfileState {
  const CreateunnerProfileSuccessState({required this.createProfile});
  final List<CreateProfileEntity> createProfile;
  @override
  List<Object> get props => [createProfile];
}

final class CreateunnerProfileErroeState extends ProfileState {
  const CreateunnerProfileErroeState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

//RunnerDetails

final class RunnerDetailsInitial extends ProfileState {
  const RunnerDetailsInitial();
}

final class RunnerDetailsLoadingState extends ProfileState {}

final class RunnerDetailsSuccessState extends ProfileState {
  final List<RunnersAllDetailsEntity> runners;

  const RunnerDetailsSuccessState({required this.runners});

  @override
  List<Object> get props => [runners];
}

final class RunnerDetailsErrorState extends ProfileState {
  final String errorMessage;

  const RunnerDetailsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//viewrunnerProfile

final class RunnerDetailsInviteSentInitial extends ProfileState {
  const RunnerDetailsInviteSentInitial();
}

final class RunnerDetailsInviteSentLoadingState extends ProfileState {}

final class RunnerDetailsInviteSentSuccessState extends ProfileState {
  final GetRunnerProfileEntity runners;

  const RunnerDetailsInviteSentSuccessState({required this.runners});

  @override
  List<Object> get props => [runners];
}

final class RunnerDetailsInviteSentErrorState extends ProfileState {
  final String errorMessage;

  const RunnerDetailsInviteSentErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//search runner

final class SearchRunnerInitial extends ProfileState {
  const SearchRunnerInitial();
}

final class SearchRunnerLoadingState extends ProfileState {}

final class SearchRunnerSuccessState extends ProfileState {
  final SearchRunnerListEntity runners;

  const SearchRunnerSuccessState({required this.runners});

  @override
  List<Object> get props => [runners];
}

final class SearchRunnerErrorState extends ProfileState {
  final String errorMessage;

  const SearchRunnerErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// inviteSent

final class InviteSentInitial extends ProfileState {
  const InviteSentInitial();
}

final class InviteSentLoadingState extends ProfileState {}

final class InviteSentSuccessState extends ProfileState {
  final InviteSentToRunnerEntity runners;

  const InviteSentSuccessState({required this.runners});

  @override
  List<Object> get props => [runners];
}

final class InviteSentErrorState extends ProfileState {
  final String errorMessage;

  const InviteSentErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetVerifiedDocuments

final class GetVerifiedDocumentsInitial extends ProfileState {
  const GetVerifiedDocumentsInitial();
}

final class GetVerifiedDocumentsLoadingState extends ProfileState {}

final class GetVerifiedDocumentsSuccessState extends ProfileState {
  final List<MyDocumentEntity> listOfMyDocumentModel;

  const GetVerifiedDocumentsSuccessState({required this.listOfMyDocumentModel});

  @override
  List<Object> get props => [listOfMyDocumentModel];
}

final class GetVerifiedDocumentsErrorState extends ProfileState {
  final String errorMessage;

  const GetVerifiedDocumentsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}


// GetVerifiedDocuments