// @dart=2.9

import 'package:admin_toutn/core/controller/api_controller.dart';
import 'package:admin_toutn/core/controller/claims_controller.dart';
import 'package:admin_toutn/screens/about_us_form.dart';
import 'package:admin_toutn/screens/add_monuments_screen.dart';
import 'package:admin_toutn/screens/auth_page.dart';
import 'package:admin_toutn/screens/claims_list.dart';
import 'package:admin_toutn/screens/dashboard.dart';
import 'package:admin_toutn/screens/event_form.dart';
import 'package:admin_toutn/screens/drawer_home.dart';
import 'package:admin_toutn/screens/imma_list_screen.dart';
import 'package:admin_toutn/screens/notif_screen.dart';
import 'package:admin_toutn/screens/places_listing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:admin_toutn/screens/drawer_controller.dart';
import 'package:admin_toutn/screens/drawer_home.dart';
import 'package:get_storage/get_storage.dart';
import 'app_theme.dart';
import 'core/controller/about_us_controller.dart';
import 'core/controller/edit_immat_controller.dart';
import 'core/controller/form_controller.dart';
import 'core/controller/notif_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyB0kHM_DDjqj6SxL5oVJueThdbNkAjFPe8",
          authDomain: "tourtn-8566f.firebaseapp.com",
          projectId: "tourtn-8566f",
          storageBucket: "tourtn-8566f.appspot.com",
          messagingSenderId: "517046918690",
          appId: "1:517046918690:web:b97eeda88873380881f47b",
          measurementId: "G-K6XBS0V5Q8"));

  Get.put(FormController());
  Get.put(ClaimsController());
  Get.put(PlacesController());
  Get.put(NotificationsController());
  Get.put(AboutUsController());
  Get.put(ImmatController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin tour de Tunisie',
      getPages: [
        GetPage(name: '/', page: () => AuthPage()
            //DashboardScreen(),
            )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.Help;
    screenView = Claims();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.25,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.place) {
        setState(() {
          screenView = PlacesList();
        });
      } else if (drawerIndex == DrawerIndex.event) {
        setState(() {
          screenView = DashboardScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = Claims();
        });
        //do in your way......
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = NotificationScreen();
        });
        //do in your way......
      }
      else if (drawerIndex == DrawerIndex.Share) {
        setState(() {
          screenView = ImmaList();
        });
        //do in your way......
      }
      else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = AboutFormScreen();
        });
        //do in your way......
      }
    }
  }
}
