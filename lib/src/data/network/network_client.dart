import '../base_request.dart';
import 'api_constants.dart';
import 'decodable.dart';

abstract class NetworkClient {
  Future<T?> run<T extends Decodable>(
      IBaseRequest baseRequest, BaseResponseType baseResponseType);
}

enum HttpMethod { get, post, delete }
