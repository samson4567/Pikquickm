import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pikquick/core/api/pickquick_network_client.dart';
import 'package:pikquick/core/constants/endpoint_constant.dart';
import 'package:pikquick/core/db/app_preference_service.dart';
import 'package:pikquick/features/authentication/data/models/usermodel.dart';
import 'package:pikquick/features/profile/data/model/auto_sub_daily.dart';
import 'package:pikquick/features/profile/data/model/client_email.dart';
import 'package:pikquick/features/profile/data/model/client_profile_model.dart';
import 'package:pikquick/features/profile/data/model/client_profile_name.dart';
import 'package:pikquick/features/profile/data/model/create_model.dart';
import 'package:pikquick/features/profile/data/model/get_review_model.dart';
import 'package:pikquick/features/profile/data/model/get_runner_profile_model.dart';
import 'package:pikquick/features/profile/data/model/invite_sent_model.dart'
    show InviteSentToRunnerModel;
import 'package:pikquick/features/profile/data/model/profile_model.dart';
import 'package:pikquick/features/profile/data/model/runner_performance_model.dart';
import 'package:pikquick/features/profile/data/model/runnerdetails_model.dart';
import 'package:pikquick/features/profile/data/model/searh_runner_model.dart';
import 'package:pikquick/features/profile/data/model/unto_auto_daily.dart';
import 'package:pikquick/features/task/data/model/my_document_model.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';

abstract class ProfileRemoteDatasource {
  Future<List<ProfileEditModel>> profileEdit(
      {required ProfileEditModel profileEditModel});
  Future<GetRunnerProfileModel> getRunnerProfile({required String userID});
  Future<RunnerPerformanceModel> getRunnerPerformance({required String userID});
  Future<List<ProfileModel>> createProfile(
      {required ProfileModel profileModel});
  Future<List<RunnersAllDetailsModel>> runnerDetails({
    required RunnersAllDetailsModel runnerDetails,
    required double latitude,
    required double longitude,
    required double radius,
    required String transportMode,
    required int page,
    required int limit,
  });

  Future<GetRunnerProfileModel> viewRunnerDetailsSent({
    required String userId,
    // required GetRunnerProfileModel runnerDetailsSent
  });
  Future<SearchRunnerListModel> searchRunnerbydetaist(
      {required String query, required String page, required String limit});

  Future<InviteSentToRunnerModel> sendRunnerInvite(
      {required String taskId, required InviteSentToRunnerModel sendInvite});
  Future<List<MyDocumentEntity>> getVerifiedDocuments();

  Future<SubscribeAutoDeductionModel> subscribeAutoDeduction(
      {required SubscribeAutoDeductionModel model});

  Future<UnsubscribeAutoDeductionModel> unsubscribeAutoDeduction({
    required UnsubscribeAutoDeductionModel model,
  });
  Future<String> uploadProfilePicture({
    required File file,
  });
  Future<GetReviewModel> getReview({
    required GetReviewModel taskId,
  });
  Future<ClientEditProfileModel> clientprofileEdit({
    required ClientEditProfileModel clientModel,
  });
  Future<ClientEditProfilenameModel> clientprofilenameEdit({
    required ClientEditProfilenameModel clientModel,
  });
  Future<ClientEditProfileEmailModel> clientprofilenameEditemail({
    required ClientEditProfileEmailModel clientModel,
  });

  Future<UserModel> getUserProfle({
    required String? userID,
    required bool isByRunner,
  });
  Future<UserModel> getUserProflePlain({
    required String? userID,
    required bool isByRunner,
  });
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final AppPreferenceService appPreferenceService;

  final PikquickNetworkClient networkClient;

  ProfileRemoteDatasourceImpl({
    required this.appPreferenceService,
    required this.networkClient,
  });

  @override
  Future<List<ProfileEditModel>> profileEdit(
      {required ProfileEditModel profileEditModel}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getallTaskCategories,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return ProfileEditModel.fromJson(item);
    }).toList();
    return items;
  }

  @override
  Future<GetRunnerProfileModel> getRunnerProfile(
      {required String userID}) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.getRunnerProfile}/$userID',
      isAuthHeaderRequired: true,
    );
    return GetRunnerProfileModel.fromJson(response.data);
  }

  @override
  Future<RunnerPerformanceModel> getRunnerPerformance(
      {required String userID}) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.getrunnerPerformance}/$userID',
      isAuthHeaderRequired: true,
    );
    return RunnerPerformanceModel.fromJson(response.data);
  }

  @override
  Future<String> uploadProfilePicture({required File file}) async {
    print("dsajajbkjsbdjabskdbas");
    final fileBetter = await MultipartFile.fromFile(
      file!.path,
      filename: file!.path.split('/').last,
    );
    // mapToUpload.remove("file");
    Map mapToUpload = {};
    mapToUpload["file"] = file;

    final formData = FormData.fromMap({...mapToUpload});
    final response = await networkClient.post(
      endpoint: EndpointConstant.uploadKYCVerificationDocument,
      isAuthHeaderRequired: true,
      data: formData,
    );
    print('Response data********************: ${response.message}');
    return response.message;
    // ShareFeedbackModel.fromJson(response.data);
  }

  // @override
  // Future<RunnerPerformanceModel> getVerifiedDocuments(
  //     {required String userID}) async {
  //   final response = await networkClient.get(
  //     endpoint: '${EndpointConstant.getrunnerPerformance}/$userID',
  //     isAuthHeaderRequired: true,
  //   );
  //   return RunnerPerformanceModel.fromJson(response.data);
  // }
