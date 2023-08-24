// ignore_for_file: unused_element

import 'dart:async';
import 'package:test_interview_gosend/main.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? wtf;
  late final Future<int> _userid = _prefs.then((SharedPreferences prefs) {
    return prefs.getInt('iduser') ?? 0;
  });
  late final Future<bool> _logstatus = _prefs.then((SharedPreferences prefs) {
    return prefs.getBool('loginstatus') ?? false;
  });

  @override
  void initState() {
    super.initState();
    _userid.then((value) => wtf = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: const Text('SharedPreferences Demo'),
      //     ),
      body: Center(
          child: FutureBuilder<bool>(
              future: _logstatus,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // TODO : change to else if to check login, and add options to go to login and main menu
                      return snapshot.data == true
                          ? MyHomePage(
                              iduser: wtf!,
                            ) /* CHANGE TO MAIN MENU WITH PROPERTY */
                          : const LoginPage();
                    }
                }
              })),
    );
  }
}
