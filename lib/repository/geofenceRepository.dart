import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:logging/logging.dart';

class GeofenceRepository {
  List<Geofence> geofenceList;
  GeofenceService geofenceService;

  final log = Logger("GeofenceRepository");

  static final GeofenceRepository _instance = GeofenceRepository._internal();

  factory GeofenceRepository() {
    return _instance;
  }

  GeofenceRepository._internal() {
    this.geofenceList = new List();
    this.geofenceService = GeofenceService.instance.setup(
        interval: 5000,
        accuracy: 100,
        loiteringDelayMs: 60000,
        statusChangeDelayMs: 10000,
        useActivityRecognition: true,
        allowMockLocations: false,
        geofenceRadiusSortType: GeofenceRadiusSortType.DESC);
  }

  void updateGeofenceList(String id, double latitude, double longitude) {
    log.info(
        "updateGeofenceList(id=$id, latitude=$latitude, longitude=$longitude");
    geofenceList.clear();
    geofenceList.add(
        Geofence(id: id, latitude: latitude, longitude: longitude, radius: [
      // GeofenceRadius(id: 'radius_100m', length: 100),
      GeofenceRadius(id: 'radius_25m', length: 25),
      GeofenceRadius(id: 'radius_1m', length: 1),
    ]));
  }
}
