
import '../base_request.dart';
import 'network_client.dart';

class BaseGetRequest<Output> implements IBaseRequest {
  final String _path;

  BaseGetRequest(this._path);

  @override
  Object? get body => null;

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  String get path => _path;
}
