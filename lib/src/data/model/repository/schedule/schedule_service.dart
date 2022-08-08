
import 'package:injectable/injectable.dart';

import '../../../network/network_client.dart';

@lazySingleton
class ScheduleService {
  final NetworkClient _networkClient;

  ScheduleService(this._networkClient);

  Future<Schedule> getSchedule() {
    var request = 
  }
}