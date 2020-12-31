import 'package:flutter/material.dart';
import 'package:zhizhang/pages/login.dart';
import 'utils/routes.dart';
import 'package:flutter_driver/driver_extension.dart';

main() async {
  await enableFlutterDriverExtension();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: LoginPage(), //软件初始页面
      onGenerateRoute: onGenerateRoute,
    );
  }
}
