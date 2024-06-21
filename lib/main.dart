import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/service/notification_service.dart';
import 'package:todo_app/ui/home_page_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await LocalNotification.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Initialize services
  // Get.put(AuthService());
  // Get.put(StorageHalper());
  //
  // // Check login status
  // final StorageHalper storageHalper = Get.find();
  // bool isLoggedIn = await storageHalper.getLoginStatus();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Task Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomePageScreen(),
    );
  }
}
