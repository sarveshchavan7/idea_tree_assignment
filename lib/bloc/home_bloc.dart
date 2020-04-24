import 'dart:async';

import 'package:idea_tree_assignment/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeBloc implements BlocBase {
  final _polylineCordinatesController = BehaviorSubject<List<LatLng>>();

  // Stream
  Stream<List<LatLng>> get polylineCordinatesStream =>
      _polylineCordinatesController.stream;

  //Sink
  StreamSink<List<LatLng>> get polylineCordinatesSink =>
      _polylineCordinatesController.sink;

  // Value
  List<LatLng> get polylineCordinatesVal => _polylineCordinatesController.value;

  /* 
      In a production based application we will get
      polyline from backend server 
      so assume simulating network call
   */
  Future<List<LatLng>> getPolylineCordinates() async {
    List<LatLng> list = await Future.value([
      LatLng(18.966059, 72.843475),
      LatLng(18.975364, 72.844224),
      LatLng(18.984048, 72.842350),
      LatLng(18.991891, 72.841577),
      LatLng(19.011047, 72.848670),
      LatLng(19.029290, 72.857171),
      LatLng(19.042897, 72.863911),
      LatLng(19.048769, 72.868913),
      LatLng(19.052816, 72.880281),
    ]);
    polylineCordinatesSink.add(list);
    return list;
  }

  @override
  void dispose() {
    _polylineCordinatesController.close();
  }
}
