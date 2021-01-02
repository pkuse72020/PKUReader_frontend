import 'package:flutter/material.dart';

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