// getVerifiedDocuments
  @override
  Future<List<ProfileModel>> createProfile(
      {required ProfileModel profileModel}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.createProfile,
      isAuthHeaderRequired: true,
    );
    var items = (response.data as List).map((item) {
      return ProfileModel.fromJson(item);
    }).toList();
    return items;
  }

  @override
  Future<List<RunnersAllDetailsModel>> runnerDetails({
    required double latitude,
    required double longitude,
    required double radius,
    required String transportMode,
    required int page,
    required int limit,
    required RunnersAllDetailsModel runnerDetails, // Added
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getRunnerFullDetails,
      params: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'transport_mode': transportMode,
        'page': page,
        'limit': limit,
        'runner_details': runnerDetails.toJson(), // Fixed circular reference
      },
      isAuthHeaderRequired: true,
    );

    final dataList = response.data as List;
    return dataList.map((e) => RunnersAllDetailsModel.fromJson(e)).toList();
  }

  @override
  Future<GetRunnerProfileModel> viewRunnerDetailsSent({
    required String userId,
    // required GetRunnerProfileModel runnerDetailsSent,
  }) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.getRunnerProfile}/$userId',
      params: {'userId': userId},
      isAuthHeaderRequired: true,
    );

    return GetRunnerProfileModel.fromJson(response.data);
  }

  @override
  Future<SearchRunnerListModel> searchRunnerbydetaist({
    required String query,
    required String page,
    required String limit,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.search,
      params: {'query': query, 'page': page, 'limit': limit},
      isAuthHeaderRequired: true,
    );

    return SearchRunnerListModel.fromJson(response.data);
  }

  @override
  Future<InviteSentToRunnerModel> sendRunnerInvite({
    required String taskId,
    required InviteSentToRunnerModel sendInvite,
  }) async {
    print('${sendInvite.toJson()}************ ');
    print('${taskId}************ ');
    final response = await networkClient.put(
      endpoint: '${EndpointConstant.inviteSent}$taskId/invite-runner',
      isAuthHeaderRequired: true,
      data: sendInvite.toJson(),
      // {'runner_id': '6fe19e6b-fb77-42f2-add0-328681eb130d'}
    );

    return InviteSentToRunnerModel.fromJson(response.data);
  }

  @override
  Future<List<MyDocumentEntity>> getVerifiedDocuments() async {
    // print('${sendInvite.toJson()}************ ');
    // print('${taskId}************ ');
    final response = await networkClient.get(
      endpoint: EndpointConstant.getVerifiedDocuments,
      isAuthHeaderRequired: true,
      // data: sendInvite.toJson(),
      // {'runner_id': '6fe19e6b-fb77-42f2-add0-328681eb130d'}
    );
    List<MyDocumentEntity> result = (response.data as List?)?.map(
          (e) {
            return MyDocumentModel.fromJson(e);
          },
        ).toList() ??
        [];
    return result;
    // InviteSentToRunnerModel.fromJson(response.data);
  }

  @override
  Future<SubscribeAutoDeductionModel> subscribeAutoDeduction(
      {required SubscribeAutoDeductionModel model}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.subscribetoggle,
      isAuthHeaderRequired: true,
      data: model.toJson(),
    );
    return SubscribeAutoDeductionModel.fromJson(response.data);
  }

  @override
  Future<UnsubscribeAutoDeductionModel> unsubscribeAutoDeduction({
    required UnsubscribeAutoDeductionModel model,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.unsubscribetoggle,
      isAuthHeaderRequired: true,
      data: model.toJson(),
    );
    return UnsubscribeAutoDeductionModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getUserProfle(
      {required String? userID, required bool isByRunner}) async {
    final response = await networkClient.get(
      endpoint: (isByRunner)
          ? "${EndpointConstant.getRunnerProfile}/$userID"
          : EndpointConstant.getClientProfile,
      isAuthHeaderRequired: true,
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getUserProflePlain(
      {required String? userID, required bool isByRunner}) async {
    final response = await networkClient.get(
      endpoint: (isByRunner)
          ? "${EndpointConstant.getRunnerProfile}/$userID"
          : EndpointConstant.getClientProfile,
      isAuthHeaderRequired: true,
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<ClientEditProfileModel> clientprofileEdit(
      {required ClientEditProfileModel clientModel}) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.clientEditProfile,
      isAuthHeaderRequired: true,
      data: clientModel.toJson(),
    );
    return ClientEditProfileModel.fromJson(response.data);
  }

  @override
  Future<ClientEditProfilenameModel> clientprofilenameEdit(
      {required ClientEditProfilenameModel clientModel}) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.clientEditProfile,
      isAuthHeaderRequired: true,
      data: clientModel.toJson(),
    );
    return ClientEditProfilenameModel.fromJson(response.data);
  }

  @override
  Future<ClientEditProfileEmailModel> clientprofilenameEditemail(
      {required ClientEditProfileEmailModel clientModel}) async {
    final response = await networkClient.put(
      endpoint: EndpointConstant.clientEditProfile,
      isAuthHeaderRequired: true,
      data: clientModel.toJson(),
    );
    return ClientEditProfileEmailModel.fromJson(response.data);
  }

  @override
  Future<GetReviewModel> getReview({required GetReviewModel taskId}) async {
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.getReview}$taskId',
      isAuthHeaderRequired: true,
    );
    return GetReviewModel.fromJson(response.data);
  }
}

//profileEdit
