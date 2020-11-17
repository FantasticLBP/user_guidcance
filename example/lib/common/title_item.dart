import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TitleItem extends StatelessWidget {
  final String title;
  final EdgeInsets paddding;
  const TitleItem(this.title, {this.paddding = const EdgeInsets.fromLTRB(16, 24, 16, 0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "${this.title}",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF323233)),
          ),
          Spacer(
            flex: 1,
          )
        ],
      ),
      padding: this.paddding,
    );
  }
}