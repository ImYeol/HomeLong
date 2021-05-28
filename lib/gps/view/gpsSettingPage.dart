import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homg_long/gps/cubit/gpsCubit.dart';
import 'package:homg_long/log/logger.dart';
import 'package:homg_long/repository/db.dart';
import 'package:homg_long/repository/gpsService.dart';
import 'package:homg_long/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homg_long/const/errorMessage.dart';

enum gpsState { GPSSET, GPSUNSET }

class GPSSettingPage extends StatelessWidget {
  LogUtil logUtil = LogUtil();

  GPSSettingPage() : super();

  static Route route() {
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
  // permission
  bool _serviceEnabled;
  LocationPermission _permission;

  // location
  LatLng _currentLocation = new LatLng(0.0, 0.0);
  Position _currentPosition;
  Placemark _currentPlaceMark;

  // log
  LogUtil logUtil = LogUtil();

  // google map
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController _mapController;

  // ui
  final _addressController = TextEditingController();

  GPSSettingForm() : super() {
    init();
  }

  init() {
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return BlocListener<GPSSettingCubit, gpsState>(
        listener: (context, state) {
          if (state == gpsState.GPSSET) {
            logUtil.logger.d("GPS info is loaded");
          } else {
            logUtil.logger.d("GPS info is unloaded yet");
          }
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildGoogleMapWidget(context),
              _buildZoomButton(),
              AddressInput(
                  width: width,
                  addressController: this._addressController,
                  currentLocation: this._currentLocation),
              _buildCurrentLocationButton(),
            ],
          ),
        ));
  }

  Widget _buildGoogleMapWidget(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialLocation,
      myLocationEnabled: true,
      // myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        // update googleMapController
        _mapController = controller;
      },
      onTap: (LatLng latLng) async {
        _updateCurrentLocation(latLng.latitude, latLng.longitude);

        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation.latitude,
              _currentLocation.longitude,
            ),
            zoom: 18.0,
          ),
        ));

        Placemark placeMark = await _getPlaceMark(latLng);

        _updateCurrentPlaceMark(placeMark);
        await _updateAddressController(placeMark.street);

        showToast("${placeMark.street}");
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
                    _mapController.animateCamera(
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
                    _mapController.animateCamera(
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

  Widget _buildCurrentLocationButton() {
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
                  _getCurrentLocation();
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
    bool permitted = await _permissionCheck();
    if (permitted == false) {
      // location permission is not allowed.
      showToast(SetLocationPermission);
      return;
    }

    // get current location with high accuracy.
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;

      if (position != null) {
        _updateCurrentLocation(position.latitude, position.longitude);
      }

      logUtil.logger.d('_currentPosition:$_currentPosition');
      Placemark placeMark = await _getPlaceMark(
          new LatLng(position.latitude, position.longitude));

      if (placeMark != null) {
        _updateCurrentPlaceMark(placeMark);
      }

      if (placeMark.name != null) {
        await _updateAddressController(placeMark.street);
      }

      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation.latitude,
            _currentLocation.longitude,
          ),
          zoom: 18.0,
        ),
      ));
    }).catchError((e) {
      logUtil.logger.e(e);
    });
  }

  Future<bool> _permissionCheck() async {
    // check location services are enabled.
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      logUtil.logger.e("Location services are disabled.");
      return false;
    }

    // check has permission to location.
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      // request location permission.
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        logUtil.logger
            .e("Location permission($_permission) are denied", _permission);
        return false;
      }
    }
    return true;
  }

  // Method for retrieving the address
  Future<Placemark> _getPlaceMark(LatLng latLng) async {
    try {
      // get PlaceMark from latitude, longitude.
      List<Placemark> p =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      return p[0];
    } catch (e) {
      logUtil.logger.e(e);
      return null;
    }
  }

  _updateCurrentPlaceMark(Placemark placeMark) {
    _currentPlaceMark = placeMark;
  }

  _updateCurrentLocation(double latitude, double longitude) {
    _currentLocation = new LatLng(latitude, longitude);
  }

  _updateAddressController(String address) async {
    _addressController.text = address;
  }
}

class AddressInput extends StatefulWidget {
  double width;
  TextEditingController addressController;
  LatLng currentLocation;

  AddressInput(
      {double width,
      TextEditingController addressController,
      LatLng currentLocation}) {
    this.width = width;
    this.addressController = addressController;
    this.currentLocation = currentLocation;
  }

  @override
  _AddressInputState createState() => _AddressInputState(
      width: this.width,
      addressController: this.addressController,
      currentLocation: currentLocation);
}

class _AddressInputState extends State<AddressInput> {
  double width;
  TextEditingController addressController;
  LatLng currentLocation;

  _AddressInputState(
      {double width,
      TextEditingController addressController,
      LatLng currentLocation}) {
    this.width = width;
    this.addressController = addressController;
    this.currentLocation = currentLocation;
  }

  @override
  Widget build(BuildContext context) {
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
                      // focusNode: addressFocusNode,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.home_rounded),
                        labelText: 'home address',
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
                      onChanged: (String input) {
                        // _getLocationWithAddress(input);
                      },
                      onTap: () async {
                        showSearch(
                            context: context,
                            delegate: AddressSearch(addressController),
                            query: addressController.text);
                      },
                    ),
                  ),
                  Container(
                    width: width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.yellow[100]),
                        ),
                        onPressed: () {
                          _getLatLngFromAddress(addressController.text);
                          DBHelper().updateLocation(currentLocation.latitude,
                              currentLocation.longitude);
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

  _getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    for (int i = 0; i < locations.length; i++) {
      print("location[$i]:${locations[i].latitude}, ${locations[i].longitude}");
    }
    currentLocation = new LatLng(locations[0].latitude, locations[0].longitude);
  }
}

class AddressSearch extends SearchDelegate<String> {
  final String _sessionString = getRandomString(5);

  TextEditingController addressController;

  AddressSearch(TextEditingController addressController) {
    this.addressController = addressController;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("buildResults query=$query");
    if (query == '') {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Search term must be longer than two letters.",
              ),
            )
          ]);
    }
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      // We will put the api call here
      future: _searchLocation(),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter your address!'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    // we will display the data returned from our future here
                    title: Text(snapshot.data[index]),
                    onTap: () {
                      close(context, snapshot.data[index]);
                      addressController.text = snapshot.data[index];
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
  }

  Future _searchLocation() async {
    print("_searchLocation() start($query)");
    List<Suggestion> suggestions =
        await PlaceApiProvider(_sessionString).fetchSuggestions(query, "ko");
    List<String> addressList = new List<String>();

    // places.PlacesSearchResponse response = await googlePlace.searchByText(query);
    for (int i = 0; i < suggestions.length; i++) {
      addressList.add(suggestions[i].description);
    }

    // return suggestions;
    return addressList;
  }
}
