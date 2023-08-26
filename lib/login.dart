import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_interview_gosend/db_handler.dart';
import 'package:test_interview_gosend/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DatabaseHandler dbHandler = DatabaseHandler();
  String valsU = "Isi User:";
  String valsO = "Isi Order:";
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  late final TextEditingController usernameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    Database db = await dbHandler.initializedDB();
//build test code

    List<Map<String, dynamic>> resultU = await db.query('users');
    for (var element in resultU) {
      setState(() {
        valsU += element.toString();
      });
    }

    List<Map<String, dynamic>> resultO = await db.query('orders');
    for (var element2 in resultO) {
      setState(() {
        valsO += element2.toString();
      });
    }

    //end build code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    controller: usernameController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter your Username',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text("Remember me"),
                    contentPadding: EdgeInsets.zero,
                    value: rememberValue,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (newValue) {
                      setState(() {
                        rememberValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String vals = "";
                        dbHandler.getAllUsers().then((value) {
                          for (var element in value) {
                            vals += element.toMap().toString();
                          }
                        });

                        FocusManager.instance.primaryFocus?.unfocus();

                        dbHandler
                            .getLogin(usernameController.text,
                                passwordController.text)
                            .then((value) {
                          // print("object login id: ${value?.id}");

                          if (value != null) {
                            _prefs.then((value) =>
                                value.setBool('loginstatus', rememberValue));
                            _prefs.then(
                                (values) => values.setInt('iduser', value.id!));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                          iduser: value.id!,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('login not found, use $vals'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*Container(
                    padding: const EdgeInsets.all(10),
                    child: Text((valsU)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text((valsO)),
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
