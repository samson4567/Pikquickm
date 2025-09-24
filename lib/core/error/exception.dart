abstract class AppException implements Exception{
  const AppException({required this.message, this.description});
  final String message;
  final String? description;
}

class NetworkException extends AppException{
  const NetworkException({
    super.message = "No Internet Connection",
    super.description = "Please check your Internet connection",
  });
}

class UnAuthorizedException extends AppException{
  const UnAuthorizedException({required super.message, super.description});
}

class ClientException extends AppException{
  const ClientException({required super.message, super.description});
}

class ServerException extends AppException{
  const ServerException({required super.message, super.description});
}

class TimeoutException extends AppException{
  const TimeoutException({
    super.message = "Request timed out", super.description = "Try again later",});
}

class BadRequestException extends AppException{
  const BadRequestException({required super.message, super.description});
}

class UnknownException extends AppException{
  const UnknownException({required super.message, super.description});
}