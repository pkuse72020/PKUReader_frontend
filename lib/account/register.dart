import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkureader_frontend/app_theme.dart';
import 'login.dart';
import '../non_ui.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String account = '', password = '';
  bool isObscure = true;
  bool isEmpty = false;
  bool apiCall = false;
  final accountController = TextEditingController();
  final pwdController = TextEditingController();
  final repwdController = TextEditingController();

  @override
  void initState() {
    accountController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (accountController.text.length > 0) {
        isEmpty = true;
      } else {
        isEmpty = false;
      }
      setState(() {});
    });
    super.initState();
  }

  void showAlertDialog(dynamic description) {
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text('Failed'),
        content: Text(description.toString()),
        actions: [
          new FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  accountController.clear();
                  pwdController.clear();
                  repwdController.clear();
                });
              }),
        ],
      ),
    );
  }

  void progressIndicator(bool status) {
    if (apiCall == true && status == false)
      Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      apiCall = status;
    });
    showIndicator();
  }

  void showIndicator() {
    if (apiCall) {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Dialog(
          child: Container(
              height: 100.0,
              child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new CircularProgressIndicator(),
                    new Text('Loading'),
                  ],
                ),
              )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Hero(tag: 'logo', child: buildTitle()),
                  Hero(
                      tag: 'user_name', child: Material(child: buildAccount())),
                  Hero(
                      tag: 'password',
                      child: Material(child: buildPassword(context))),
                  buildRePassword(context),
                  SizedBox(),
                  Hero(tag: 'button', child: buildRegisterButton(context)),
                  // SizedBox(height: 10.0),
                  // buildLogin(context),
                ],
              ),
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: 'back',
                child: Material(
                  child: IconButton(
                    splashRadius: 24.0,
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Align buildLogin(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('已有账号?'),
            GestureDetector(
              child: Text(
                '点击登陆',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Align buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '注册',
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.0),
          ),
          color: AppTheme.pkuReaderPurple,
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              progressIndicator(true);
              bool connected = true;
              dynamic message = '';
              Future.delayed(Duration(seconds: 1),
                  () => Account.register(account, password)).catchError((e) {
                message = e;
                connected = false;
              }).whenComplete(() {
                progressIndicator(false);
                if (connected) {
                  Navigator.of(context).pop();
                } else {
                  showAlertDialog(message);
                }
              });
            }
          },
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  TextFormField buildRePassword(BuildContext context) {
    return TextFormField(
      controller: repwdController,
      //onSaved: (String value) => repassword = value,
      obscureText: isObscure,
      // obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return '密码不能为空';
        } else if (value != pwdController.text) {
          return '两次输入的密码不一致';
        }
      },
      decoration: InputDecoration(
        labelText: '确认密码',
        suffixIcon: IconButton(
            icon: Icon((isObscure) ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            }),
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
          return '密码不能为空';
        }
      },
      decoration: InputDecoration(
        labelText: '密码',
        suffixIcon: IconButton(
            icon: Icon((isObscure) ? Icons.visibility_off : Icons.visibility),
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
          return '用户名不能为空';
        }
      },
      decoration: InputDecoration(
          labelText: '用户名',
          suffixIcon: (isEmpty)
              ? IconButton(
                  splashRadius: 0.001,
                  icon: const Icon(CupertinoIcons.xmark_circle_fill,
                      color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      accountController.clear();
                      pwdController.clear();
                      repwdController.clear();
                    });
                  })
              : null),
    );
  }

  Widget buildTitle() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom) /
          4,
      child: Image.asset('assets/images/pku_reader_cut.png'),
    );
  }
}
