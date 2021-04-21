import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  LatLng _initialcameraposition = LatLng(32.4038, 35.2367);
  GoogleMapController _controller;
  Location _location = Location();
  var _currentMapType;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = LatLng(32.4038, 35.2367);

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(32.4038, 35.2367),zoom: 7),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Padding(
          padding: const EdgeInsets.fromLTRB(0,29,0,0),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: _initialcameraposition),
                mapType: _currentMapType,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onLongPress:(positionPresses) => {
                  _onAddMarkerButtonPressed(positionPresses)
                },
                markers: _markers,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,60,5,0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }
  void _onAddMarkerButtonPressed( LatLng position ) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: "Set Location",
          onTap: () => {
            Navigator.pop(context, position)
          },
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
}