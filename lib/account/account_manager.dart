import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkureader_frontend/app_theme.dart';

import '../news/news.dart';
import '../non_ui.dart';
import '../util.dart';

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
  final bool isPushed;

  CustomScaffold(
      {@required this.name,
      @required this.body,
      @required this.isPushed,
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
                        color: isPushed ? null : Color(0),
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
                              icon: const Icon(
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
      isPushed: false,
      name: widget.type == SubscrType.rss ? '我的订阅' : '我的收藏',
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
                builder: (context) =>
                    PkuReaderAlert(title: '获取失败', e: e, context: context));
          }
          setState(() {});
        },
      ),
      nextPageIcon: widget.type == SubscrType.rss ? Icons.add : null,
      nextPage: widget.type == SubscrType.rss
          ? NewSubscrPage(() {
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
  final Function callback;

  NewSubscrPage(this.callback);

  @override
  _NewSubscrPageState createState() => _NewSubscrPageState();
}

class _NewSubscrPageState extends State<NewSubscrPage> {
  final controller = TextEditingController();

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
        isPushed: true,
        name: '订阅新 RSS 源',
        middle: Container(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: '搜索',
                icon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        splashRadius: 0.001,
                        icon: const Icon(CupertinoIcons.xmark_circle_fill,
                            color: Colors.grey),
                        onPressed: () => controller.clear(),
                      )),
          ),
        ),
        body: FutureBuilder(
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
                                      builder: (context) => PkuReaderAlert(
                                          title: 'RSS 源获取失败',
                                          e: e,
                                          context: context));
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
            }));
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
        isPushed: false,
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
                                    splashRadius: 0.001,
                                    icon: const Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        color: Colors.grey),
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
                                      splashRadius: 0.001,
                                      icon: const Icon(
                                          CupertinoIcons.xmark_circle_fill,
                                          color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _urlController.clear();
                                        });
                                      })),
                          validator: (value) {
                            if (value.isEmpty) return 'RSS URL 不能为空';
                            return null;
                          },
                          onSaved: (newValue) {
                            url = newValue;
                            print('url');
                          },
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
                                    builder: (context) => PkuReaderAlert(
                                        title: '发布失败', e: e, context: context));
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

class SubmissionManager extends StatefulWidget {
  @override
  _SubmissionManagerState createState() => _SubmissionManagerState();
}

class _SubmissionManagerState extends State<SubmissionManager> {
  Future<Iterable<Submission>> pendingList = user.getPending();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isPushed: false,
        name: '待处理申请',
        body: FutureBuilder(
            future: pendingList,
            builder: (context, AsyncSnapshot<Iterable<Submission>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError)
                  return Center(child: Text(snapshot.error.toString()));
                return RefreshIndicator(
                  child: ListView(
                      children: snapshot.data
                          .map((e) => ListTile(
                                title: Text(e.name),
                                subtitle: Text(e.url),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: AppTheme.pkuReaderPurple,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await user.approvePending(e);
                                        } catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                PkuReaderAlert(
                                                    title: '同意申请失败',
                                                    e: e,
                                                    context: context),
                                          );
                                        }
                                        setState(() {
                                          pendingList = user.getPending();
                                        });
                                      },
                                    ),
                                    SizedBox(width: 4.0),
                                    IconButton(
                                      splashRadius: 0.001,
                                      icon: const Icon(
                                          CupertinoIcons.xmark_circle_fill,
                                          color: Colors.grey),
                                      onPressed: () async {
                                        try {
                                          await user.rejectPending(e);
                                        } catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                PkuReaderAlert(
                                                    title: '拒绝申请失败',
                                                    e: e,
                                                    context: context),
                                          );
                                        }
                                        setState(() {
                                          pendingList = user.getPending();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ))
                          .toList()),
                  onRefresh: () async {
                    pendingList = user.getPending();
                    setState(() {});
                    // TODO Use a more user-friendly UI.
                  },
                );
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [SizedBox.expand(), CircularProgressIndicator()],
                );
              }
            }));
  }
}
