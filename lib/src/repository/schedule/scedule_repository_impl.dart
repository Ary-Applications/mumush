import 'package:injectable/injectable.dart';
import 'package:mumush/src/data/model/repository/schedule/schedule_service.dart';

import '../../data/model/entity/schedule_model.dart';
import '../../data/model/repository/schedule/schedule_remote_data_repository.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleService _scheduleService;

  ScheduleRepositoryImpl(this._scheduleService);

  @override
  Future<Schedule?> getSchedule() {
    return _scheduleService.getSchedule();
  }
}
