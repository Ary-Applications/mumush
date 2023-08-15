import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base/base_view_model.dart';

T? cast<T>(x) => x is T ? x : null;

@injectable
class SquareViewModel extends BaseViewModel {}
