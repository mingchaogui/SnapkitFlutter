import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapkit_flutter_platform_interface/snapkit_flutter_platform_interface.dart';

import 'const.dart';
import 'widget/field_prefix_text.dart';
import 'widget/media_stage.dart';

class CreativeKitScreen extends StatefulWidget {
  const CreativeKitScreen({super.key});

  @override
  State<CreativeKitScreen> createState() => _CreativeKitScreenState();
}

class _CreativeKitScreenState extends State<CreativeKitScreen> {
  final TextEditingController _attachmentUrlController =
      TextEditingController(text: 'https://flutter.dev');
  final TextEditingController _captionController =
      TextEditingController(text: 'Send from $kPackageName');

  final ImagePicker _picker = ImagePicker();

  SnapMediaType _mediaType = SnapMediaType.none;
  XFile? _mediaXFile, _stickerXFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creative Kit'),
        actions: <Widget>[
          if (_mediaXFile != null)
            IconButton(
              tooltip: 'Send content',
              onPressed: _onTapShare,
              icon: const Icon(Icons.send),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              controller: _attachmentUrlController,
              prefix: const FieldPrefixText('Attachment'),
            ),
            CupertinoTextField(
              controller: _captionController,
              prefix: const FieldPrefixText('Caption'),
            ),
            if (_mediaXFile != null)
              MediaStage(
                onTapRemove: () {
                  setState(() {
                    _mediaType = SnapMediaType.none;
                    _mediaXFile = null;
                  });
                },
                name: _mediaType.name.toUpperCase(),
                file: _mediaXFile!,
                isImage: _mediaType == SnapMediaType.photo,
              ),
            if (_stickerXFile != null)
              MediaStage(
                onTapRemove: () {
                  setState(() {
                    _stickerXFile = null;
                  });
                },
                name: 'STICKER',
                file: _stickerXFile!,
                isImage: true,
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: 'Pick photo',
            backgroundColor: Colors.black38,
            onPressed: _onTapPickPhoto,
            child: const Icon(Icons.photo),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            tooltip: 'Pick video',
            backgroundColor: Colors.black45,
            onPressed: _onTapPickVideo,
            child: const Icon(Icons.movie),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            tooltip: 'Pick sticker',
            backgroundColor: Colors.black54,
            onPressed: _onTapPickSticker,
            child: const Icon(Icons.emoji_emotions),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            tooltip: 'Live camera',
            backgroundColor: Colors.black87,
            onPressed: _onTapLiveCamera,
            child: const Icon(Icons.camera),
          ),
        ],
      ),
    );
  }

  void _onTapPickPhoto() {
    _picker.pickImage(source: ImageSource.gallery).then((XFile? value) {
      if (value == null) {
        return;
      }
      setState(() {
        _mediaType = SnapMediaType.photo;
        _mediaXFile = value;
      });
    });
  }

  void _onTapPickVideo() {
    _picker.pickVideo(source: ImageSource.gallery).then((XFile? value) {
      if (value == null) {
        return;
      }
      setState(() {
        _mediaType = SnapMediaType.video;
        _mediaXFile = value;
      });
    });
  }

  void _onTapPickSticker() {
    _picker.pickImage(source: ImageSource.gallery).then((XFile? value) {
      if (value == null) {
        return;
      }
      setState(() {
        _stickerXFile = value;
      });
    });
  }

  void _onTapLiveCamera() {
    SnapkitFlutterPlatform.instance.send(mediaType: SnapMediaType.none);
  }

  void _onTapShare() {
    if (_mediaXFile == null) {
      return;
    }
    SnapkitFlutterPlatform.instance
        .send(
      mediaType: _mediaType,
      filePath: _mediaXFile!.path,
      sticker: _stickerXFile != null
          ? SnapSticker(
              filePath: _stickerXFile!.path,
              posX: 0.1,
              posY: 0.1,
              width: 100,
              height: 100,
              rotation: 135,
            )
          : null,
      attachmentUrl: _attachmentUrlController.text.isNotEmpty
          ? _attachmentUrlController.text
          : null,
      caption: _captionController.text,
    )
        .catchError((dynamic error) {
      final SnackBar snackBar = SnackBar(
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
