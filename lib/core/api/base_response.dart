class BaseResponse {
  String success;
  String message;
  String? token;
  dynamic data;

  BaseResponse(
      {required this.success,
      required this.message,
      required this.data,
      this.token});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    String status = json['success'] is bool
        ? (json['success'] ? 'true' : 'false')
        : json['success'].toString();
    return BaseResponse(
        success: status,
        message: json['message'] ?? "",
        data: json['data'],
        token: json['token']);
  }
}
