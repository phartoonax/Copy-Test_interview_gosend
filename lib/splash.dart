// ignore_for_file: unused_element

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:test_interview_gosend/db_handler.dart';
import 'package:test_interview_gosend/main.dart';
import 'package:test_interview_gosend/orders.dart';
import 'package:test_interview_gosend/user.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  DatabaseHandler dbHandler = DatabaseHandler();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? wtf;
  late final Future<int?> _userid = _prefs.then((SharedPreferences prefs) {
    return prefs.getInt('iduser');
  });
  late final Future<bool> _logstatus = _prefs.then((SharedPreferences prefs) {
    return prefs.getBool('loginstatus') ?? false;
  });

  @override
  void initState() {
    super.initState();
    init();
    _userid.then((value) => wtf = value);
  }

  void init() async {
    await dbHandler.initializedDB().then((db) async {
      await db.query('orders').then((value) {
        if (value.isEmpty == true) {
          // databaseFactory.deleteDatabase(db.path);
          // dbHandler.initializedDB().then((db2) {});
          setState(() {});
        }
      });
    });
  }

  Future<bool> isidb() async {
    Database dbs = await DatabaseHandler().database;
    List<Map<String, dynamic>> result = await dbs.query('users');
    List<Map<String, dynamic>> result2 = await dbs.query('orders');
    bool check1;
    bool check2;
    User userutama = User(name: 'DRIVER 1', password: '1234');
    Orders dummyOrder = Orders(
        name: 'tes',
        idUser: 1,
        isnew: 1,
        dateEpoch: (DateTime.now().subtract(const Duration(days: 2)))
            .millisecondsSinceEpoch);
    Orders dummyOrder2 = Orders(
        name: 'tes 2',
        idUser: 1,
        isnew: 1,
        dateEpoch: DateTime.now().millisecondsSinceEpoch);
    if (result.isEmpty) {
      await dbHandler
          .insertUser(userutama);

      check1 = true;
    } else {
      check1 = false;
    }
    if (result2.isEmpty) {
      await dbHandler
          .insertOrder(dummyOrder);
      await dbHandler
          .insertOrder(dummyOrder2);
      check2 = true;
    } else {
      check2 = false;
    }
    if (check1 == true || check2 == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: Future.wait([_logstatus, _userid, isidb()]),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator(
                      color: Colors.red,
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data?[0] == true
                          ? MyHomePage(
                              iduser: snapshot.data?[1],
                            )
                          : const LoginPage();
                    }
                }
              })),
    );
  }
}
