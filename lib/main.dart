import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// import 'account_manager.dart';
// import 'hlnews.dart';
// import 'news.dart';
// import 'util.dart';
// import 'test_page.dart';
import 'non_ui.dart';
import 'app_theme.dart';
import 'navigation_home_screen.dart';

Future<void> main() async {
  await Account.restore();
  runApp(ChangeNotifierProvider(
      create: (context) => user, child: MaterialApp(home: PkuReader())));
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
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        // platform: TargetPlatform.iOS,
      ),
      home: NavigationHomeScreen(),
    );
    // return Scaffold(
    //   appBar: AppBar(title: Text('PKU Reader')),
    //   body: ListView(
    //     children: [
    //       newPageListItem(context, 'Test', Test()),
    //       newPageListItem(
    //           context,
    //           '帐户管理',
    //           AccountManager(
    //             user: user,
    //           )),
    //       newPageListItem(context, '新闻浏览', BrowseNews()),
    //       newPageListItem(
    //           context,
    //           '新闻阅读',
    //           ReadNews(
    //             title: '阔别900余天，图书馆东楼今日重启',
    //           )),
    //       newPageListItem(context, '有知识的新闻阅读', HLNews())
    //     ],
    //   ),
    // );
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
