import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../local.dart';
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
                        new ReadNews(title: (news_dict.keys.toList())[i])));
          },
          child: getListItem(
              news_pic_dict[news_dict.keys.toList()[i]], //picture
              news_dict.keys.toList()[i]), //title
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
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: news_dict.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getOneArticle(index);
                      }),
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
  final title;
  ReadNews({this.title});

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
