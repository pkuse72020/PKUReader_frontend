import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pkureader_frontend/account/login.dart';
import 'package:pkureader_frontend/app_theme.dart';
import 'package:pkureader_frontend/util.dart';

import '../non_ui.dart';

class BrowseNews extends StatefulWidget {
  final VoidCallback callback;

  BrowseNews({@required this.callback});

  @override
  _BrowseNewsState createState() => _BrowseNewsState();
}

class _BrowseNewsState extends State<BrowseNews> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  //List Item
  Widget getListItem(Article article) => Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 0),
            height: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(article.imgLinks[0]),
                  fit: BoxFit.cover),
            ),
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      maxLines: 6,
                    )),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)))),
          ),
          SizedBox(
            height: 250,
            // width: 350,
            child: Material(
                color: Color(0),
                child: InkResponse(
                  containedInkWell: true,
                  highlightShape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new ReadNews(
                              article: article, callback: widget.callback))),
                )),
          )
        ],
      );

  Widget getOneArticle(int i) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: getListItem(user.newsCache[i]),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.notWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: AppBar().preferredSize.height - 8),
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
                              left: 16, right: 8, top: 4, bottom: 4),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                suffixIcon: _searchController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        splashRadius: 0.001,
                                        icon: const Icon(
                                            CupertinoIcons.xmark_circle_fill,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        })),
                            onChanged: (str) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.pkuReaderPurple,
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
                        // onTap: () {
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(FontAwesomeIcons.search,
                              size: 20, color: const Color(0xFFFFFFFF)),
                        ),
                        onTap: () async {
                          try {
                            user.searchWord = _searchController.text;
                            await user.getSearchedArticles();
                            if (user.newsCache.length == 0) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('未搜索到结果！'),
                                ),
                              );
                            }
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => PkuReaderAlert(
                                    title: '搜索失败', e: e, context: context));
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color(0x2f000000), blurRadius: 20.0)
                  ],
                ),
                width: 350,
                height: 665,
                child: Material(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(40.0),
                      topEnd: Radius.circular(40.0)),
                  color: AppTheme.nearlyWhite,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RefreshIndicator(
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                              top: 48.0, left: 16.0, right: 16.0),
                          scrollDirection: Axis.vertical,
                          itemCount: user == null ? 0 : user.newsCache.length,
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
                              builder: (context) => PkuReaderAlert(
                                  title: '新闻获取失败', e: e, context: context));
                        }
                        setState(() {});
                      },
                    ),
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
          child: Text('Ok'),
        )
      ],
    );
  }

  //mainImage
  Widget mainImageWidget(height) => Container(
        height: height / 3,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(widget.article.imgLinks[0]),
              fit: BoxFit.cover),
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
                onPressed: () async {
                  if (user?.token == null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage(callback: () {
                              setState(() {});
                            })));
                    return;
                  }
                  if (user.existArticle(widget.article))
                    await user.removeArticle(widget.article);
                  else
                    await user.addArticle(widget.article);
                  setState(() {});
                  if (widget.callback != null) widget.callback();
                },
              )
            ],
          ),
        ),
      );

  //Bottom Sheet Content

  Widget bottomContent(height, width, context) => new SingleChildScrollView(
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
                  '文章详情',
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
                  widget.article?.title ?? '',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                SizedBox(
                  height: 30,
                ),

                //Paragraph
                Html(
                  data: widget.article.content,
                  key_words_dict: widget.article.keywords,
                  style: {
                    'html': Style(
                      fontSize: const FontSize(16.5),
                      color: Colors.black54,
                    )
                  },
                )
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
                child: bottomContent(height, width, context)),
          ],
        ),
      ),
    );
  }
}
