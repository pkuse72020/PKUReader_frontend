import 'package:flutter/material.dart';
import 'login.dart';
import '../non_ui.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey = GlobalKey<FormState>();
  String account ='', password='';
  bool isObscure = true;
  bool isEmpty =false;
  final accountController = TextEditingController();
  final pwdController = TextEditingController();
  final repwdController = TextEditingController();

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

  void showAlertDialog(dynamic description){
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
                  repwdController.clear();
                });
              }
          ),
        ],
      ),
    );
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
            SizedBox(height: 30.0),
            buildRePassword(context),
            SizedBox(height: 60.0),
            buildRegisterButton(context),
            SizedBox(height: 10.0),
            buildLogin(context),
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
            'Register',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue[300],
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              //TODO 执行登录方法
              bool connected=true;
              Future.delayed(Duration(seconds: 1),()=>Account.register(account,password))
                  .catchError((e){
                    showAlertDialog(e);
                    connected=false;
                  })
                  .whenComplete((){
                    if(connected){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
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
      //obscureText: isObscure,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }else if(value!=pwdController.text){
          return '两次输入的密码不一致';
        }
      },
      decoration: InputDecoration(
        labelText: 'Confirm Password',
//        suffixIcon: IconButton(
//            icon: Icon(
//                (isObscure) ? Icons.visibility_off : Icons.visibility
//            ),
//            onPressed: () {
//              setState(() {
//                isObscure = !isObscure;
//              });
//            }),
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
                  pwdController.clear();
                  repwdController.clear();
                });
              }):null
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Register',
        style: TextStyle(fontSize: 48.0),
      ),
    );
  }
}