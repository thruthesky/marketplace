// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
import 'package:flutterflow_widgets/flutterflow_widgets.dart';

class LinkifyText extends StatefulWidget {
  const LinkifyText({
    Key? key,
    this.width,
    this.height,
    required this.text,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String text;

  @override
  _LinkifyTextState createState() => _LinkifyTextState();
}

class _LinkifyTextState extends State<LinkifyText> {
  @override
  Widget build(BuildContext context) {
    return LinkText(
      text: widget.text,
    );
  }
}
