import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaStage extends StatelessWidget {
  const MediaStage({
    super.key,
    required this.onTapRemove,
    required this.name,
    required this.file,
    this.isImage = false,
  });

  final VoidCallback onTapRemove;
  final String name;
  final XFile file;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('🆔 ${file.name}'),
                  const SizedBox(height: 10),
                  Text('📁 ${file.path}'),
                ],
              ),
            ),
            if (isImage)
              Image.file(
                File(file.path),
                fit: BoxFit.cover,
              ),
          ],
        ),
        IconButton(
          color: Colors.orange,
          onPressed: onTapRemove,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
