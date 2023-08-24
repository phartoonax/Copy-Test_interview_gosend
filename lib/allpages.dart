import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_interview_gosend/addnewpage.dart';
import 'package:test_interview_gosend/db_handler.dart';
import 'package:test_interview_gosend/splash.dart';
import 'package:test_interview_gosend/user.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage(
      {super.key, required this.userdata, required this.listorders});

  final Map userdata;
  final List<Map> listorders;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
      height: 0.8.sh,
      child: ListView.builder(
          itemCount: widget.listorders.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  'Order #${widget.listorders[index]['id']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                subtitle: Text(
                  'Nama Order : ${widget.listorders[index]['nama']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPhotoPage(changedorder: widget.listorders[index]),
                    ),
                  );
                },
              ),
            );
          }),
    ));
  }
}

class DoneOrderPage extends StatefulWidget {
  const DoneOrderPage(
      {super.key, required this.userdata, required this.listordersdone});

  final Map userdata;
  final List<Map> listordersdone;
  @override
  State<DoneOrderPage> createState() => _DoneOrderPageState();
}

class _DoneOrderPageState extends State<DoneOrderPage> {
  @override
  Widget build(BuildContext context) {
    const Distance distance = Distance();
    late final MapController mapController = MapController();

    return SingleChildScrollView(
        child: SizedBox(
      height: 0.8.sh,
      child: ListView.builder(
          itemCount: widget.listordersdone.length,
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                title: Text(
                  'Order #${widget.listordersdone[index]['id']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                subtitle: Text(
                    'Nama Order Selesai: ${widget.listordersdone[index]['nama']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
                children: [
                  const Divider(
                    endIndent: 5,
                    indent: 5,
                    color: Color.fromARGB(255, 99, 120, 136),
                  ),
                  Card(
                    child: SizedBox(
                      width: 1.sw,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: const Text(
                              'Foto: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 0.9.sw,
                            height: 0.4.sh,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 300,
                              color: Colors.grey[300],
                              child: Image.memory(
                                  widget.listordersdone[index]['picorder'],
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text(
                                textAlign: TextAlign.left,
                                "Kordinat 1: \n [${widget.listordersdone[index]['lat1']}, ${widget.listordersdone[index]['lang1']}]",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Text(
                                textAlign: TextAlign.left,
                                "Kordinat 2: \n [${widget.listordersdone[index]['lat2']}, ${widget.listordersdone[index]['lang2']}]",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17)),
                          ),
                          SizedBox(
                            width: 0.9.sw,
                            height: 0.4.sh,
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                bounds: LatLngBounds(
                                  LatLng(widget.listordersdone[index]['lat1'],
                                      widget.listordersdone[index]['lang1']),
                                  LatLng(widget.listordersdone[index]['lat2'],
                                      widget.listordersdone[index]['lang2']),
                                ),
                                boundsOptions: const FitBoundsOptions(
                                    padding: EdgeInsets.all(10)),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(
                                          widget.listordersdone[index]['lat1'],
                                          widget.listordersdone[index]
                                              ['lang1']),
                                      builder: (ctx) => Container(
                                        child: const Icon(Icons.looks_one,
                                            size: 40, color: Colors.blue),
                                      ),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: LatLng(
                                          widget.listordersdone[index]['lat2'],
                                          widget.listordersdone[index]
                                              ['lang2']),
                                      builder: (ctx) => Container(
                                        child: const Icon(Icons.looks_two,
                                            size: 40, color: Colors.orange),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                            width: 1.sw,
                          ),
                          Center(
                            child: Text(
                                'Jarak Antara kedua koordinat: ${double.parse(((distance.as(LengthUnit.Meter, LatLng(widget.listordersdone[index]['lat1'], widget.listordersdone[index]['lang1']), LatLng(widget.listordersdone[index]['lat2'], widget.listordersdone[index]['lang2']))) / 1000).toStringAsFixed(2))} KM',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    ));
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userdata});

  final Map userdata;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool('loginstatus', false);
      prefs.remove('iduser');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Splashpage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        editProfile(userdata: widget.userdata)))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.manage_accounts,
                        size: 35,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: 133.w,
                      height: 120.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 90.0,
                        child: CircleAvatar(
                          radius: 70.0,
                          foregroundImage: widget.userdata['pic'] != null
                              ? Image.memory(
                                  widget.userdata['pic'],
                                  fit: BoxFit.cover,
                                ).image
                              : null,
                          child: Icon(
                            Icons.person,
                            size: 70.spMin,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Nama',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.userdata['nama'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'NIK',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.userdata['nik'] != null
                        ? widget.userdata['nik'].toString()
                        : 'Belum ada NIK',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          backgroundColor: Colors.red),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class editProfile extends StatefulWidget {
  const editProfile({super.key, required this.userdata});
  final Map userdata;
  @override
  State<editProfile> createState() => _editProfileState();
}

final _formKey = GlobalKey<FormState>();
String? onerror;
TextEditingController editnama = TextEditingController();
TextEditingController nik = TextEditingController();
TextEditingController passwordController = TextEditingController();
DatabaseHandler dbHandler = DatabaseHandler();

class _editProfileState extends State<editProfile> {
  File? _imagetaken;
  Uint8List? picture;
  // This is the image picker
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imagetaken = File(photo.path);
        picture = _imagetaken?.readAsBytesSync();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // databaseFactory.deleteDatabase('gosend_clone.db');
    editnama.text = widget.userdata["nama"];
    passwordController.text = widget.userdata["pass"];
    nik.text =
        widget.userdata["nik"] != null ? widget.userdata["nik"].toString() : "";
    if (widget.userdata["pic"] != null) {
      picture = widget.userdata["pic"];
    }
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: 0.8.sh,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 45.h,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 1),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Form(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: 133.w,
                        height: 120.h,
                        child: InkWell(
                          onTap: () {
                            _openImagePicker();
                          },
                          borderRadius: BorderRadius.circular(100.r),
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            minRadius: 90.0,
                            child: CircleAvatar(
                              radius: 70.0,
                              foregroundImage: picture != null
                                  ? Image.memory(
                                      picture!,
                                      fit: BoxFit.cover,
                                    ).image
                                  : null,
                              child: Icon(
                                Icons.person,
                                size: 70.spMin,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: const Text(
                                  "Nama",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )),
                            TextFormField(
                              controller: editnama,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText:
                                    'Masukan Nama Pengguna yang dinginkan',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: const Text(
                                  "NIK",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )),
                            TextFormField(
                              controller: nik,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Masukan NIK Anda',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: const Text("Password",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600))),
                            PasswordInput(
                                hintText: "Masukan password anda",
                                textEditingController: passwordController,
                                onerror: onerror),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (_formKey.currentState!.validate()) {
                            User updateuser = User(
                                id: widget.userdata['id'],
                                name: editnama.text,
                                password: passwordController.text,
                                nik:
                                    nik.text != '' ? int.parse(nik.text) : null,
                                picture: picture);
                            dbHandler
                                .updateUserUsingHelper(updateuser)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Splashpage(),
                                    )));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        ),
                        child: const Text(
                          'Simpan Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class PasswordInput extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final String? onerror;

  const PasswordInput(
      {required this.textEditingController,
      required this.hintText,
      Key? key,
      this.onerror})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool pwdVisibility = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: !pwdVisibility,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        hintText: widget.hintText,
        errorText: widget.onerror,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: InkWell(
          onTap: () => setState(
            () => pwdVisibility = !pwdVisibility,
          ),
          child: Icon(
            pwdVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey.shade400,
            size: 18,
          ),
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'password tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
