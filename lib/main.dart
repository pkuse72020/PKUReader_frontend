import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'non_ui.dart';
import 'app_theme.dart';
import 'navigation_home_screen.dart';

Future<void> main() async {
  await Account.restore();
  runApp(PkuReader());
}

class PkuReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Flutter UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppTheme.pkuReaderPurpleMaterial,
        textTheme: AppTheme.textTheme,
      ),
      home: NavigationHomeScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
