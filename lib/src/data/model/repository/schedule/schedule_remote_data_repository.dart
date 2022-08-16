import '../../entity/schedule_model.dart';

abstract class ScheduleRepository {
  Future<Schedule?> getSchedule();
}
