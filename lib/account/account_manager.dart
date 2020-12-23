import 'package:flutter/material.dart';
import 'package:pkureader_frontend/app_theme.dart';

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
  final double height;
  final Widget button;

  CustomScaffold(
      {@required this.name,
      @required this.body,
      this.nextPageIcon,
      this.nextPage,
      this.middle = const SizedBox(),
      this.height = double.infinity,
      this.button});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Navigator.of(context).canPop() ? null : Color(0),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            // color: Colors.white,
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
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(40.0)),
                boxShadow: [
                  BoxShadow(color: Color(0x3f000000), blurRadius: 20.0)
                ],
              ),
              child: Material(
                color: AppTheme.nearlyWhite,
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(40.0),
                    topEnd: Radius.circular(40.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: body,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: button,
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 60.0,
            ),
            Container(
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    blurRadius: 8.0,
                    color: AppTheme.grey.withOpacity(0.4),
                    offset: Offset(4.0, 8.0))
              ]),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(90.0)),
                  child: Image.asset(
                    'assets/images/userImage.png',
                  )),
            ),
            SizedBox(
              height: 36.0,
            ),
            Text(user.userName,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text(
              'ID: ${user.userId}',
              style:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff677CD5),
      // backgroundColor: Colors.grey,
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
      body: RefreshIndicator(
        child: ListView(
            children: widget.type == SubscrType.rss
                ? user.subscrRssSrcs
                    .map((e) => ListTile(
                          title: Text(e.name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await user.removeSource(e);
                              setState(() {});
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
                            onPressed: () async {
                              await user.removeArticle(e);
                              setState(() {});
                            },
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ReadNews(
                                        article: e,
                                        callback: () {
                                          setState(() {});
                                        },
                                      ))),
                        ))
                    .toList()),
        onRefresh: () async {
          try {
            if (widget.type == SubscrType.rss)
              await user.getSubscrSrcs();
            else
              await user.getFavArticles();
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('异常'),
                content: Text(e.toString()),
              ),
            );
          }
          setState(() {});
        },
      ),
      nextPageIcon: widget.type == SubscrType.rss ? Icons.add : null,
      nextPage: widget.type == SubscrType.rss
          ? NewSubscrPage(SubscrType.rss, () {
              setState(() {});
            })
          : null,
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

  // TODO Consider using separate classes for subsciptions and favorite
  // articles.
  Future<Iterable<Source>> srcList = Source.getAllSources();

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
              InputDecoration(hintText: '搜索', icon: const Icon(Icons.search),
              suffixIcon: controller.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear),
              onPressed: () => controller.clear(),)),

        ),
      ),
      body: widget.type == SubscrType.rss
          ? FutureBuilder(
              future: srcList,
              builder: (context, AsyncSnapshot<Iterable<Source>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    return Center(child: Text(snapshot.error.toString()));
                  return ListView(
                      children: snapshot.data
                          .where((element) => !user.hasSource(element))
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(controller.text.toLowerCase()))
                          .map((e) => ListTile(
                                title: Text(e.name),
                                subtitle: Text(e.url),
                                onTap: () async {
                                  try {
                                    await user.addSource(e);
                                  } catch (e) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text('异常'),
                                              content: Text(e.toString()),
                                            ));
                                  }
                                  setState(() {});
                                  widget.callback();
                                },
                              ))
                          .toList());
                } else {
                  return Stack(
                    alignment: Alignment.center,
                    children: [SizedBox.expand(), CircularProgressIndicator()],
                  );
                }
              })
          : ListView(
              children: user.newsCache
                  .where((element) => !user.favArticles.contains(element))
                  .where((element) => element.title.contains(controller.text))
                  .map((e) => ListTile(
                        title: Text(e.title),
                        onTap: () async {
                          try {
                            await user.addArticle(e);
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('异常'),
                                      content: Text(e.toString()),
                                    ));
                          }
                          setState(() {});
                          widget.callback();
                        },
                      ))
                  .toList()),
    );
  }
}

/// The page for the user to submit an RSS source.
class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  String sourceName;
  String url;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        name: '发布',
        height: 240.0,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
              child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: 'RSS 源名称',
                            suffixIcon: _nameController.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _nameController.clear();
                                      });
                                    })),
                        validator: (value) {
                          if (value.isEmpty) return '源名称不能为空';
                          return null;
                        },
                        onSaved: (newValue) => sourceName = newValue,
                        onChanged: (str) {
                          setState(() {});
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _urlController,
                          decoration: InputDecoration(
                              labelText: 'RSS URL',
                              suffixIcon: _urlController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _urlController.clear();
                                        });
                                      })),
                          validator: (value) {
                            if (value.isEmpty) return 'RSS URL 不能为空';
                            return null;
                          },
                          onSaved: (newValue) => url = newValue,
                          onChanged: (str) {
                            setState(() {});
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();

                              try {
                                await user.submit(sourceName, url);
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('异常'),
                                          content: Text(e.toString()),
                                        ));
                              }

                              _key.currentState.reset();
                              _nameController.clear();
                              _urlController.clear();
                            }
                          },
                          child: Text('提交'))
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ))),
        ));
  }
}
