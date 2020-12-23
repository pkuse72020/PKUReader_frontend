import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'register.dart';
import '../non_ui.dart';

class LoginPage extends StatefulWidget {
  final Function callback;

  LoginPage({this.callback});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String account = '', password = '';
  bool isObscure = true;
  bool isEmpty = false;
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

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
        title: Text("Failed"),
        content: Text(description.toString()),
        actions: [
          new FlatButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  accountController.clear();
                  pwdController.clear();
                });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              // SizedBox(
              //   height: kToolbarHeight,
              // ),
              Hero(tag: 'logo', child: buildTitle()),
              // SizedBox(height: 60.0),
              Hero(tag: 'user_name', child: Material(child: buildAccount())),
              // SizedBox(height: 30.0),
              Hero(
                  tag: 'password',
                  child: Material(child: buildPassword(context))),
              // SizedBox(height: 60.0),
              Hero(tag: 'button', child: buildLoginButton(context)),
              // SizedBox(height: 10.0),
              buildRegister(context),
            ],
          ),
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
            Text('没有账号? '),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: AppTheme.pkuReaderPurple),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(),
                    fullscreenDialog: true));
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
            '登录',
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.0),
          ),
          color: AppTheme.pkuReaderPurple,
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              //TODO 执行登录方法
              //同步调用
//              try{
//                Account.logIn(account,password);
//              }
//              catch(e){
//                print(e.toString());
//              }
              //异步调用
              bool connected = true;
              Future.delayed(Duration(seconds: 1),
                  () => Account.logIn(account, password)).catchError((e) {
                showAlertDialog(e);
                connected = false;
              }).whenComplete(() {
                if (connected) {
                  //TODO 回到主界面
                  widget.callback();
                  Navigator.of(context).pop();
                }
              });
            }
          },
          shape: StadiumBorder(),
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
          return '请输入用户名';
        }
      },
      decoration: InputDecoration(
          labelText: '用户名',
          suffixIcon: (isEmpty)
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    setState(() {
                      accountController.clear();
                      pwdController.clear();
                    });
                  })
              : null),
    );
  }

  Widget buildTitle() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom) /
          3.5,
      child: Image.asset('assets/images/pku_reader_cut.png'),
    );
  }
}
