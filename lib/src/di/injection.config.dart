// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../application/appViewModel.dart' as _i3;
import '../data/model/repository/schedule/schedule_remote_data_repository.dart'
    as _i10;
import '../data/model/repository/schedule/schedule_service.dart' as _i8;
import '../data/network/http_client.dart' as _i7;
import '../data/network/network_client.dart' as _i6;
import '../repository/schedule/scedule_repository_impl.dart' as _i11;
import '../screens/home/home_view_model.dart' as _i4;
import '../screens/map/map_view_model.dart' as _i5;
import '../screens/timeline/square_view_model.dart' as _i9;
import '../screens/timeline/timeline_view_model.dart' as _i12;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.AppViewModel>(() => _i3.AppViewModel());
  gh.factory<_i4.HomeViewModel>(() => _i4.HomeViewModel());
  gh.factory<_i5.MapViewModel>(() => _i5.MapViewModel());
  gh.lazySingleton<_i6.NetworkClient>(() => _i7.HttpClient());
  gh.lazySingleton<_i8.ScheduleService>(
      () => _i8.ScheduleService(gh<_i6.NetworkClient>()));
  gh.factory<_i9.SquareViewModel>(() => _i9.SquareViewModel());
  gh.lazySingleton<_i10.ScheduleRepository>(
      () => _i11.ScheduleRepositoryImpl(gh<_i8.ScheduleService>()));
  gh.factory<_i12.TimelineViewModel>(
      () => _i12.TimelineViewModel(gh<_i10.ScheduleRepository>()));
  return getIt;
}
