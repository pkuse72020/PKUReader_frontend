import 'package:flutter/material.dart';

/// Non-UI classes.

/// The temporary example account.
final user = Account(id: 'admin@example.com', name: '示例用户');

/// An account data structure.
///
/// An instance of this class represents an account using this app. For now, we
/// use the main memory or the local storage to store the user data. After the
/// integration of the back-end, this should be constructed using data fetched
/// from the server.
class Account extends ChangeNotifier {
  final String id;
  final String name;
  final favArticles = List<Article>();
  final subscrRssSrcs = List<Source>();
  final newsCache = List<Article>();

  Account({this.id, this.name});

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

  static void logIn(String userName, String password) {
    // TODO Implement this.
  }

  static void register(String userName, String password) {
    // TODO Implement this.
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
