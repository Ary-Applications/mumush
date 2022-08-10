import '../model/entity/schedule_model.dart';
import 'api_constants.dart';
import 'decodable.dart';

abstract class BaseResponse implements Decodable {}

class BaseResponseFactory {
  static Decodable? getBaseResponse(BaseResponseType responseType) {
    switch (responseType) {
      case BaseResponseType.performancesResponse:
        return Schedule();
    }
  }
}