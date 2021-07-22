import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapView extends StatefulWidget {
  final double latitude, longitude;
  final String loc_addr;
  const MapView({Key key, this.latitude, this.longitude, this.loc_addr})
      : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  double latitude;
  double longitude;
  MapController controller = new MapController();
  @override
  void initState() {
    latitude = widget.latitude;
    longitude = widget.longitude;
    print(latitude.toString() + '...........');
    print(longitude.toString() + '...........');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Map"),
      ),
      body:
          // Container(child: Text(widget.loc_addr)),
          Column(
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.loc_addr),
              )),
          Expanded(
            child: FlutterMap(
              mapController: controller,
              options: new MapOptions(
                  center: LatLng(latitude, longitude), minZoom: 9.0),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 45.0,
                      height: 45.0,
                      point: LatLng(latitude, longitude),
                      builder: (context) => new Container(
                            child: IconButton(
                                icon: Icon(Icons.location_on),
                                color: Colors.red,
                                iconSize: 45.0,
                                onPressed: () {
                                  print("Success");
                                }),
                            // child: Icon(Icons.location_on),
                          ))
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
