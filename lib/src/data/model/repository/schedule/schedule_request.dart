import 'package:mumush/src/data/network/api_constants.dart';

import '../../../network/base_get_request.dart';
import '../../entity/schedule_model.dart';

class ScheduleRequest extends BaseGetRequest<Schedule?> {
  ScheduleRequest() : super(ApiConstants.performances);
}
