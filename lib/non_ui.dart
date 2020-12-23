import 'dart:io';

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
const timeout = Duration(seconds: 15);

const rootUrl = 'http://39.98.93.128:5000';
const loginUrl = rootUrl + '/user/login';
const registerUrl = rootUrl + '/user/signup';
const addFavUrl = rootUrl + '/userfavor/addFavorArticle';
const getFavUrl = rootUrl + '/userfavor/getFavorArticle';
const removeFavUrl = rootUrl + '/userfavor/removeFavorArticle';
const addSubscrUrl = rootUrl + '/userfavor/addFavorRSS';
const getSubscrUrl = rootUrl + '/userfavor/getFavorRSS';
const getSubscrLinksUrl = rootUrl + '/userfavor/getFavorRSSlinks';
const getRssUrl = rootUrl + '/rssdb/getAllRSS';
const removeSubscrUrl = rootUrl + '/userfavor/removeFavorRSS';
const getNewsUrl = rootUrl + '/content/getArticles';
const submitUrl = rootUrl + '/rssdb/addPendingMsg';

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
  List<Article> favArticles;

  @HiveField(4)
  List<Source> subscrRssSrcs;

  @HiveField(5)
  final List<Article> newsCache;

  get authHeader =>
      'basic ' + convert.base64Encode((token + ':').runes.toList());

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

  bool existArticle(Article article) {
    if (favArticles.any((element) => element.id == article.id)) {
      return true;
    }
    return false;
  }

  Future<void> addArticle(Article article) async {
    final response = await http.post(addFavUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
      'articleId': article.id,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      favArticles.add(article);
      save();
      notifyListeners();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> removeArticle(Article article) async {
    final response = await http.post(removeFavUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
      'articleId': article.id,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      favArticles.removeWhere((element) => element.id == article.id);
      save();
      notifyListeners();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> addSource(Source source) async {
    final response = await http.post(addSubscrUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
      'RSSId': source.id,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      subscrRssSrcs.add(source);
      save();
      notifyListeners();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> getFavArticles() async {
    final response = await http.post(getFavUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      favArticles = (json['rst'] as List<dynamic>)
          .map((e) => Article.fromVarJson(e))
          .toList();
      save();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> getSubscrSrcs() async {
    final response = await http.post(getSubscrLinksUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      subscrRssSrcs = (json['rst'] as List<dynamic>)
          .map((e) => Source.fromJson(e))
          .toList();
      save();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> removeSource(Source source) async {
    final response = await http.post(removeSubscrUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
      'RSSId': source.id,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      subscrRssSrcs.removeWhere((element) => element == source);
      save();
      notifyListeners();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  Future<void> submit(String name, String url) async {
    final response = await http.post(submitUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userId': userId,
      'rsstitle': name,
      'rsslink': url,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  bool hasSource(Source source) =>
      subscrRssSrcs.any((element) => element.id == source.id);

  List<Article> search(String pattern) {
    // TODO Implement this.
  }

  /// Get news based on the user's subscriptions from the server.
  Future<void> getNews() async {
    final response = await http.post(getNewsUrl, headers: {
      HttpHeaders.authorizationHeader: authHeader
    }, body: {
      'userid': userId,
    }).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final state = json['state'];
      if (state != 'success') throw Exception(json['description']);
      newsCache.addAll((json['article_list'] as Map<String, dynamic>)
          .values
          .map((e) => Article.fromJson(e))
          .where((e) => !newsCache.any((element) => e.id == element.id)));
      save();
    } else {
      throw Exception('HTTP error ' + response.statusCode.toString());
    }
  }

  static void logIn(String userName, String password) async {
    // TODO Implement this.
    var body = {"username": userName, "password": password};
    var response = await http.post(loginUrl, body: body);
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
    var response = await http.post(registerUrl, body: body);
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

  static Future<void> logOut() async {
    await box.delete('user');
    user = null;
  }

  /// Restore the previous account state on the disk.
  static Future<void> restore() async {
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(ArticleAdapter());
    Hive.registerAdapter(SourceAdapter());
    await Hive.initFlutter();
    box = await Hive.openBox<Account>(userBox);
    user = box.get('user');
    // Account example_account = Account(token: "example", userName: "PKUer", userId: "0100010");
    // user = example_account;
    // await box.put('user',user);
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

  @HiveField(3)
  final String id;

  Article(
      {@required this.title,
      @required this.content,
      @required this.keywords,
      @required this.id});

  factory Article.fromJson(Map<String, dynamic> json) => Article(
      title: json['title'],
      content: json['article'],
      id: json['id'],
      keywords: Map.fromEntries((json['keyword_list'] as Map<String, dynamic>)
          .values
          .map((e) => MapEntry(e, 'Not implemented'))));

  factory Article.fromVarJson(Map<String, dynamic> json) => Article(
      title: json['title'],
      content: json['content'],
      id: json['articleId'],
      keywords: Map.fromEntries((json['keywords'] as Map<String, dynamic>)
          .values
          .map((e) => MapEntry(e, 'Not implemented'))));
}

@HiveType(typeId: 2)
class Source {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String id;

  Source({this.name, this.url, this.id});

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json['rsstitle'],
        url: json['rsslink'],
        id: json['rssId'].toString(),
      );

  static Future<Iterable<Source>> getAllSources() async {
    final response = await http.get(getRssUrl).timeout(timeout);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body);
      final String state = json['state'];
      if (state == 'success')
        return (json['rst'] as List<dynamic>).map((e) => Source.fromJson(e));
      else
        throw Exception(json['description']);
    }

    return null;
  }
}
