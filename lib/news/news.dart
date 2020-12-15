import 'package:flutter/material.dart';

import '../local.dart';
import '../non_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('浏览新闻')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: '搜索'),
              ),
            ),
            // news_dict.keys.map<Widget>((key)=>Container(child:Text(key))).toList()
            Expanded(
                child: ListView(
                    children: news_dict.keys
                        .map<Widget>((element) => ListTile(
                              title: Text(element),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new ReadNews(title: element)));
                              },
                            ))
                        .toList()))
          ]),
        ),
      ),
    );
  }
}

class ReadNews extends StatefulWidget {
  final title;
  ReadNews({this.title});

  // final title='阔别900余天，图书馆东楼今日重启';
  @override
  _ReadNewsState createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  //mainImage
  Widget mainImageWidget(height) => Container(
        height: height / 3,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: new ExactAssetImage(news_pic_dict[widget.title] ?? ""),
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
                icon: (user.existArticle(widget.title))
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
                    if (user.existArticle(widget.title))
                      user.removeArticle(widget.title);
                    else
                      user.addArticle(
                          Article(widget.title, news_dict[widget.title]));
                  });
                },
              )
            ],
          ),
        ),
      );

  //Bottom Sheet Content

  Widget bottomContent(height, width) => new SingleChildScrollView(
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
                  widget.title ?? "",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                SizedBox(
                  height: 30,
                ),

                //Paragraph
                Text(
                  news_dict[widget.title] ?? "",
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

              child: bottomContent(height, width),
            ),
          ],
        ),
      ),
    );
  }
}
