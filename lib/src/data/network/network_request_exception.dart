class NetworkRequestException implements Exception {
  static const int successStatusCode = 200;
  static const int noContentBodyStatusCode = 204;
  static const int badRequestStatusCode = 400;
  static const int unauthorisedStatusCode = 401;
  static const int forbiddenStatusCode = 403;
  static const int internalServerErrorStatusCode = 500;

  final String? _message;
  final String? _errorCode;

  NetworkRequestException([this._message, this._errorCode]);

  @override
  String toString() {
    return "Error code: $_errorCode. Message: $_message";
  }
}

class FetchDataException extends NetworkRequestException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends NetworkRequestException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends NetworkRequestException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class DecodableException extends NetworkRequestException {
  DecodableException([String? message])
      : super(message, "Failed to decode response body: ");
}

class NetworkTimeoutException extends NetworkRequestException {
  NetworkTimeoutException([String? message])
      : super(message, "TimeoutException: ");
}
