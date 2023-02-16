import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// double lat;
// double long;

  LatLng _currentLocation = LatLng(49.81876877181713, 73.10427022963775);
  late final GoogleMapController _googleMapController;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Универы'), centerTitle: true, backgroundColor: Colors.pink,),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition:
                CameraPosition(target: _currentLocation, zoom: 5),
            markers: _markers,
            onMapCreated: ((controller) => _googleMapController = controller),
          ),

          //наша кнопка
          Container(
            padding: EdgeInsets.only(top: 150, right: 10),
            alignment: Alignment.topRight,
            child: Column(children: [
              FloatingActionButton(
                onPressed: _changeMapType,
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.map,
                  size: 30,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //кнопка для показа маркера
              FloatingActionButton(
                onPressed: _addMarker,
                backgroundColor: Colors.pink,
                child: Icon(Icons.location_history_rounded),
              ),
              SizedBox(
                height: 10,
              ),
              //Кнопка для того чтобы поменять место или фокус
              FloatingActionButton(
                onPressed: _moveToNewLocation,
                backgroundColor: Colors.blue,
                child: Icon(Icons.home),
              ),SizedBox(
                height: 10,
              ),
              //Реальное место положение 
              // FloatingActionButton(
              //   onPressed: (){
              //     _myLocation().then((value) {
              //       lat = value.latitude;
              //       long= value.longitude;
              //     });
              //   },
              //   backgroundColor: Color.fromARGB(255, 50, 50, 50),
              //   child: Icon(Icons.home),
              // ),
              
            ]),
          ),
        ],
      ),
    );
  }

  //вернуть состояние
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

//метод измениние Карты на спутник и обратно
  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

// Метод для того чтоб показать Маркер
  void _addMarker() {
    //это перенос локации
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15));
        //это показ маркера и далее
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('defaultLocation'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow:
            const InfoWindow(title: 'Really cool place', snippet: '5 Star'),
      ));
    });
  }

//поменять локацию типо дом КАТАР
//async
  void _moveToNewLocation() {
    const _newPosition = LatLng(25.308954, 51.234838);
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(_newPosition, 15));
    setState(() {
      const marker=Marker(
        markerId: MarkerId('MyHome'),
        position: _newPosition,
        infoWindow: InfoWindow(title: 'Home', snippet: '5 Star'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }
}
