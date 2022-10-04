import '../auth/auth_util.dart';
import '../backend/firebase_storage/storage.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_media_display.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_video_player.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import '../custom_code/actions/index.dart' as actions;
import '../custom_code/widgets/index.dart' as custom_widgets;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<String> uploadedFileUrls = [];
  List<String>? uploadedMediaUrls;
  List<String>? uploadedVideoUrls;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome, ${valueOrDefault<String>(
                    currentUserUid,
                    'UID',
                  )}',
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
                custom_widgets.LinkifyText(
                  width: double.infinity,
                  height: 32,
                  text: 'Hi, There. https://philgo.com ;',
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      final selectedMedia = await selectMedia(
                        maxWidth: 1200.00,
                        maxHeight: 800.00,
                        imageQuality: 95,
                        mediaSource: MediaSource.photoGallery,
                        multiImage: true,
                      );
                      if (selectedMedia != null &&
                          selectedMedia.every((m) =>
                              validateFileFormat(m.storagePath, context))) {
                        showUploadMessage(
                          context,
                          'Uploading file...',
                          showLoading: true,
                        );
                        final downloadUrls = (await Future.wait(
                                selectedMedia.map((m) async =>
                                    await uploadData(m.storagePath, m.bytes))))
                            .where((u) => u != null)
                            .map((u) => u!)
                            .toList();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        if (downloadUrls.length == selectedMedia.length) {
                          setState(() => uploadedFileUrls = downloadUrls);
                          showUploadMessage(
                            context,
                            'Success!',
                          );
                        } else {
                          showUploadMessage(
                            context,
                            'Failed to upload media',
                          );
                          return;
                        }
                      }
                    },
                    text: 'Default Upload',
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      uploadedMediaUrls = await actions.uploadMedia(
                        context,
                        true,
                        false,
                        true,
                        1200.0,
                        800.0,
                        95,
                      );
                      setState(() => FFAppState().uploadedImageUrls = functions
                          .mergeTwoStringArray(
                              FFAppState().uploadedImageUrls.toList(),
                              uploadedMediaUrls!.toList())
                          .toList());

                      setState(() {});
                    },
                    text: 'Multi image upload',
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (!functions.isStringArrayNullOrEmpty(
                    FFAppState().uploadedImageUrls.toList()))
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Builder(
                      builder: (context) {
                        final listOfUploadedMedialUrls =
                            FFAppState().uploadedImageUrls.toList();
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listOfUploadedMedialUrls.length,
                          itemBuilder:
                              (context, listOfUploadedMedialUrlsIndex) {
                            final listOfUploadedMedialUrlsItem =
                                listOfUploadedMedialUrls[
                                    listOfUploadedMedialUrlsIndex];
                            return Stack(
                              children: [
                                Image.network(
                                  functions.convertStringToImagePath(
                                      listOfUploadedMedialUrlsItem),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 1,
                                  fit: BoxFit.cover,
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1, -1),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30,
                                    borderWidth: 1,
                                    buttonSize: 60,
                                    icon: Icon(
                                      Icons.delete_forever_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      await actions.deleteMedia(
                                        listOfUploadedMedialUrlsItem,
                                      );
                                      setState(() => FFAppState()
                                          .uploadedImageUrls
                                          .remove(
                                              listOfUploadedMedialUrlsItem));
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      uploadedVideoUrls = await actions.uploadMedia(
                        context,
                        true,
                        true,
                        false,
                        12000.0,
                        800.0,
                        80,
                      );
                      setState(() => FFAppState().uploadedVideoUrls = functions
                          .mergeTwoStringArray(
                              FFAppState().uploadedVideoUrls.toList(),
                              uploadedVideoUrls!.toList())
                          .toList());

                      setState(() {});
                    },
                    text: 'Upload with video',
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (!functions.isStringArrayNullOrEmpty(
                    FFAppState().uploadedVideoUrls.toList()))
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Builder(
                      builder: (context) {
                        final listOfUploadedVideos =
                            FFAppState().uploadedVideoUrls.toList();
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(listOfUploadedVideos.length,
                              (listOfUploadedVideosIndex) {
                            final listOfUploadedVideosItem =
                                listOfUploadedVideos[listOfUploadedVideosIndex];
                            return Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: custom_widgets.UploadedMedia(
                                        width: double.infinity,
                                        height: 200,
                                        url: listOfUploadedVideosItem,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 60,
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        await actions.deleteMedia(
                                          listOfUploadedVideosItem,
                                        );
                                        setState(() => FFAppState()
                                            .uploadedVideoUrls
                                            .remove(listOfUploadedVideosItem));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                FlutterFlowMediaDisplay(
                  path: currentUserPhoto,
                  imageBuilder: (path) => Image.network(
                    path,
                    width: 300,
                    height: 300,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
