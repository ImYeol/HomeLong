import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homg_long/repository/gpsService.dart';
import 'package:homg_long/repository/model/wifiState.dart';
import 'package:homg_long/repository/wifiConnectionService.dart';

import '../view/gpsSettingPage.dart';


class GPSSettingCubit extends Cubit<gpsState> {
  GPSService _GPSService;

  GPSSettingCubit(GPSService gpsService) : super(null){
   this. _GPSService = gpsService;
   init();
  }

  init(){

  }

}
