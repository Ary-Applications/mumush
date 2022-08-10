
import 'package:injectable/injectable.dart';
import 'package:mumush/src/data/model/repository/schedule/schedule_request.dart';
import 'package:mumush/src/data/network/api_constants.dart';

import '../../../network/network_client.dart';
import '../../entity/schedule_model.dart';

@lazySingleton
class ScheduleService {
  final NetworkClient _networkClient;

  ScheduleService(this._networkClient);

  Future<Schedule?> getSchedule() {
    var request = ScheduleRequest();
    return _networkClient.run<Schedule>(request, BaseResponseType.performancesResponse);
  }
}