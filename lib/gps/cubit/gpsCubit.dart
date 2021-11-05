import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/gpsService.dart';

import '../view/gpsSettingPage.dart';

class GPSSettingCubit extends Cubit<gpsState> {
  GPSService _GPSService;

  GPSSettingCubit(this._GPSService) : super(null) {
    init();
  }

  init() {}
}
