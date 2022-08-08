


import 'package:injectable/injectable.dart';

import '../model/entity/model.dart';
import 'api_constants.dart';
import 'decodable.dart';
import 'network_client.dart';

abstract class BaseResponse implements Decodable {}

class BaseResponseFactory {
  static Decodable? getBaseResponse(BaseResponseType responseType) {
    switch (responseType) {
      case BaseResponseType.performancesResponse:
        return Schedule();
    }
  }
}