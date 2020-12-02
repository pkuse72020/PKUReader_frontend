import 'package:flutter/material.dart';
import 'package:pkureader_frontend/local.dart';
import 'package:provider/provider.dart';

/// This is the temporary example account
final user = Account(id: 'admin@example.com', name: '示例用户');

enum SubscrType { author, field }

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => user, child: MaterialApp(home: PkuReader())));
}

/// Creates a page-list item (a [ListTile] instance).
///
/// This is a temporary function, which should be removed when the navigator
/// design is finished.
Widget newPageListItem(BuildContext context, String name, Widget widget) {
  return ListTile(
    title: Text(name),
    onTap: widget == null
        ? null
        : () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => widget,
            ));
          },
  );
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
              ))
        ],
      ),
    );
  }
}

/// A Test page.
///
/// This is a temporary widget, which CAN be removed after finishing the first
/// module and SHOULD be removed when the navigator design is finished.
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'This is a test page.\n\n'
            'It is used to show how to add a page to the temporary page list.',
            style: TextStyle(
              fontSize: 24,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// An account data structure.
///
/// An instance of this class represents an account using this app. For now, we
/// use the main memory or the local storage to store the user data. After the
/// integration of the back-end, this should be constructed using data fetched
/// from the server.
class Account extends ChangeNotifier {
  final String id;
  final String name;
  final favFields = List<String>();
  final subscrAuthors = List<String>();

  Account({this.id, this.name});

  void addField(String field) {
    favFields.add(field);
    notifyListeners();
  }

  void removeField(String field) {
    favFields.removeWhere((element) => element == field);
    notifyListeners();
  }

  void addAuthor(String author) {
    subscrAuthors.add(author);
    notifyListeners();
  }

  void removeAuthor(String field) {
    subscrAuthors.removeWhere((element) => element == field);
    notifyListeners();
  }
}

/// An account management page.
///
/// It is used to manage subscribed authors and favorite fields. It also allows
/// the user to submit an RSS source.
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
            child: Text(user == null ? '未登录\n' : user.name + '\n' + user.id),
          ),
          Divider(),
          newPageListItem(context, '已订阅发布方', SubscrManager(SubscrType.author)),
          newPageListItem(context, '已关注领域', SubscrManager(SubscrType.field)),
          newPageListItem(context, '发布', SubmitPage()),
        ],
      ),
    );
  }
}

/// A subscription manager.
///
/// The user can use this to discover valid authors and subscribe to them. The
/// author list is now hard-coded into the app, but we have to fetch the author
/// list from the server after the integration of the back-end.
///
/// Due to the similarity of subscriptions and favorite fields, we choose to use
/// the same class to handle both of them.
class SubscrManager extends StatelessWidget {
  /// The subscription type.
  ///
  /// If the instance handles author subscriptions, it has the value
  /// [SubscrType.author]. Otherwise, it handles favorite fields, and has the
  /// value [SubscrType.field].
  final type;

  SubscrManager(this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == SubscrType.author ? '已订阅发布方' : '已关注领域'),
      ),
      body: Consumer<Account>(
        builder: (context, value, child) => ListView(
            children: type == SubscrType.author
                ? user.subscrAuthors
                    .map((e) => ListTile(
                          title: Text(e),
                          onTap: () {
                            user.removeAuthor(e);
                          },
                        ))
                    .toList()
                : user.favFields
                    .map((e) => ListTile(
                          title: Text(e),
                          onTap: () {
                            user.removeField(e);
                          },
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
  /// If the instance handles author subscriptions, it has the value
  /// [SubscrType.author]. Otherwise, it handles favorite fields, and has the
  /// value [SubscrType.field].
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
        title: Text(widget.type == SubscrType.author ? '订阅新发布方' : '关注新领域'),
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
                children: widget.type == SubscrType.author
                    ? authors
                        .where(
                            (element) => !user.subscrAuthors.contains(element))
                        .where((element) => element
                            .toLowerCase()
                            .contains(controller.text.toLowerCase()))
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                user.addAuthor(e);
                              },
                            ))
                        .toList()
                    : fields
                        .where((element) => !user.favFields.contains(element))
                        .where((element) => element.contains(controller.text))
                        .map((e) => ListTile(
                              title: Text(e),
                              onTap: () {
                                user.addField(e);
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
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('发布')),
        body: Center(
            child: Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'RSS URL'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    // We have to interact with the back-end in the future, but
                    // since the back-end is not available now, we do nothing
                    // here.

                    controller.clear();
                  },
                  child: Text('提交'))
            ],
          ),
        )));
  }
}
