// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_interview_gosend/login.dart';
import 'allpages.dart';
import 'user.dart';
import 'orders.dart';
import 'db_handler.dart';
import 'splash.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Orders>> orders;
  DatabaseHandler dbHandler = DatabaseHandler();

  @override
  initState() {
    super.initState();

    init();
  }

  void init() async {
    dbHandler.initializedDB().then((db) {
      //   db.query('users').then((value) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text('bocoran db. data user: ' + value.toString())));
      //     if (value.isEmpty) {
      //       databaseFactory.deleteDatabase(db.path);
      //       dbHandler.initializedDB().then((value) =>
      //           db.query('users').then((value) {
      //             String bocor = '';
      //             value.forEach((element) {
      //               bocor += element.toString();
      //             });
      //             ScaffoldMessenger.of(context).showSnackBar(
      //                 SnackBar(content: Text('bocoran db. data user: $bocor')));
      //           }));
      //     }
      //   });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GOSEND Demo',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 26, 206, 35)),
                useMaterial3: true,
                textTheme: GoogleFonts.muktaTextTheme(
                  Theme.of(context).textTheme,
                )),
            home: child,
            routes: {
              '/login': (context) => const LoginPage(),
              '/splash': (context) => const Splashpage(),
            });
      },
      child: const Splashpage(),
    );
  }
}

  class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.iduser});

  final int iduser;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHandler dbHandler = DatabaseHandler();
  int currentPageIndex = 0;
  User userlogedin = User.empty();
  Map listuser = {};
  bool finishedloading = false;
  List<Map> listorder = List<Map>.empty(growable: true);
  List<Map> listorderdone = List<Map>.empty(growable: true);
  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    userlogedin = await dbHandler.getLoginById(widget.iduser);
    listuser = userlogedin.toMap();
    await dbHandler
        .getAllOrdersByStatus(1, listuser['id'])
        .then((value) => value.forEach((element) {
              listorder.add(element.toMap());
              setState(() {});
            }));
    await dbHandler.getAllOrdersByStatus(0, listuser['id']).then((value) {
      value.forEach((element) {
        listorderdone.add(element.toMap());
        // only needed for last element
      });
      setState(() {
        finishedloading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Hello, ${userlogedin.name} !'),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: const Color.fromARGB(255, 3, 216, 67),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.notes_outlined), label: "Order Baru"),
          NavigationDestination(
              icon: Icon(Icons.format_list_numbered_rtl_rounded),
              label: "Order Selesai"),
          NavigationDestination(icon: Icon(Icons.face), label: "Profil"),
        ],
      ),
      body: finishedloading == true
          ? <Widget>[
              NewOrderPage(listorders: listorder, userdata: listuser),
              DoneOrderPage(listordersdone: listorderdone, userdata: listuser),
              ProfilePage(
                userdata: listuser,
              ),
            ][currentPageIndex]
          : const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
  }
}
