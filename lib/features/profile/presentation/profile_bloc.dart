import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/features/profile/domain/repositories/profile_repositires.dart';
import 'package:pikquick/features/profile/presentation/profile_event.dart';
import 'package:pikquick/features/profile/presentation/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.profileRepository,
  }) : super(const ProfileInitial()) {
    on<ProfileSetupEvent>(_onProfileSetup);
    on<GetrunnerProfileEvent>(_onGetprofile);
    on<GetrunnerPerformanceEvent>(_onGetrunnerPerformance);
    on<CreateunnerProfileEvent>(_onCreateProfile);
    on<RunnerDetailsEvent>(_onRunnerDetails);
    on<RunnerDetailsInviteSentEvent>(_onViewRunnerDetailsSent);
    on<SearchRunnerEvent>(_onSearchRunner);
    on<InviteSentEvent>(_onInviteSent);
  }

  Future<void> _onProfileSetup(
      ProfileSetupEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await profileRepository.profileEdit(
        profileEditModel: event.profileEditModel);
    result.fold(
      (error) => emit(ProfileErrorState(errorMessage: error.message)),
      (data) => emit(ProfileSuccessState(profileSetup: [])),
    );
  }

  Future<void> _onGetprofile(
      GetrunnerProfileEvent event, Emitter<ProfileState> emit) async {
    emit(GetrunnerProfileLoadingState());
    final result =
        await profileRepository.getRunnerProfile(userID: event.userID);
    result.fold(
        (error) =>
            emit(GetrunnerProfileErrorState(errorMessage: error.message)),
        (data) => emit(GetrunnerProfileSuccessState(getProfile: data)));
  }

  Future<void> _onGetrunnerPerformance(
      GetrunnerPerformanceEvent event, Emitter<ProfileState> emit) async {
    emit(GetrunnerPerformanceLoadingState());
    final result =
        await profileRepository.getRunnerPerformance(userID: event.userID);
    result.fold(
        (error) =>
            emit(GetrunnerPerformanceeErrorState(errorMessage: error.message)),
        (data) => emit(
            GetrunnerPerformanceeSuccessState(getProfilePerformance: data)));
  }

  Future<void> _onCreateProfile(
      CreateunnerProfileEvent event, Emitter<ProfileState> emit) async {
    emit(CreateunnerProfileLoadingState());
    final result = await profileRepository.createProfileSetp(
        profileModel: event.profileModel);
    result.fold(
      (error) =>
          emit(CreateunnerProfileErroeState(errorMessage: error.message)),
      (data) => emit(CreateunnerProfileSuccessState(createProfile: [])),
    );
  }

  Future<void> _onRunnerDetails(
    RunnerDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(RunnerDetailsLoadingState());

    final result = await profileRepository.getRunnerDetails(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      transportMode: event.transportMode,
      page: event.page,
      limit: event.limit,
      runnerDetails: event.runnerDetails, // Fixed
    );

    result.fold(
      (error) => emit(RunnerDetailsErrorState(errorMessage: error.message)),
      (data) => emit(RunnerDetailsSuccessState(runners: data)),
    );
  }

  Future<void> _onViewRunnerDetailsSent(
      RunnerDetailsInviteSentEvent event, Emitter<ProfileState> emit) async {
    emit(RunnerDetailsInviteSentLoadingState());

    final result = await profileRepository.viewRunnerDetailsSent(
      userId: event.userId,
      // runnerDetailsSent:
      // event.runnerDetailsSent
    );
    result.fold(
      (error) =>
          emit(RunnerDetailsInviteSentErrorState(errorMessage: error.message)),
      (data) => emit(RunnerDetailsInviteSentSuccessState(runners: data)),
    );
  }

  Future<void> _onSearchRunner(
      SearchRunnerEvent event, Emitter<ProfileState> emit) async {
    emit(SearchRunnerLoadingState());

    final result = await profileRepository.searchRunnerbydetais(
      query: event.query,
      page: event.page,
      liimit: event.limit,
    );

    result.fold(
      (error) => emit(SearchRunnerErrorState(errorMessage: error.message)),
      (data) => emit(SearchRunnerSuccessState(runners: data)),
    );
  }

  Future<void> _onInviteSent(
      InviteSentEvent event, Emitter<ProfileState> emit) async {
    emit(InviteSentLoadingState());

    final result = await profileRepository.sendRunnerInvite(
        taskId: event.taskId, sendInvite: event.sendInvite);

    result.fold(
      (error) => emit(InviteSentErrorState(errorMessage: error.message)),
      (data) => emit(InviteSentSuccessState(runners: data)),
    );
  }
}
