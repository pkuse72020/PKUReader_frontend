import 'package:flutter/material.dart';
import 'package:pkureader_frontend/app_theme.dart';
import 'package:provider/provider.dart';

import '../local.dart';
import '../news/news.dart';
import '../non_ui.dart';

enum SubscrType { rss, article }

/// A customized scaffold.
///
/// It is used in order to be consistent with other UI designs in the app.
class CustomScaffold extends StatelessWidget {
  final String name;
  final Widget body;
  final IconData nextPageIcon;
  final Widget nextPage;
  final Widget middle;

  final double top;
  final double down;

  CustomScaffold(
      {@required this.name,
      @required this.body,
      this.nextPageIcon,
      this.nextPage,
      this.middle = const SizedBox(),
      this.top = 0.0,
      this.down = 0.0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500),
                      ),
                      // An arbitrary transparent [IconButton] as a placeholder if
                      // [nextPage] is [null].
                      nextPage == null
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0),
                              ),
                              onPressed: null)
                          : IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        nextPage));
                              },
                              icon: Icon(nextPageIcon)),
                    ],
                  ),
                  middle,
                ],
              ),
            ),
          ),
          SizedBox(height: top),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(40.0)),
                  boxShadow: [
                    BoxShadow(color: Color(0x2f000000), blurRadius: 6.0)
                  ],
                ),
                child: Material(
                  color: AppTheme.nearlyWhite,
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(40.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: body,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: down),
        ],
      ),
    );
  }
}

/// An account management page.
///
/// It is used to manage subscribed sources and favorite articles. It also
/// allows the user to submit an RSS source.
class AccountManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (user == null)
      return Scaffold(
        appBar: AppBar(
          title: Text('错误'),
        ),
        body: Center(
            child: Text('出现这个页面说明 PKU Reader 出现了错误，可访问 '
                'https://github.com/pkuse72020/pkureader_frontend/issues'
                ' 向 PKU Reader 的开发者提交错误报告。')),
      );
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: 180.0,
                    height: 180.0,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                          blurRadius: 8.0,
                          color: AppTheme.grey.withOpacity(0.4),
                          offset: Offset(4.0, 8.0))
                    ]),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(90.0)),
                        child: Image.asset(
                          'assets/images/userImage.png',
                        )),
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                  Text(user.userName,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.w300)),
                  Text(
                    'ID: ${user.userId}',
                    style: TextStyle(fontWeight: FontWeight.w100),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 12.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x2f000000), blurRadius: 6.0)
                      ],
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(40.0)),
                    ),
                    child: Material(
                      color: AppTheme.nearlyWhite,
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(40.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.source),
                              title: Text('已订阅 RSS 源'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SubscrManager(SubscrType.rss)));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.star),
                              title: Text('已收藏文章'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SubscrManager(SubscrType.article)));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.add_link),
                              title: Text('发布'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SubmitPage()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.notWhite,
        ),
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
class SubscrManager extends StatefulWidget {
  /// The subscription type.
  ///
  /// If the instance handles RSS source subscriptions, it has the value
  /// [SubscrType.rss]. Otherwise, it handles favorite articles, and has the
  /// value [SubscrType.article].
  final type;

  SubscrManager(this.type);

  @override
  _SubscrManagerState createState() => _SubscrManagerState();
}

class _SubscrManagerState extends State<SubscrManager> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      name: widget.type == SubscrType.rss ? '已订阅 RSS 源' : '已收藏文章',
      body: ListView(
          children: widget.type == SubscrType.rss
              ? user.subscrRssSrcs
                  .map((e) => ListTile(
                        title: Text(e.name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              user.removeSource(e);
                            });
                          },
                        ),
                      ))
                  .toList()
              : user.favArticles
                  .map((e) => ListTile(
                        contentPadding: EdgeInsets.all(12.0),
                        title: Text(e.title),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => user.removeArticle(e.title),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReadNews(title: e.title))),
                      ))
                  .toList()),
      nextPageIcon: Icons.add,
      nextPage: NewSubscrPage(widget.type, () {
        setState(() {});
      }),
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

  final Function callback;

  NewSubscrPage(this.type, this.callback);

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
    return CustomScaffold(
      name: widget.type == SubscrType.rss ? '订阅新 RSS 源' : '收藏新文章',
      middle: Container(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration:
              InputDecoration(hintText: '搜索', icon: const Icon(Icons.search)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                                setState(() {
                                  user.addSource(Source(e, ''));
                                });
                                widget.callback();
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
          )
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
    return CustomScaffold(
        name: '发布',
        top: 140.0,
        down: 140.0,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
              child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: 'RSS 源名称'),
                        validator: (value) {
                          if (value.isEmpty) return '请输入源名称';
                          return null;
                        },
                        onSaved: (newValue) => sourceName = newValue,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  ))),
        ));
  }
}
