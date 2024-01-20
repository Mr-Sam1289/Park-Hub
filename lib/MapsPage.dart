import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartparkin1/dateandtime.dart';

import 'HomePage.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  MapsPageState createState() => MapsPageState();
}

const kGoogleApiKey = 'AIzaSyCQCrWhfNM2AnegyOq4C6v9FxJeNPovA6M';

class MapsPageState extends State<MapsPage> {


  final Completer<GoogleMapController> _controller = Completer();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.39587287558397, 78.62196950902965),
    zoom: 16,
  );

  List<Marker> marker = [];
  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;


  Marker createMarker(String markerId, double lat, double lng, String title) {
    var mid = markerId;
    return Marker(
      markerId: MarkerId(markerId),
      position: LatLng(lat, lng),
      onTap: () {
        // Access context and call _showSlideUpModal
        _showSlideUpModal(context,mid);
      },
      infoWindow: InfoWindow(
        title: title,
      ),
    );
  }

  // Parking Lot Details Slide
  void _showSlideUpModal(BuildContext context,String mid) {
    String parkingLotDetailsText = 'Parking Lot Details';

    if (mid == '1') {
      parkingLotDetailsText = 'Keshav Memorial Engineering College';

    } else if (mid == '2') {
      parkingLotDetailsText = 'Neil Gogte Institute of Technology';

    } else if (mid == '3') {
      parkingLotDetailsText = 'Anjanadri Gated Community';

    } else if (mid == '4') {
      parkingLotDetailsText = 'GSR Constructions';

    } else if (mid == '5') {
      parkingLotDetailsText = 'SPANZ VILLA';

    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 370.0,
          height: 350.0,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                parkingLotDetailsText,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Slots available: 7\n'
                    'Slots booked: 3\n'
                    'Total slots: 10',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ParkingApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(120.0, 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  late List<Marker> _list;
  MapsPageState() {
    _list = <Marker>[
      createMarker('1', 17.397051466500752, 78.62260698257549, 'Keshav Memorial Engineering College'),
      createMarker('2', 17.39587287558397, 78.62196950902965, 'Neil Gogte Institute of Technology'),
      createMarker('3', 17.391181833373288, 78.62386301538935, 'Anjanadri Gated Community'),
      createMarker('4', 17.392994279278522, 78.61877946152602, 'GSR Constructions'),
      createMarker('5', 17.390044558956642, 78.6189778310192, 'SPANZ VILLA'),
    ];
  }

  loadLocation() {
    getUserCurrentLocation().then((value) async {
      if (kDebugMode) {
        print("My current location");
      }
      if (kDebugMode) {
        print("${value.latitude} ${value.longitude}");
      }
      marker.add(
        Marker(
          markerId: const MarkerId("0"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: "My Current Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 14,
          target: LatLng(value.latitude, value.longitude));
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: 'en',
      strictbounds: false,
      types: [],
      components: [Component(Component.country, "IND")],
    );
    if (p != null) {
      displayPrediction(p, homeScaffoldKey.currentState as ScaffoldMessengerState?);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(homeScaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldMessengerState? messengerState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );
    setState(() {});

    // Store the context in a local variable
    final context = messengerState!.context;

    // Use the local context variable
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(detail.result.name)));
  }


  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      if (kDebugMode) {
        print("error$error");
      }
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    marker.addAll(_list);
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Use HomePage()
            );
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          ElevatedButton(
            onPressed: _handlePressButton,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200.0, 10.0),
              padding: const EdgeInsets.all(16.0),
            ),
            child: const Text("Search Parking Lots"),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(marker).union(markersList),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          googleMapController = controller;
        },
      ),
    );
  }
}
