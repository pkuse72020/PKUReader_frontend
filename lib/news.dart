import 'package:flutter/material.dart';

import 'local.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? "")),
        body: Container(child: Text(news_dict[widget.title] ?? "")));
  }
}