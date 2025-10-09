import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikquick/app_variable.dart';
import 'package:pikquick/features/authentication/data/models/token_model.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/authentication/domain/entities/Refresh_entiy.dart';
import 'package:pikquick/features/authentication/domain/entities/user_entity.dart';
import 'package:pikquick/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:pikquick/features/authentication/presentation/blocs/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authenticationRepository;

  AuthBloc({
    required this.authenticationRepository,
  }) : super(const AuthInitial()) {
    on<NewUserSignUpEvent>(_onNewUserSignUpEvent);
    on<VerifyNewSignUpEmailEvent>(_onVerifyNewSignUpEmailEvent);
    on<LoginEvent>(_onLoginEvent);

    on<ResendOtpEvent>(_onResendOtpEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<ChangePasswordEvent>(_onChangePassword);
    on<TaskCategoryEvent>(_onTrackCategoriesEvent);
    on<VerifyResetOTPEvent>(_onVerifyResetOTPEvent);
    on<RessetPasswordEvent>(_onResetPasswordEvent);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<ShareFeedbackEvent>(_onShareFeedBack);
    on<UploadkycDocumentEvent>(_onUploadkycDocument);
    on<GetRunnerVerificationDetailsEvent>(_onGetRunnerVerificationDetails);
    on<LogOutEvent>(_onLogOutEvent);
  }
  // logOut
  Future<void> _onNewUserSignUpEvent(
    NewUserSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const NewUserSignUpLoadingState());

    final result = await authenticationRepository.newUserSignUp(
      newUserRequest: event.newUserRequest,
    );
    result.fold(
      (error) => emit(NewUserSignUpErrorState(errorMessage: error.message)),
      (message) => emit(NewUserSignUpSuccessState(message: message)),
    );
  }

  Future<void> _onVerifyNewSignUpEmailEvent(
      VerifyNewSignUpEmailEvent event, Emitter<AuthState> emit) async {
    emit(const VerifyNewSignUpEmailLoadingState());
    final result = await authenticationRepository.verifySignUp(
      email: event.email,
      otp: event.otp,
    );
    result.fold(
      (error) =>
          emit(VerifyNewSignUpEmailErrorState(errorMessage: error.message)),
      (entity) =>
          emit(VerifyNewSignUpEmailSuccessState(message: entity.message)),
    );
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const LoginLoadingState());

    final result = await authenticationRepository.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (error) => emit(LoginErrorState(errorMessage: error.message)),
      (data) {
        
        print("dlasjkdbhjdbakjsbdaskjdak>>acted");
        userModelG = UserModel.createFromLogin(data['user']);
        authenticationRepository
            .cacheAuthToken(TokenModel(accessToken: data['access_token']));
        print(
            "dlasjkdbhjdbakjsbdaskjdak>>refr_token_to_be_stored>>${data['refresh_token']}");
        authenticationRepository.cacheRefreshToken(data['refresh_token']).then(
          (value) {
            print("dlasjkdbhjdbakjsbdaskjdak>>refre_SUCCESS");
          },
        );

        emit(LoginSuccessState(
            accessToken: data['access_token'],
            // refreshToken: data["refresh_token"],
            message: "Login Successful",
            user: UserModel.fromJson(data["user"])
            // UserEntity(
            //   id: '',
            //   fullName: '',
            //   email: '',
            //   phone: '',
            //   role: userModelG?.role ?? '',
            //   status: '',
            //   isActive: false,
            //   createdAt: DateTime.now(),
            //   updatedAt: DateTime.now(),
            //   imageUrl: null,
            // ),
            ));
      },
    );
  }

  Future<void> _onResendOtpEvent(
      ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const ResendOtpLoadingState());
    final result = await authenticationRepository.resendOtp(email: event.email);
    result.fold(
      (error) => emit(ResendOtpErrorState(errorMessage: error.message)),
      (message) => emit(ResendOtpSuccessState(message: message)),
    );
  }

  Future<void> _onForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoadingState());
    final result =
        await authenticationRepository.forgotPassword(email: event.email);
    result.fold(
      (error) => emit(ForgotPasswordErrorState(errorMessage: error.message)),
      (message) => emit(ForgotPasswordSuccessState(message: message)),
    );
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(ChangePasswordLoadingState());
    final result = await authenticationRepository.changePassword(
        currentPassword: event.currentPassword, newPassword: event.newPassword);
    result.fold(
      (error) => emit(ChangePasswordErrorState(errorMessage: error.message)),
      (message) => emit(ChangePasswordSuccessState(message: message)),
    );
  }

  Future<void> _onVerifyResetOTPEvent(
      VerifyResetOTPEvent event, Emitter<AuthState> emit) async {
    emit(VerifyResetOTPLoadingState());
    final result = await authenticationRepository.verifyResetOtp(
        email: event.email, otp: event.otp);
    result.fold(
      (error) => emit(VerifyResetOTPErrorState(errorMessage: error.message)),
      (message) => emit(VerifyResetOTPSuccessState(message: message)),
    );
  }

  Future<void> _onResetPasswordEvent(
      RessetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResetPassowordLoading());
    final result = await authenticationRepository.resetPassword(
        email: event.email, token: event.token, newPassword: event.newPassword);
    result.fold(
      (error) => emit(ResetPassowordErrorState(errorMessage: error.message)),
      (message) => emit(ResetPassowordSuccessState(message: message)),
    );
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(RefreshTokenLoadingState());

    final result = await authenticationRepository.refreshToken(
      refreshToken: event.model.refreshToken, // ✅ pass string
    );

    result.fold(
      (error) => emit(RefreshTokenErrorState(message: error.message)),
      (data) => emit(RefreshTokenSuccessState(
          token: RefreshTokenEntity(refreshToken: data))),
    );
  }

  Future<void> _onTrackCategoriesEvent(
    TaskCategoryEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(TaskCategoryLoadingState());
    try {
      final result = await authenticationRepository.taskCategories();

      result.fold(
        (error) {
          emit(TaskCategoryErrorState(errorMessage: error.message));
        },
        (data) {
          emit(TaskCategorySuccessState(categories: data));
        },
      );
    } catch (e, s) {
      print("Exception in _onTrackCategoriesEvent: $e\n$s");
      emit(TaskCategoryErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _onShareFeedBack(
      ShareFeedbackEvent event, Emitter<AuthState> emit) async {
    emit(ShareFeedbackLoading());
    final result =
        await authenticationRepository.shareFeedback(shared: event.feedModel);
    result.fold(
        (error) => emit(ShareFeedbackErrorState(errorMessage: error.message)),
        (data) => emit(ShareFeedbackSucessState(feedBack: data)));
  }

  Future<void> _onUploadkycDocument(
      UploadkycDocumentEvent event, Emitter<AuthState> emit) async {
    emit(UploadkycDocumentLoadingState());
    final result = await authenticationRepository.uploadkycDocument(
        kycRequestEntity: event.kycRequestEntity);
    result.fold(
        (error) =>
            emit(UploadkycDocumentErrorState(errorMessage: error.message)),
        (data) => emit(UploadkycDocumentSuccessState(message: data)));
  }

  Future<void> _onGetRunnerVerificationDetails(
      GetRunnerVerificationDetailsEvent event, Emitter<AuthState> emit) async {
    emit(GetRunnerVerificationDetailsLoadingState());
    final result =
        await authenticationRepository.getRunnerVerificationDetails();
    result.fold(
        (error) => emit(GetRunnerVerificationDetailsErrorState(
            errorMessage: error.message)),
        (runnerVerificationDetailsEntity) => emit(
            GetRunnerVerificationDetailsSuccessState(
                runnerVerificationDetailsEntity:
                    runnerVerificationDetailsEntity)));
  }

  Future<void> _onLogOutEvent(
      LogOutEvent event, Emitter<AuthState> emit) async {
    emit(LogOutLoadingState());

    final result = await authenticationRepository.logOut();
    result.fold((error) => emit(LogOutErrorState(errorMessage: error.message)),
        (message) => emit(LogOutSuccessState(message: message)));
  }
  // _onLogOutEvent
}
