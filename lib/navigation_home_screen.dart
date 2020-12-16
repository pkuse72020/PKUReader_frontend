import 'package:pkureader_frontend/news/news.dart';

import 'app_theme.dart';
import 'home_screen.dart';
import 'package:pkureader_frontend/drawer/drawer_user_controller.dart';
import 'package:pkureader_frontend/drawer/home_drawer.dart';
import 'package:pkureader_frontend/drawer/feedback_screen.dart';
import 'package:pkureader_frontend/drawer/help_screen.dart';
import 'package:flutter/material.dart';

import 'account/account_manager.dart';
import 'account/login.dart';
import 'non_ui.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    // screenView = const MyHomePage();
    screenView=new BrowseNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
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
    DrawerIndex oldIndex = drawerIndex;
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          // screenView = const MyHomePage();
          screenView= new BrowseNews();
        });
      } else if (drawerIndex == DrawerIndex.AccountManager) {
        if (user == null) {
          drawerIndex = oldIndex;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          setState(() {
            screenView = AccountManager();
          });
        }
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else {
        //do in your way......
      }
    }
  }
}
