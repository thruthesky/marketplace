import '../auth/auth_util.dart';
import '../backend/firebase_storage/storage.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String uploadedFileUrl = '';
  String? uploadedMediaUrl;
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, ${valueOrDefault<String>(
                  currentUserUid,
                  'UID',
                )}',
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
              FFButtonWidget(
                onPressed: () async {
                  final selectedMedia = await selectMediaWithSourceBottomSheet(
                    context: context,
                    maxWidth: 1200.00,
                    maxHeight: 800.00,
                    imageQuality: 95,
                    allowPhoto: true,
                    backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                    textColor: FlutterFlowTheme.of(context).primaryBackground,
                    pickerFontFamily: 'Open Sans',
                  );
                  if (selectedMedia != null &&
                      selectedMedia.every(
                          (m) => validateFileFormat(m.storagePath, context))) {
                    showUploadMessage(
                      context,
                      'Uploading file...',
                      showLoading: true,
                    );
                    final downloadUrls = (await Future.wait(selectedMedia.map(
                            (m) async =>
                                await uploadData(m.storagePath, m.bytes))))
                        .where((u) => u != null)
                        .map((u) => u!)
                        .toList();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (downloadUrls.length == selectedMedia.length) {
                      setState(() => uploadedFileUrl = downloadUrls.first);
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
                  textStyle: FlutterFlowTheme.of(context).subtitle2.override(
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
              FFButtonWidget(
                onPressed: () async {
                  uploadedMediaUrl = await actions.uploadMedia();

                  setState(() {});
                },
                text: 'Custom Upload',
                options: FFButtonOptions(
                  width: 130,
                  height: 40,
                  color: FlutterFlowTheme.of(context).primaryColor,
                  textStyle: FlutterFlowTheme.of(context).subtitle2.override(
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
            ],
          ),
        ),
      ),
    );
  }
}
