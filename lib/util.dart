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