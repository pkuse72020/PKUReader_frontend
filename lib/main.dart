import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkureader_frontend/local.dart';
import 'package:provider/provider.dart';

import 'local.dart';
import 'local.dart';
import 'local.dart';
import 'local.dart';
import 'local.dart';
import 'local.dart';
import 'local.dart';
import 'local.dart';

/// The temporary example account.
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
              )),
          newPageListItem(
              context,
              '新闻浏览',
              BrowseNews()
          ),
          newPageListItem(
              context,
              '新闻阅读',
              ReadNews(
                title:'阔别900余天，图书馆东楼今日重启',
              )
          )
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

class BrowseNews extends StatefulWidget{

  @override
  _BrowseNewsState createState()=>_BrowseNewsState();
}

class _BrowseNewsState extends State<BrowseNews>{
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
      appBar: AppBar(title: Text('浏览新闻')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: '搜索'),
                ),
              ),
              // news_dict.keys.map<Widget>((key)=>Container(child:Text(key))).toList()
              Expanded(
                  child: ListView(
                    children:news_dict
                        .keys
                        .map<Widget>(
                            (element)=>ListTile(
                                title:Text(element),
                                onTap:(){
                                  Navigator.push(context,
                                  new MaterialPageRoute(builder:(context)
                                  => new ReadNews(title:element)));
                                },
                            )
                    ).toList()
                  )
                )
             ]
          ),
        ),
      ),
    );
  }
}

class ReadNews extends StatefulWidget{

  final title;
  ReadNews({this.title});

  // final title='阔别900余天，图书馆东楼今日重启';
  @override
  _ReadNewsState createState()=>_ReadNewsState();
}

class _ReadNewsState extends State<ReadNews>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text(widget.title??"")),
        body:Container(
            child:Text(news_dict[widget.title]??"")
        )
    );
  }
}




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  String account ='', password='';
  bool isObscure = true;
  bool isEmpty =false;
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void initState(){
    accountController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (accountController.text.length > 0) {
        isEmpty = true;
      } else {
        isEmpty = false;
      }
      setState(() {

      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                SizedBox(height: 60.0),
                buildAccount(),
                SizedBox(height: 30.0),
                buildPassword(context),
                buildForgetPassword(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 10.0),
                buildRegister(context),
              ],
            ),
        ),
    );
  }

  Align buildRegister(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                //TODO 跳转到注册页面
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue[300],
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              //TODO 执行登录方法
              print('email:$account , password:$password');
            }
          },
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  Padding buildForgetPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            //TODO 可能没这功能
            //Navigator.pop(context);
          },
        ),
      ),
    );
  }

  TextFormField buildPassword(BuildContext context) {
    return TextFormField(
      controller: pwdController,
      onSaved: (String value) => password = value,
      obscureText: isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                (isObscure) ? Icons.visibility_off : Icons.visibility
              ),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              }),
      ),
    );
  }

  TextFormField buildAccount() {
    return TextFormField(
      controller: accountController,
      onSaved: (String value) => account = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入账户';
        }
      },
      decoration: InputDecoration(
        labelText: 'Account',
          suffixIcon:(isEmpty)?IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                setState(() {
                  accountController.clear();
                  accountController.clear();
                });
              }):null
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 48.0),
      ),
    );
  }
}