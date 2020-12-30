import 'package:flutter/material.dart';

/// Creates a page-list item (a [ListTile] instance).
///
/// This is a temporary function, which should be removed when the navigator
/// design is finished.
Widget newPageListItem(BuildContext context, String name, Widget widget) {
  return ListTile(
    title: Text(name),
    onTap: widget == null
        ? null
        : () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => widget,
            ));
          },
  );
}

class PkuReaderAlert extends AlertDialog {
  PkuReaderAlert(
      {String title = '异常',
      dynamic e,
      String description = '发生内部错误。',
      @required BuildContext context})
      : super(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(description + '可向技术人员提供以下错误信息：\n'),
              SelectableText(e.toString(),
                  style: TextStyle(fontFamily: 'RobotoMono')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('关闭'))
          ],
        );
}
