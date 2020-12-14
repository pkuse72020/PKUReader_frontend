import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;
/// Non-UI classes.

/// The temporary example account.
Account user = null;
const String loginURL="http://39.98.93.128:5000/user/login";
const String registerURL="http://39.98.93.128:5000/user/signup";

/// An account data structure.
///
/// An instance of this class represents an account using this app. For now, we
/// use the main memory or the local storage to store the user data. After the
/// integration of the back-end, this should be constructed using data fetched
/// from the server.

class Account extends ChangeNotifier {
  final String token;
  final String userName;
  final String userId;
  final favArticles = List<Article>();
  final subscrRssSrcs = List<Source>();
  final newsCache = List<Article>();

  Account({this.token, this.userName,this.userId});

  // Those return types may change in the future, because we may need to return
  // a status (of whether the operation was successful).

  void addArticle(Article article) {
    favArticles.add(article);
    notifyListeners();
  }

  void removeArticle(Article article) {
    favArticles.removeWhere((element) => element == article);
    notifyListeners();
  }

  void addSource(Source source) {
    subscrRssSrcs.add(source);
    notifyListeners();
  }

  void removeSource(Source source) {
    subscrRssSrcs.removeWhere((element) => element == source);
    notifyListeners();
  }

  List<Article> search(String pattern) {
    // TODO Implement this.
  }

  /// Get news based on the user's subscriptions from the server.
  void getNews() {
    // TODO Implement this.
  }

  static void logIn(String userName, String password) async{
    // TODO Implement this.
    var body={"username": userName, "password": password};
    var response=await http.post(loginURL,body:body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      String state=jsonResponse["state"];
      if(state=='failed'){
        //print(jsonResponse["description"]);
        throw new Exception(jsonResponse["description"]);
      }else{
        Account account=Account(token:jsonResponse["token"],userName:userName,userId:jsonResponse["UserId"]);
        user=account;
        print(account.token);
      }
    }
  }

  static void register(String userName, String password) async {
    // TODO Implement this.
    var body={"username": userName, "password": password};
    var response=await http.post(registerURL,body:body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse);
      String state=jsonResponse["state"];
      if(state=='failed'){
        throw new Exception(jsonResponse["description"]);
      }else{
        print(jsonResponse["UserId"]);
      }
    }
  }

  static void logOut() {
    // TODO Implement this.
  }

  /// Save the current account state on the disk.
  static void save() {
    // TODO Implement this.
  }

  /// Restore the previous account state on the disk.
  static void restore() {
    // TODO Implement this.
  }
}

class Article {
  final String title;
  final String content;

  // If we want to provide different explanations for one word based on the
  // context, a [Map] may seem not so appropriate.
  //
  // Since we are now using the [highlight_text] package, which (seemingly) does
  // not support the function described above, a [Map<String, String>] is okay.
  final Map<String, String> keywords;

  Article(this.title, this.content, {this.keywords});
}

class Source {
  final String name;
  final String url;

  Source(this.name, this.url);
}
