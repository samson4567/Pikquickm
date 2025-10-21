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
    on<GetVerifiedDocumentsEvent>(_onGetVerifiedDocuments);
    on<ToggleSubscribeAutoDeductionEvent>(_onToggleSubscribeAutoDeduction);
    on<UnsubscribeAutoDeductionEvent>(_onUnsubscribeAutoDeduction);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<FetchGetReviewEvent>(_onGetReviewEvent);
    on<SubmitClientProfileEvent>(_onSubmitProfile);
    on<SubmitClientProfilenameEvent>(_onSubmitProfilename);
    on<SubmitClientProfileemailEvent>(_onSubmitProfileemail);
  }

// UploadProfilePicture
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
    print("dnasldalskdandlnas-_onGetprofile_started");
    emit(GetrunnerProfileLoadingState());

    print("dnasldalskdandlnas-result started");
    final result =
        await profileRepository.getRunnerProfile(userID: event.userID);
    print("dnasldalskdandlnas-result_is>>${result}");
    result.fold(
        (error) =>
            emit(GetrunnerProfileErrorState(errorMessage: error.message)),
        (data) => emit(GetrunnerProfileSuccessState(
            getProfile: data, runnerID: event.userID)));
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

  Future<void> _onGetVerifiedDocuments(
      GetVerifiedDocumentsEvent event, Emitter<ProfileState> emit) async {
    emit(GetVerifiedDocumentsLoadingState());

    final result = await profileRepository.getVerifiedDocuments();

    result.fold(
      (error) =>
          emit(GetVerifiedDocumentsErrorState(errorMessage: error.message)),
      (data) =>
          emit(GetVerifiedDocumentsSuccessState(listOfMyDocumentModel: data)),
    );
  }

  Future<void> _onToggleSubscribeAutoDeduction(
    ToggleSubscribeAutoDeductionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(SubscribeAutoDeductionLoading());

    final result =
        await profileRepository.subscribeAutoDeduction(model: event.model);

    result.fold(
      (failure) => emit(SubscribeAutoDeductionError(failure.message)),
      (subscription) => emit(SubscribeAutoDeductionSuccess(subscription)),
    );
  }

  Future<void> _onUnsubscribeAutoDeduction(
    UnsubscribeAutoDeductionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UnsubscribeAutoDeductionLoading());
    final result =
        await profileRepository.unsubscribeAutoDeduction(model: event.model);

    result.fold(
      (failure) => emit(UnsubscribeAutoDeductionError(failure.message)),
      (entity) => emit(UnsubscribeAutoDeductionSuccess(entity)),
    );
  }

  Future<void> _onSubmitProfile(
    SubmitClientProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ClientEditProfileLoading());

    final result =
        await profileRepository.EditProfileClient(clientId: event.clientId);

    result.fold(
      (failure) =>
          emit(ClientEditProfileErrorState(errorMessage: failure.message)),
      (message) => emit(ClientEditProfileSuccess(message: message)),
    );
  }

  Future<void> _onSubmitProfilename(
    SubmitClientProfilenameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ClientEditProfileLoadingname());

    final result =
        await profileRepository.EditProfileClientname(clientId: event.clientId);

    result.fold(
      (failure) =>
          emit(ClientEditProfileErrorStatename(errorMessage: failure.message)),
      (message) => emit(ClientEditProfileSuccessname(message: message)),
    );
  }

  Future<void> _onSubmitProfileemail(
    SubmitClientProfileemailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ClientEditProfileLoadingemail());

    final result = await profileRepository.EditProfileClientemail(
        clientId: event.clientId);

    result.fold(
      (failure) =>
          emit(ClientEditProfileErrorStateemail(errorMessage: failure.message)),
      (message) => emit(ClientEditProfileSuccessemail(message: message)),
    );
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UploadProfilePictureLoadingState());
    final result =
        await profileRepository.uploadProfilePicture(file: event.file);

    result.fold(
      (failure) =>
          emit(UploadProfilePictureErrorState(errorMessage: failure.message)),
      (entity) => emit(UploadProfilePictureSuccessState(message: entity)),
    );
  }

  Future<void> _onGetReviewEvent(
    FetchGetReviewEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(GetReviewLoadingState());

    final result = await profileRepository.getReview(taskId: event.taskId);

    result.fold(
      (failure) => emit(GetReviewErrorState(errorMessage: failure.message)),
      (review) => emit(GetReviewSuccessState(review: review)),
    );
  }
}
