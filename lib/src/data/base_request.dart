import 'network/network_client.dart';

abstract class IBaseRequest {
  String get path;

  HttpMethod get method;

  Object? get body;
}
