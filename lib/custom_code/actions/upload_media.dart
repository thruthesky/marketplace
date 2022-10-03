// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// Begin custom action code
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

const allowedFormats = {'image/png', 'image/jpeg', 'video/mp4', 'image/gif'};

class SelectedMedia {
  const SelectedMedia(this.storagePath, this.bytes);
  final String storagePath;
  final Uint8List bytes;
}

enum MediaSource {
  photoGallery,
  videoGallery,
  camera,
}

Future<List<SelectedMedia>?> selectMedia({
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  bool isVideo = false,
  MediaSource mediaSource = MediaSource.camera,
  bool multiImage = false,
}) async {
  final picker = ImagePicker();
  // User must sign-in before uploading media.
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  if (multiImage) {
    final pickedMediaFuture = picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    final pickedMedia = await pickedMediaFuture;
    if (pickedMedia == null || pickedMedia.isEmpty) {
      return null;
    }
    return Future.wait(pickedMedia.asMap().entries.map((e) async {
      final index = e.key;
      final media = e.value;
      final mediaBytes = await media.readAsBytes();
      final path = storagePath(currentUserUid, media.name, false, index);
      return SelectedMedia(path, mediaBytes);
    }));
  }

  final source = mediaSource == MediaSource.camera
      ? ImageSource.camera
      : ImageSource.gallery;
  final pickedMediaFuture = isVideo
      ? picker.pickVideo(source: source)
      : picker.pickImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          source: source,
        );
  final pickedMedia = await pickedMediaFuture;
  final mediaBytes = await pickedMedia?.readAsBytes();
  if (mediaBytes == null) {
    return null;
  }
  final path = storagePath(currentUserUid, pickedMedia!.name, isVideo);
  return [SelectedMedia(path, mediaBytes)];
}

bool validateFileFormat(String filePath, BuildContext context) {
  if (allowedFormats.contains(mime(filePath))) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Invalid file format: ${mime(filePath)}'),
    ));
  return false;
}

String storagePath(String uid, String filePath, bool isVideo, [int? index]) {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  // Workaround fixed by https://github.com/flutter/plugins/pull/3685
  // (not yet in stable).
  final ext = isVideo ? 'mp4' : filePath.split('.').last;
  final indexStr = index != null ? '_$index' : '';
  return 'users/$uid/uploads/$timestamp$indexStr.$ext';
}

void showUploadMessage(BuildContext context, String message,
    {bool showLoading = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(),
              ),
            Text(message),
          ],
        ),
      ),
    );
}

Future<String?> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));
  final result = await storageRef.putData(data, metadata);
  return result.state == TaskState.success ? result.ref.getDownloadURL() : null;
}

/// [media] can be on of 'image' or 'video'.
/// [multiImage] is only available when the media source is set to 'image'
Future<List<String>> uploadMedia(
  BuildContext context,
  bool allowPhoto,
  bool allowVideo,
  bool multiImage,
  double maxWidth,
  double maxHeight,
  int imageQuality,
) async {
  print(
    'uploadMedia() called with context: ..., maxWidth: $maxWidth, maxHeight: $maxHeight, imageQuality: $imageQuality, allowPhoto: $allowPhoto',
  );

  final backgroundColor = Theme.of(context).colorScheme.onPrimary;
  final textColor = Theme.of(context).colorScheme.primary;

  /// * Display bottomsheet to choose media source
  final createUploadMediaListTile =
      (String label, MediaSource mediaSource) => ListTile(
            title: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            tileColor: backgroundColor,
            dense: false,
            onTap: () => Navigator.pop(
              context,
              mediaSource,
            ),
          );
  final mediaSource = await showModalBottomSheet<MediaSource>(
      context: context,
      backgroundColor: backgroundColor,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: ListTile(
                  title: Text(
                    'Choose Source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  tileColor: backgroundColor,
                  dense: false,
                ),
              ),
              const Divider(),
            ],
            if (allowPhoto && allowVideo) ...[
              createUploadMediaListTile(
                'Gallery (Photo)',
                MediaSource.photoGallery,
              ),
              const Divider(),
              createUploadMediaListTile(
                'Gallery (Video)',
                MediaSource.videoGallery,
              ),
            ] else if (allowPhoto)
              createUploadMediaListTile(
                'Gallery',
                MediaSource.photoGallery,
              )
            else
              createUploadMediaListTile(
                'Gallery',
                MediaSource.videoGallery,
              ),
            if (!kIsWeb) ...[
              const Divider(),
              createUploadMediaListTile('Camera', MediaSource.camera),
              const Divider(),
            ],
            const SizedBox(height: 10),
          ],
        );
      });
  if (mediaSource == null) {
    // Finished without selecting a media source
    return [];
  }

  /// * Select media from source. It may be a list of images or a single video.
  final List<SelectedMedia>? selectedMedia = await selectMedia(
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
    isVideo: mediaSource == MediaSource.videoGallery ||
        (mediaSource == MediaSource.camera && allowVideo && !allowPhoto),
    mediaSource: mediaSource,
    multiImage: multiImage,
  );
  if (selectedMedia == null) {
    // Finished without selecting a media
    return [];
  }

  if (selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
    showUploadMessage(
      context,
      'Uploading file...',
      showLoading: true,
    );
    final List<String> downloadUrls = List<String>.from((await Future.wait(
            selectedMedia
                .map((m) async => await uploadData(m.storagePath, m.bytes))))
        .where((u) => u != null)
        .map((u) => u!)
        .toList());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (downloadUrls.length == selectedMedia.length) {
      showUploadMessage(
        context,
        'Success!',
      );
      print('---> uploaded $downloadUrls');
      return downloadUrls;
    } else {
      showUploadMessage(
        context,
        'Failed to upload media',
      );
      return [];
    }
  }

  /// * Return empty array if the user cancelled the upload
  /// * Or contains any image/video that has wrong format.
  return [];
}
