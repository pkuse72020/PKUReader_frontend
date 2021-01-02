import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'non_ui.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 360.0,
                height: 360.0,
                child: Image.asset(
                  'assets/images/about.png',
                ),
              ),
              SelectableText(
                'https://github.com/pkuse72020',
                style: TextStyle(fontSize: 16.0,
                fontFamily: 'RobotoMono'),
              ),
            ],
          ),
        ),
        backgroundColor: AppTheme.notWhite
        );
  }
}
