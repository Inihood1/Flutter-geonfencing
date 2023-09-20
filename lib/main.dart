
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:geofence_service/geofence_service.dart';
import 'package:get_it/get_it.dart';

var staffs = FirebaseFirestore.instance.collection('staffs');
var users = FirebaseFirestore.instance.collection('users');
var wifi = FirebaseFirestore.instance.collection('wifi');
var attendance = FirebaseFirestore.instance.collection('attendance');
var dailyReport = FirebaseFirestore.instance.collection('dailyReport');
var update = FirebaseFirestore.instance.collection('appSettings');
var testLoc = FirebaseFirestore.instance.collection('testLoc');


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int version = 0;
  bool forUpdate = false;

  @override
  void initState() {
    checkAppUpdate();
    super.initState();
  }

  Future<void> checkAppUpdate() async{
    await update.doc("app").get().then((value) {
      if(mounted){
        setState(() {
          version = value.get("version");
          forUpdate = value.get("forceUpdate");
        });
      }
    });
   // print("the version: $version");
    //print("force update: $forUpdate");
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      //title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: auth.currentUser != null ?  MyHomePage(forUpdate, version) : StartPage(version, forUpdate),
      initialRoute: '/start',
      //home: auth.currentUser != null ?  MyHomePage() : Login(),
      routes: {
        '/login': (BuildContext context) =>  Login(version, forUpdate),
        '/start': (BuildContext context) =>   StartPage(version, forUpdate),
        '/reg': (BuildContext context) =>  Register(version, forUpdate),
        '/home': (BuildContext context) =>  MyHomePage(forUpdate, version),
      },
    );
  }
}

