import 'package:dio/dio.dart';
import 'package:pikquick/core/api/pickquick_network_client.dart';
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/features/authentication/data/models/kyc_request_model.dart';
import 'package:pikquick/features/authentication/data/models/new_user_request_model.dart';
import 'package:pikquick/features/authentication/data/models/runner_verification_details_model.dart';
import 'package:pikquick/features/authentication/data/models/share_feee_model.dart';
import 'dart:developer';

import 'package:pikquick/features/authentication/data/models/taskcategories_model.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';
import 'package:pikquick/features/authentication/domain/entities/runner_verification_details_entity.dart';
import 'package:pikquick/features/transaction/data/model/transaction_model.dart';

abstract class AuthenticationRemoteDatasource {
  Future<String> newUserSignUp({required NewUserRequestModel newUserRequest});
  Future<String> verifySignUp({required String email, required String otp});
  Future<Map> login({required String email, required String password});
  Future<String> resendOtp({required String email});
  Future<String> forgotPassword({required String email});
  Future<String> changePassword(
      {required String currentPassword, required String newPassword});
  Future<List<CustomCategoryTaskModel>> taskCategories();
  Future<String> verifyResetOtp({required String email, required String otp});
  Future<String> resetPassword(
      {required String email,
      required String token,
      required String newPassword});
  Future<String> refreshToken({
    required String refreshToken,
  });
  Future<List<TransactionModel>> transaction({
    required String page,
    required String limit,
  });

  Future<ShareFeedbackModel> shareFeedBack(
      {required ShareFeedbackModel feedModel});
  Future<String> uploadkycDocument(
      {required KycRequestEntity kycRequestEntity});
  Future<RunnerVerificationDetailsEntity> getRunnerVerificationDetails();

  //getRunnerVerificationDetails
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  AuthenticationRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final PikquickNetworkClient networkClient;

  @override
  Future<String> newUserSignUp({
    required NewUserRequestModel newUserRequest,
  }) async {
    // Log request details
    print("╔══════════════════════ SIGN UP REQUEST ══════════════════════╗");
    print("║ Endpoint: ${EndpointConstant.signUp}");
    print("║ Payload: ${newUserRequest.toJson()}");
    print("╚═════════════════════════════════════════════════════════════╝");

    final response = await networkClient.post(
      endpoint: EndpointConstant.signUp,
      data: newUserRequest.toJson(),
    );
    // Log response details
    print("╔══════════════════════ SIGN UP RESPONSE ═════════════════════╗");
    print("║ Message: ${response.message}");
    print("║ Data: ${response.data ?? 'No additional data'}");
    print("╚═════════════════════════════════════════════════════════════╝");

    return response.message;
  }

  @override
  Future<String> verifySignUp(
      {required String email, required String otp}) async {
    print([email, otp]);
    final response = await networkClient.post(
      endpoint: EndpointConstant.verifySignUp,
      data: {
        "email": email,
        "otp": otp.toString(),
      },
    );
    return response.message;
  }

  @override
  Future<Map> login({required String email, required String password}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.login,
      data: {
        "email": email,
        "password": password,
      },
    );
    log('datasources${response.data}');

    return response.data;
  }

  @override
  Future<String> resendOtp({required String email}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.resendOtp,
      data: {
        "email": email,
      },
    );
    return response.message;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.forgetPassword,
      data: {'email': email},
    );
    return response.message;
  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.changePassword,
      isAuthHeaderRequired: true,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    // Ensure we return a String
    if (response.data is Map && response.data['message'] != null) {
      return response.data['message'].toString();
    }

    // Fallback if API doesn't return "message"
    return 'Password changed successfully';
  }

  @override
  Future<String> verifyResetOtp(
      {required String email, required String otp}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.verifyrestotp,
        isAuthHeaderRequired: true,
        data: {'email': email, 'otp': otp});

    return response.data;
  }

  @override
  Future<String> resetPassword(
      {required String email,
      required String token,
      required String newPassword}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.resetPassword,
        isAuthHeaderRequired: true,
        data: {'email': email, 'token': token, 'newPassword': newPassword});

    return response.data;
  }

  @override
  Future<List<CustomCategoryTaskModel>> taskCategories() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getallTaskCategories,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return CustomCategoryTaskModel.fromJson(item);
    }).toList();
    return items;
  }

  @override
  Future<String> refreshToken({required String refreshToken}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.refreshToken,
        isAuthHeaderRequired: true,
        data: {
          'refreshToken': refreshToken,
        });

    return response.data;
  }

  @override
  Future<List<TransactionModel>> transaction({
    required String page,
    required String limit,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.transaction,
      isAuthHeaderRequired: true,
      params: {
        'page': page,
        'limit': limit,
      },
    );

    // Debug: log the exact response so you can check the structure
    print('Transaction API raw response: ${response.data}');

    List<dynamic>? transactionsList;
    if (response.data is Map<String, dynamic>) {
      transactionsList = response.data['transactions']?['data'];
      transactionsList ??= response.data['transaction']?['data'];
    }
    transactionsList ??= [];
    print(transactionsList);

    // Map to TransactionModel list
    return transactionsList
        .map<TransactionModel>((item) => TransactionModel.fromJson(item))
        .toList();
  }

  @override
  Future<ShareFeedbackModel> shareFeedBack(
      {required ShareFeedbackModel feedModel}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.feedback,
      isAuthHeaderRequired: true,
      data: feedModel.toJson(),
    );
    print('Response data********************: ${response.message}');
    return ShareFeedbackModel.fromJson(response.data);
  }

  @override
  Future<String> uploadkycDocument(
      {required KycRequestEntity kycRequestEntity}) async {
    print("dsajajbkjsbdjabskdbas>>${kycRequestEntity.file}");
    Map<String, dynamic> mapToUpload =
        KycRequestModel().fromEntity(kycRequestEntity)!.toJson();
    print("dsajajbkjsbdjabskdbas");
    final file = await MultipartFile.fromFile(
      kycRequestEntity.file!.path,
      filename: kycRequestEntity.file!.path.split('/').last,
    );
    // mapToUpload.remove("file");
    mapToUpload["file"] = file;

    final formData = FormData.fromMap(mapToUpload);
    final response = await networkClient.post(
      endpoint: EndpointConstant.uploadKYCVerificationDocument,
      isAuthHeaderRequired: true,
      data: formData,
    );
    print('Response data********************: ${response.message}');
    return response.message;
    // ShareFeedbackModel.fromJson(response.data);
  }

  @override
  Future<RunnerVerificationDetailsEntity> getRunnerVerificationDetails() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getRunnerVerificationDetails,
      isAuthHeaderRequired: true,
    );
    print('Response data********************: ${response.message}');
    return RunnerVerificationDetailsModel.fromJson(response.data);
  }
}
