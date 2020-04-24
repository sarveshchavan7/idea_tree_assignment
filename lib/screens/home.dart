import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idea_tree_assignment/utils/flutter_local_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'package:idea_tree_assignment/bloc/home_bloc.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  final HomeBloc homebloc;

  const Home({Key key, this.homebloc}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with FlutterLocalNotification {
  HomeBloc _homeBloc;

  final _switchController = BehaviorSubject<bool>();

  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;

  Completer<GoogleMapController> _googleMapController = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.113965, 72.874376),
    zoom: 11.4746,
  );

  String _mapStyleSilver = '';

  @override
  void initState() {
    super.initState();
    _homeBloc = widget.homebloc;
    _getCurrentLocation();
    _loadMapStyle();
    _homeBloc.getPolylineCordinates();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _fabNotification(),
      body: Stack(
        children: <Widget>[
          _googleMap(),
          _switchMapStyle(),
        ],
      ),
    );
  }

  Widget _fabNotification() {
    return FloatingActionButton(
      child: Icon(
        Icons.notifications,
      ),
      backgroundColor: Colors.white,
      onPressed: () {
        displayNotification();
      },
    );
  }

  Widget _googleMap() {
    return StreamBuilder(
      initialData: <LatLng>[],
      stream: _homeBloc.polylineCordinatesStream,
      builder: (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
        Set<Marker> markers = _getMarkers(snapshot.data);
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          markers: markers,
          onMapCreated: _onMapCreated,
          polylines: Set.of([
            Polyline(
              color: Colors.blue,
              points: snapshot.data,
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
              geodesic: false,
              polylineId: PolylineId('line_one'),
            ),
          ]),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _googleMapController = Completer();
    _googleMapController.complete(controller);
    _setMapStyle(_mapStyleSilver);
  }

  void _animateCamera(LatLng coordinates) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinates, zoom: 14.0),
      ),
    );
  }

  Widget _switchMapStyle() {
    return StreamBuilder<bool>(
        initialData: true,
        stream: _switchController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 30, 0),
            child: Align(
              alignment: Alignment.topRight,
              child: Switch(
                value: snapshot.data,
                onChanged: (value) {
                  _setMapStyle(value ? _mapStyleSilver : null);
                  _switchController.sink.add(value);
                },
                activeTrackColor: Colors.purple[300],
                activeColor: Colors.deepPurple,
                inactiveTrackColor: Colors.deepPurple,
              ),
            ),
          );
        });
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _animateCamera(
        LatLng(position.latitude, position.longitude),
      );
      _homeBloc.polylineCordinatesSink.add(_homeBloc.polylineCordinatesVal
        ..add(
          LatLng(position.latitude, position.longitude),
        ));
    } catch (e) {
      // Show some toast message here
    }
  }

  Set<Marker> _getMarkers(List<LatLng> coordinates) {
    if (coordinates == null || coordinates.length < 2) {
      return Set.of([]);
    }
    return Set.of([
      Marker(
        markerId: MarkerId('source'),
        position: coordinates[coordinates.length - 1],
      ),
      Marker(
        markerId: MarkerId('destination'),
        position: coordinates[0],
      )
    ]);
  }

  void _setMapStyle(String mapStyle) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    super.dispose();
    _switchController.close();
  }

  void _loadMapStyle() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/map_style.json");
    _mapStyleSilver = data;
  }
}
