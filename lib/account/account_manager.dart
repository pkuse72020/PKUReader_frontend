import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../local.dart';
import '../news/news.dart';
import '../non_ui.dart';
import '../util.dart';

enum SubscrType { rss, article }

/// An account management page.
///
/// It is used to manage subscribed sources and favorite articles. It also
/// allows the user to submit an RSS source.
class AccountManager extends StatelessWidget {
  final Account user;

  AccountManager({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帐户管理'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(user == null ? '未登录\n' : user.userName + '\n' + user.userId),
          ),
          Divider(),
          newPageListItem(context, '已订阅 RSS 源', SubscrManager(SubscrType.rss)),
          newPageListItem(context, '已收藏文章', SubscrManager(SubscrType.article)),
          newPageListItem(context, '发布', SubmitPage()),
        ],
      ),
    );
  }
}

/// A subscription manager.
///
/// The user can use this to discover valid RSS sources and subscribe to them.
/// The RSS source list is now hard-coded into the app, but we have to fetch the
/// RSS source list from the server after the integration of the back-end.
///
/// Due to the similarity of subscriptions and favorite articles, we choose to
/// use the same class to handle both of them.
class SubscrManager extends StatelessWidget {
  /// The subscription type.
  ///
  /// If the instance handles RSS source subscriptions, it has the value
  /// [SubscrType.rss]. Otherwise, it handles favorite articles, and has the
  /// value [SubscrType.article].
  final type;

  SubscrManager(this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == SubscrType.rss ? '已订阅 RSS 源' : '已收藏文章'),
      ),
      body: Consumer<Account>(
        builder: (context, value, child) => ListView(
            children: type == SubscrType.rss
                ? user.subscrRssSrcs
                    .map((e) => ListTile(
                          title: Text(e.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => user.removeSource(e),
                          ),
                        ))
                    .toList()
                : user.favArticles
                    .map((e) => ListTile(
                          contentPadding: EdgeInsets.all(12.0),
                          title: Text(e.title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => user.removeArticle(e),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReadNews(title: e.title))),
                        ))
                    .toList()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewSubscrPage(type)));
          },
          child: Icon(Icons.add)),
    );
  }
}

/// A "new subscription" page.
///
/// This page is used to explore and subscribe to new pages.
class NewSubscrPage extends StatefulWidget {
  /// The subscription type.
  ///
  /// If the instance handles RSS source subscriptions, it has the value
  /// [SubscrType.rss]. Otherwise, it handles favorite articles, and has the
  /// value [SubscrType.article].
  final type;

  NewSubscrPage(this.type);

  @override
  _NewSubscrPageState createState() => _NewSubscrPageState();
}

class _NewSubscrPageState extends State<NewSubscrPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == SubscrType.rss ? '订阅新 RSS 源' : '收藏新文章'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: '搜索'),
            ),
          ),
          Expanded(
              child: Consumer<Account>(
            builder: (context, value, child) => ListView(
                children: widget.type == SubscrType.rss
                    ? rssSources
                        .where((element) => !user.subscrRssSrcs
                            .map((e) => e.name)
                            .contains(element))
                        .where((element) => element
                            .toLowerCase()
                            .contains(controller.text.toLowerCase()))
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                user.addSource(Source(e, ''));
                              },
                            ))
                        .toList()
                    : news_dict.keys
                        .where((element) => !user.favArticles
                            .map((e) => e.title)
                            .contains(element))
                        .where((element) => element.contains(controller.text))
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                user.addArticle(Article(e, news_dict[e]));
                              },
                            ))
                        .toList()),
          ))
        ],
      ),
    );
  }
}

/// The page for the user to submit an RSS source.
class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  String sourceName;
  String url;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('发布')),
        body: Center(
            child: Form(
                key: _key,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'RSS 源名称'),
                        validator: (value) {
                          if (value.isEmpty) return '请输入源名称';
                          return null;
                        },
                        onSaved: (newValue) => sourceName = newValue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'RSS URL'),
                        validator: (value) {
                          if (value.isEmpty) return '请输入 RSS URL';
                          return null;
                        },
                        onSaved: (newValue) => url = newValue,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();

                            // We have to interact with the back-end in the
                            // future, but since the back-end is not available
                            // now, we do nothing here.

                            _key.currentState.reset();
                          }
                        },
                        child: Text('提交'))
                  ],
                  mainAxisSize: MainAxisSize.min,
                ))));
  }
}
