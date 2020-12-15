import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'non_ui.g.dart';

/// Non-UI classes.

/// The temporary example account.
Account user;
Box<Account> box;
const String userBox = 'user_box_1';
const String loginURL = "http://39.98.93.128:5000/user/login";
const String registerURL = "http://39.98.93.128:5000/user/signup";

/// An account data structure.
///
/// An instance of this class represents an account using this app. For now, we
/// use the main memory or the local storage to store the user data. After the
/// integration of the back-end, this should be constructed using data fetched
/// from the server.
@HiveType(typeId: 0)
class Account extends ChangeNotifier with HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final List<Article> favArticles;

  @HiveField(4)
  final List<Source> subscrRssSrcs;

  @HiveField(5)
  final List<Article> newsCache;

  Account(
      {this.token,
      this.userName,
      this.userId,
      List<Article> favArticles,
      List<Source> subscrRssSrcs,
      List<Article> newsCache})
      : favArticles = favArticles ?? List<Article>(),
        subscrRssSrcs = subscrRssSrcs ?? List<Source>(),
        newsCache = newsCache ?? List<Article>();

  // Those return types may change in the future, because we may need to return
  // a status (of whether the operation was successful).

  bool existArticle(String title) {
    if (favArticles.any((element) => element.title == title)) {
      // TODO: Replace data with real articles.
      return true;
    }
    return false;
  }

  void addArticle(Article article) {
    favArticles.add(article);
    save();
    notifyListeners();
  }

  void removeArticle(String title) {
    favArticles.removeWhere((element) => element.title == title);
    save();
    notifyListeners();
  }

  void addSource(Source source) {
    subscrRssSrcs.add(source);
    save();
    notifyListeners();
  }

  void removeSource(Source source) {
    subscrRssSrcs.removeWhere((element) => element == source);
    save();
    notifyListeners();
  }

  List<Article> search(String pattern) {
    // TODO Implement this.
  }

  /// Get news based on the user's subscriptions from the server.
  void getNews() {
    // TODO Implement this.
  }

  static void logIn(String userName, String password) async {
    // TODO Implement this.
    var body = {"username": userName, "password": password};
    var response = await http.post(loginURL, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      String state = jsonResponse["state"];
      if (state == 'failed') {
        //print(jsonResponse["description"]);
        throw new Exception(jsonResponse["description"]);
      } else {
        Account account = Account(
            token: jsonResponse["token"],
            userName: userName,
            userId: jsonResponse["UserId"]);
        user = account;
        await box.put('user', user);
        print(account.token);
      }
    }
  }

  static void register(String userName, String password) async {
    // TODO Implement this.
    var body = {"username": userName, "password": password};
    var response = await http.post(registerURL, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse);
      String state = jsonResponse["state"];
      if (state == 'failed') {
        throw new Exception(jsonResponse["description"]);
      } else {
        print(jsonResponse["UserId"]);
      }
    }
  }

  static void logOut() {
    // TODO Implement this.
  }

  /// Restore the previous account state on the disk.
  static Future<void> restore() async {
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(ArticleAdapter());
    Hive.registerAdapter(SourceAdapter());
    await Hive.initFlutter();
    box = await Hive.openBox<Account>(userBox);
    // user = box.get('user');
    Account example_account = Account(token: "example", userName: "PKUer", userId: "0100010");
    user = example_account;
    await box.put('user',user);
  }
}

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  // If we want to provide different explanations for one word based on the
  // context, a [Map] may seem not so appropriate.
  //
  // Since we are now using the [highlight_text] package, which (seemingly) does
  // not support the function described above, a [Map<String, String>] is okay.
  @HiveField(2)
  final Map<String, String> keywords;

  Article(this.title, this.content, {this.keywords});
}

@HiveType(typeId: 2)
class Source {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  Source(this.name, this.url);
}
