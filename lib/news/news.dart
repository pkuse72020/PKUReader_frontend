import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../non_ui.dart';
import '../main.dart';

class BrowseNews extends StatefulWidget {
  @override
  _BrowseNewsState createState() => _BrowseNewsState();
}

class _BrowseNewsState extends State<BrowseNews> {
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

  //List Item
  Widget getListItem(coverImage, title) => Container(
        margin: EdgeInsets.only(right: 0),
        height: 250,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
          image: DecorationImage(
              image: new ExactAssetImage(coverImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 20, bottom: 10),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 6,
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget getOneArticle(int i) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: InkWell(
            hoverColor: Colors.white70,
            enableFeedback: true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          new ReadNews(article: user.newsCache[i])));
            },
            child: getListItem(
                // TODO Use proper pictures.
                'assets/images/article/pkulibrary.jpeg', //picture
                user.newsCache[i].title) //title
            ),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        margin: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(38.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 4, bottom: 4),
                          child: TextField(
                            onChanged: (String txt) {},
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            cursorColor: HexColor('#54D3C2'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '北大 ...',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: HexColor('#54D3C2'),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(38.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(32.0),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(FontAwesomeIcons.search,
                              size: 20, color: const Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 350,
                height: 665,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: user.newsCache.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getOneArticle(
                              user.newsCache.length - 1 - index);
                        }),
                    onRefresh: () async {
                      try {
                        await user.getNews();
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('异常'),
                            content: Text(e.toString()),
                          ),
                        );
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HighlightedWord {
  final TextStyle textStyle;
  final VoidCallback onTap;

  HighlightedWord({
    @required this.onTap,
    this.textStyle = const TextStyle(
      color: Colors.red,
    ),
  });
}

class HighlightMap {
  LinkedHashMap<String, HighlightedWord> _hashMap = LinkedHashMap(
    equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
    hashCode: (a) => a.toLowerCase().hashCode,
  );

  HighlightMap(Map<String, HighlightedWord> myMap) {
    myMap.forEach((k, v) {
      _hashMap[k] = v;
    });
  }

  get getMap => _hashMap;
}

class ReadNews extends StatefulWidget {
  final Article article;
  final callback;
  ReadNews({this.article, this.callback});

  @override
  _ReadNewsState createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  AlertDialog getAlertDialog(context, word, explanation) {
    return AlertDialog(
      title: Text(word),
      content: Text(explanation),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        )
      ],
    );
  }

  HighlightedWord getHighlightedWord(context, textStyle, word, explanation) {
    return HighlightedWord(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return getAlertDialog(context, word, explanation);
            });
      },
      textStyle: textStyle,
    );
  }

  Map<String, HighlightedWord> getKeyWordsMap(context, textStyle) {
    Map<String, HighlightedWord> myMap = new Map<String, HighlightedWord>();
    for (var key_word in widget.article.keywords.keys) {
      myMap[key_word] = getHighlightedWord(
          context, textStyle, key_word, widget.article.keywords[key_word]);
    }
    return myMap;
  }

  ///fucntion for building TextSpan for text
  TextSpan buildSpan(
      BuildContext context,
      String full_text,
      key_words_list,
      LinkedHashMap<String, HighlightedWord> hash_map,
      TextStyle defaultStyle,
      var to_default) {
    if (full_text.length == 0) return TextSpan(text: "");
    for (var key_word in key_words_list) {
      if (full_text.length < key_word.length) continue;
      String comp = full_text.substring(0, key_word.length);
      if (comp == key_word) {
        return TextSpan(
          text: comp,
          style: hash_map[comp].textStyle,
          children: [
            // TextSpan(
            //   text: " ",
            //   style: defaultStyle,
            // ),
            buildSpan(
                context,
                full_text.substring(comp.length, full_text.length),
                key_words_list,
                hash_map,
                defaultStyle,
                1),
          ],
          recognizer: TapGestureRecognizer()
            ..onTap = () => hash_map[comp].onTap(),
        );
      }
    }
    return TextSpan(
      text: full_text[0],
      // style: the_words.containsKey(currentWord)
      //     ? the_words[currentWord].textStyle
      //     : defaultStyle,
      style: to_default == 1 ? defaultStyle : null,
      children: [
        buildSpan(context, full_text.substring(1, full_text.length),
            key_words_list, hash_map, defaultStyle, 0),
      ],
      recognizer: null,
    );
  }

  TextSpan getSpan(BuildContext context, String full_text, full_dict) {
    TextStyle textStyle = TextStyle(
      color: Colors.blueAccent,
      fontSize: 16.5,
    );
    TextStyle defaultStyle = TextStyle(
      color: Colors.black54,
      fontSize: 16.5,
    );
    Map<String, HighlightedWord> key_words_map =
        getKeyWordsMap(context, textStyle);
    HighlightMap highlightMap = HighlightMap(key_words_map);
    final LinkedHashMap<String, HighlightedWord> hash_map = highlightMap.getMap;
    return buildSpan(
        context, full_text, full_dict.keys, hash_map, defaultStyle, 1);
  }

  //mainImage
  Widget mainImageWidget(height) => Container(
        height: height / 3,
        decoration: BoxDecoration(
          image: DecorationImage(image: new ExactAssetImage(
              // TODO Use proper pictures.
              'assets/images/article/pkulibrary.jpeg'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 48, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              IconButton(
                icon: (user.existArticle(widget.article))
                    ? Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 28,
                      )
                    : Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 28,
                      ),
                onPressed: () {
                  setState(() {
                    if (user.existArticle(widget.article))
                      user.removeArticle(widget.article);
                    else
                      user.addArticle(widget.article);
                  });
                  widget.callback();
                },
              )
            ],
          ),
        ),
      );

  //Bottom Sheet Content

  Widget bottomContent(height, width, need_hl, context) =>
      new SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: height / 30),
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Category
                Text(
                  "文章详情",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),

                SizedBox(
                  height: 12,
                ),

                //Title
                Text(
                  widget.article?.title ?? "",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                SizedBox(
                  height: 30,
                ),

                //Paragraph
                need_hl == 1
                    ? Text.rich(getSpan(context, widget.article.content,
                        widget.article.keywords))
                    : Text(
                        widget.article.content ?? "",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.5,
                          // height: 1.4
                        ),
                        textAlign: TextAlign.left,
                        // maxLines: 8,
                      ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            //Main Image
            mainImageWidget(height),

            //Bottom Sheet
            Container(
                //Bottom Sheet Dimensions
                margin: EdgeInsets.only(top: height / 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),

                // child: bottomContent(height, width),
                child: bottomContent(height, width, 1, context)),
          ],
        ),
      ),
    );
  }
}
