import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PkuReader(),
  ));
}

/// Creates a page-list item (a [ListTile] instance).
///
/// This is a temporary function, which should be removed when the navigator
/// design is finished.
Widget newPageListItem(BuildContext context, String name, Widget widget) {
  return ListTile(
    title: Text('Test'),
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Test(),
      ));
    },
  );
}

class PkuReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PKU Reader')),
      body: ListView(
        children: [
          newPageListItem(context, 'Test', Test()),
        ],
      ),
    );
  }
}

/// A Test page.
///
/// This is a temporary widget, which CAN be removed after finishing the first
/// module and SHOULD be removed when the navigator design is finished.
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'This is a test page.\n\n'
            'It is used to show how to add a page to the temporary page list.',
            style: TextStyle(
              fontSize: 24,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
