
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homg_long/gps/cubit/gpsCubit.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/gpsService.dart';

enum gpsState { GPSSET, GPSUNSET }

class GPSSettingPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  GPSSettingPage(): super();

  static Route route(){
    return MaterialPageRoute(builder: (_) => GPSSettingPage());
  }

  @override
  Widget build(BuildContext context) {
    logUtil.logger.d("build gps page");
    return Scaffold(
      body: BlocProvider(
        create: (_) => GPSSettingCubit(context.read<GPSService>()),
        child: GPSSettingForm(),
      ),
    );
  }
}

class GPSSettingForm extends StatelessWidget {
  LogUtil logUtil = LogUtil();
  GPSSettingForm(): super(){
    init();
  }

  init(){
    _getCurrentLocation();
  }

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();

  // For storing the current position
  Position _currentPosition;

  String _currentAddress;

  final addressController = TextEditingController();

  final addressFocusNode = FocusNode();

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocListener<GPSSettingCubit, gpsState>(
      listener: (context, state){
        if (state == gpsState.GPSSET) {
          logUtil.logger.d("GPS set");
        }else {
          logUtil.logger.d("GPS unset");
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildGoogleMapWidget(),

            _buildZoomButton(),

            _buildInputField(context, width, height),

            _buildCurrentLocationButton(),
          ],
        ),
      )
    );
  }

  Widget _buildGoogleMapWidget(){
    return GoogleMap(
      initialCameraPosition: _initialLocation,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller){
        this.mapController = controller;
      },
    );
  }

  Widget _buildZoomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.blue[100], // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipOval(
              child: Material(
                color: Colors.blue[100], // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.remove),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, double width, double height){
    return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              width: width * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: width * 0.8,
                      child: TextField(
                        controller: addressController,
                        focusNode: addressFocusNode,
                        decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.home_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: () async {
                              await _getLocation(addressController.text);
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 18.0,
                                  ),
                                ),
                              );
                            },
                          ),
                          labelText: 'home location',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey[400],
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.blue[300],
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(15),
                          hintText: 'Set home location',
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: RaisedButton(
                          color: Colors.yellow[100],
                          onPressed: () {
                            DBHelper().updateLocation(_currentPosition.latitude, _currentPosition.longitude);
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (BuildContext context) => Page())
                            // );
                            Navigator.pushNamed(context, '/Main');
                          },
                          child: Text('save'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildCurrentLocationButton(){
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: ClipOval(
            child: Material(
              color: Colors.yellow[100], // button color
              child: InkWell(
                splashColor: Colors.yellow, // inkwell color
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.my_location),
                ),
                onTap: () {
                  mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                        ),
                        zoom: 18.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Method for retrieving the current location
  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logUtil.logger.e("Location services are disabled.");
      return;
    }

    // check has permission to location.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // request location permission.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        logUtil.logger.e("Location permission($permission) are denied", permission);
        return;
      }
    }

    // get current location with high accuracy.
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
        _currentPosition = position;
        logUtil.logger.d('CURRENT POS: $_currentPosition');
        await _getAddress();
    }).catchError((e) {
      logUtil.logger.e(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      // get placemark from latitude, longitude.
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];

      // update current address.
      _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      logUtil.logger.d('CURRENT Address: $_currentAddress');

      // update address controller.
      addressController.text = _currentAddress;
      logUtil.logger.d('addressController : ' + addressController.text);
    } catch (e) {
      logUtil.logger.e(e);
    }
  }

  _getLocation(String address) async {
    try {
      // get location from address.
      List<Location> l = await locationFromAddress(address);
      Location location = l[0];

      // overwrite new position to current position.
      Position _position = Position(latitude: location.latitude, longitude: location.longitude);
      _currentPosition = _position;
      logUtil.logger.d('_currentPosition: $_currentPosition');

      // update current address.
      _currentAddress = address;
      logUtil.logger.d('_currentAddress: $_currentAddress');
    } catch (e){
      logUtil.logger.e(e);
    }
  }
}

