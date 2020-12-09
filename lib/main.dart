import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_manager.dart';
import 'hlnews.dart';
import 'news.dart';
import 'non_ui.dart';
import 'util.dart';
import 'test_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => user, child: MaterialApp(home: PkuReader())));
}

class PkuReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PKU Reader')),
      body: ListView(
        children: [
          newPageListItem(context, 'Test', Test()),
          newPageListItem(
              context,
              '帐户管理',
              AccountManager(
                user: user,
              )),
          newPageListItem(context, '新闻浏览', BrowseNews()),
          newPageListItem(
              context,
              '新闻阅读',
              ReadNews(
                title: '阔别900余天，图书馆东楼今日重启',
              )),
          newPageListItem(context, '有知识的新闻阅读', HLNews())
        ],
      ),
    );
  }
}