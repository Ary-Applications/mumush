import 'package:injectable/injectable.dart';
import 'package:mumush/src/screens/timeline/event.dart';
import 'package:mumush/src/screens/timeline/square_widget.dart';
import '../../application/appViewModel.dart';
import '../base/base_view_model.dart';

@injectable
class TimelineViewModel extends BaseViewModel {
  List<SquareWidget> makeSquareListsFromPerformances(List<Performance> performances) {
    List<SquareWidget> squaresToReturn = [];
    for (var performance in performances) {
      var startDate = performance.data.attributes?.start ?? "";
      var endDate = performance.data.attributes?.end ?? "";
      var startToEnd = startDate + "-" + endDate;

      var event = Event(performance.data.relationships?.artists?.data?.id ?? "",
          "", (startToEnd));
      squaresToReturn.add(SquareWidget(event: event));
    }
    return squaresToReturn;
  }
}
