import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:mumush/src/data/base_request.dart';
import 'package:mumush/src/data/network/api_constants.dart';
import 'package:mumush/src/data/network/decodable.dart';

import 'base_response.dart';
import 'network_client.dart';
import 'network_request_exception.dart';

@LazySingleton(as: NetworkClient)
class HttpClient implements NetworkClient {
  late http.Client _httpClient;
  static const int requestTimeout = 15;
  static const Duration requestTimeoutDuration =
      Duration(seconds: requestTimeout);

  @override
  Future<T?> run<T extends Decodable>(
      IBaseRequest baseRequest, BaseResponseType baseResponseType) async {
    T? response;
    http.Response? httpResponse;

    try {
      final requestUrl = ApiConstants.baseUrl + baseRequest.path;
      late DateTime start;
      late DateTime end;

      switch (baseRequest.method) {
        case HttpMethod.get:
          debugPrint("--> GET: " + requestUrl);
          start = DateTime.now();
          httpResponse = await _httpClient
              .get(Uri.parse(requestUrl), headers: null)
              .timeout(const Duration(seconds: requestTimeout));
          end = DateTime.now();
          break;
        case HttpMethod.post:
          debugPrint("--> POST: " + requestUrl);
          String requestBody = jsonEncode(baseRequest.body);
          debugPrint("Request Body: " + requestBody);
          start = DateTime.now();
          httpResponse = await _httpClient
              .post(Uri.parse(requestUrl), headers: null, body: requestBody)
              .timeout(const Duration(seconds: requestTimeout));
          end = DateTime.now();
          break;
        case HttpMethod.delete:
          break;
      }
      response = _handleResponse(httpResponse!, baseResponseType, start, end);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on UnauthorisedException {
      debugPrint("Unauthorised, should logout!");
    } on Exception catch (e) {
      debugPrint('General network exception caught: ${e.toString()}');
    }
    return response;
  }

  T? _handleResponse<T extends Decodable>(http.Response response,
      BaseResponseType baseResponseType, DateTime start, DateTime end) {
    int statusCode = response.statusCode;

    debugPrint(
        "<-- $statusCode ${response.request!.url} (${end.difference(start).inMilliseconds}ms)");
    switch (statusCode) {
      case NetworkRequestException.successStatusCode:
        debugPrint("Response Body: " + response.body.toString());
        return _getDecodedObj(response.body, baseResponseType);
      case NetworkRequestException.noContentBodyStatusCode:
        debugPrint("No Content Response Body: " + response.body.toString());
        return null;
      case NetworkRequestException.badRequestStatusCode:
        debugPrint("BadRequestException:" + response.body.toString());
        throw (response.body.toString());
      case NetworkRequestException.unauthorisedStatusCode:
      case NetworkRequestException.forbiddenStatusCode:
        debugPrint("UnauthorisedException:" + response.body.toString());
        throw UnauthorisedException(response.body.toString());
      case NetworkRequestException.internalServerErrorStatusCode:
      default:
        debugPrint("FetchDataException:" + response.body.toString());
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  T? _getDecodedObj<T>(String responseBody, BaseResponseType baseResponseType) {
    T? decodedObj;
    try {
      var baseResponse = BaseResponseFactory.getBaseResponse(baseResponseType)!;
      decodedObj = baseResponse.decode(responseBody) as T;
    } catch (error) {
      debugPrint("Decoding exception:" + error.toString());
      throw DecodableException(error.toString());
    }
    return decodedObj;
  }
}
