// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
import '../../flutter_flow/flutter_flow_media_display.dart';
import '../../flutter_flow/flutter_flow_video_player.dart';

class UploadedMedia extends StatefulWidget {
  const UploadedMedia({
    Key? key,
    this.width,
    this.height,
    required this.url,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String url;

  @override
  _UploadedMediaState createState() => _UploadedMediaState();
}

class _UploadedMediaState extends State<UploadedMedia> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.url),
      child: FlutterFlowMediaDisplay(
        path: widget.url,
        imageBuilder: (path) => Image.network(
          path,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
          path: path,
          width: 300,
          autoPlay: false,
          looping: true,
          showControls: true,
          allowFullScreen: true,
          allowPlaybackSpeedMenu: false,
        ),
      ),
    );
  }
}
