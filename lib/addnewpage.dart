// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_interview_gosend/db_handler.dart';
import 'package:test_interview_gosend/orders.dart';
import 'package:test_interview_gosend/splash.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({super.key, required this.changedorder});
  final Map changedorder;
  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Photo'),
        actions: [
          IconButton(
            onPressed: () {
              // databaseFactory.deleteDatabase('gosend_clone.db');
              String tempimage = base64Encode(_image!.readAsBytesSync());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCoordinatePage(
                      Imagebase64: tempimage,
                      changedorder: widget.changedorder),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: 0.8.sh,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(children: [
                  Center(
                    // this button is used to open the image picker
                    child: ElevatedButton(
                      onPressed: _openImagePicker,
                      child: const Text('Select An Image'),
                    ),
                  ),
                  const SizedBox(height: 35),
                  // The picked image will be displayed here
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : const Text('Please select an image'),
                  ),
                  const Center()
                ]),
              ),
            )),
      ),
    );
  }
}

class AddCoordinatePage extends StatefulWidget {
  const AddCoordinatePage(
      {super.key, required this.Imagebase64, required this.changedorder});
  final String Imagebase64;
  final Map changedorder;
  @override
  State<AddCoordinatePage> createState() => _AddCoordinatePageState();
}

class _AddCoordinatePageState extends State<AddCoordinatePage> {
  TextEditingController lat1Controller = TextEditingController();
  TextEditingController lat2Controller = TextEditingController();
  TextEditingController lang1Controller = TextEditingController();
  TextEditingController lang2Controller = TextEditingController();
  late final MapController mapController = MapController();
  LatLng latLng = const LatLng(-7.24917, 112.75083);
  bool Cord1Checker = false;
  bool Cord2Checker = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DatabaseHandler dbHandler = DatabaseHandler();
  Map userlogedin = {};
  List<Map> listorder = List<Map>.empty(growable: true);
  List<Map> listorderdone = List<Map>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    // updatePoint(null);
    init();
  }

  void init() async {
    final SharedPreferences prefs = await _prefs;
    int iduser = await prefs.getInt('iduser')!;
    dbHandler.getLoginById(iduser).then((value) => userlogedin = value.toMap());
  }

  void updatePoint(MapEvent? event) {
    final pointX = 0.45.sw;
    const pointY = 180.0;
    CustomPoint<num> poin = CustomPoint(pointX, pointY);
    setState(() {
      latLng = mapController.pointToLatLng(poin);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Distance distance = Distance();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coordinate'),
        actions: [
          IconButton(
            onPressed: () {
              if (Cord1Checker == false || Cord2Checker == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please get both coordinate first'),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi Penyimpanan?'),
                      content: const Text(
                          'Apakah anda yakin untuk menyimpan foto dan koordinat? Aksi ini tidak dapat di ulangi!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Tidak'),
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          child: const Text('Ya'),
                          onPressed: () {
                            Orders orderbaru = Orders(
                                id: widget.changedorder['id'],
                                name: widget.changedorder['nama'],
                                idUser: widget.changedorder['iduser'],
                                isnew: 0,
                                dateEpoch:
                                    DateTime.now().millisecondsSinceEpoch,
                                pictureOrder: base64Decode(widget.Imagebase64),
                                langitude1: double.parse(lang1Controller.text),
                                latitude1: double.parse(lat1Controller.text),
                                langitude2: double.parse(lang2Controller.text),
                                latitude2: double.parse(lat2Controller.text));

                            dbHandler.updateOrderUsingHelper(orderbaru);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Splashpage(),
                                ));
                          },
                        )
                      ]),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 0.825.sh,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 0.9.sw,
                    height: 0.4.sh,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        onMapEvent: (event) {
                          updatePoint(null);
                        },
                        center: const LatLng(-7.24917, 112.75083),
                        interactiveFlags:
                            InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                        zoom: 12,
                        minZoom: 9,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          //moveable marker
                          markers: [
                            if (Cord1Checker == true)
                              Marker(
                                height: 40.0,
                                width: 40.0,
                                point: LatLng(double.parse(lat1Controller.text),
                                    double.parse(lang1Controller.text)),
                                builder: (context) => const Icon(
                                    Icons.person_pin_circle,
                                    size: 40,
                                    color: Colors.blue),
                              ),
                            if (Cord2Checker == true)
                              Marker(
                                height: 40.0,
                                width: 40.0,
                                point: LatLng(double.parse(lat2Controller.text),
                                    double.parse(lang2Controller.text)),
                                builder: (context) => const Icon(
                                    Icons.person_pin_circle,
                                    size: 40,
                                    color: Colors.orange),
                              ),
                            Marker(
                              height: 40.0,
                              width: 40.0,
                              point: latLng,
                              builder: (context) =>
                                  const Icon(Icons.person_pin_circle, size: 40),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 0.4.sw,
                          child: TextField(
                            enabled: false,
                            controller: lat1Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Latitude 1',
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 0.4.sw,
                          child: TextField(
                            enabled: false,
                            controller: lang1Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Langitude 1',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 35.h,
                    width: 0.6.sw,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            lat1Controller.text = latLng.latitude.toString();
                            lang1Controller.text = latLng.longitude.toString();
                            Cord1Checker = true;
                          });
                        },
                        child: const Text("Get Coordinate 1")),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 0.4.sw,
                          child: TextField(
                            enabled: false,
                            controller: lat2Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Latitude 2',
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 0.4.sw,
                          child: TextField(
                            enabled: false,
                            controller: lang2Controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Langitude 2',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 35.h,
                    width: 0.6.sw,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            lat2Controller.text = latLng.latitude.toString();
                            lang2Controller.text = latLng.longitude.toString();
                            Cord2Checker = true;
                          });
                        },
                        child: const Text("Get Coordinate 2")),
                  ),
                  SizedBox(
                    height: 15.h,
                    width: 1.sw,
                  ),
                  if (Cord1Checker == true && Cord2Checker == true)
                    Center(
                      child: Text(
                          'Jarak Antara kedua koordinat: ${double.parse(((distance.as(LengthUnit.Meter, LatLng(double.parse(lat1Controller.text), double.parse(lang1Controller.text)), LatLng(double.parse(lat2Controller.text), double.parse(lang2Controller.text)))) / 1000).toStringAsFixed(2))} KM'),
                    )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
