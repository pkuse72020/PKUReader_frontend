import 'package:pkureader_frontend/news/news.dart';

import 'about.dart';
import 'app_theme.dart';
import 'package:pkureader_frontend/drawer/drawer_user_controller.dart';
import 'package:pkureader_frontend/drawer/home_drawer.dart';
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
    screenView = new BrowseNews(
      callback: () {
        setState(() {});
      },
    );
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
            callback: () {
              setState(() {
                screenView = BrowseNews(
                  callback: () {
                    setState(() {});
                  },
                );
              });
            },
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
          screenView = new BrowseNews(
            callback: () {
              setState(() {});
            },
          );
        });
      } else if (drawerIndex == DrawerIndex.AccountManager) {
        if (user?.token == null) {
          drawerIndex = oldIndex;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(), fullscreenDialog: true));
        }
      } else if (drawerIndex == DrawerIndex.FavArticles) {
        setState(() {
          screenView = SubscrManager(SubscrType.article);
        });
      } else if (drawerIndex == DrawerIndex.RssSources) {
        setState(() {
          screenView = SubscrManager(SubscrType.rss);
        });
      } else if (drawerIndex == DrawerIndex.Post) {
        setState(() {
          screenView = SubmitPage();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = About();
        });
      } else if (drawerIndex == DrawerIndex.SubmissionManager) {
        setState(() {
          screenView = SubmissionManager();
        });
      }
    }
  }
}
