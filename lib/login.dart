import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
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
          return '请输入账户';
        }
      },
      decoration: InputDecoration(
          labelText: 'Account',
          suffixIcon: (isEmpty)
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    setState(() {
                      accountController.clear();
                      accountController.clear();
                    });
                  })
              : null),
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