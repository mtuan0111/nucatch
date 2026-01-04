import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class TurnRecordedBloc extends Bloc<TurnRecordedEvent, TurnRecordedState> {
  TurnRecordedBloc(super.initialState) {
    on<ShareEvent>(_onShareEventWithScreenShot);
  }

  Future<void> _onShareEventWithScreenShot(
    ShareEvent event,
    Emitter<TurnRecordedState> emitter,
  ) async {
    emitter(state.copyWith(isCapturing: true));

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      // Capture the image from the widget as PNG
      final ByteData imageBytes = await Helper.capture(event.objectKey);

      // Convert ByteData to Uint8List
      final Uint8List pngBytes = imageBytes.buffer.asUint8List();

      // Decode PNG image
      final codec = await instantiateImageCodec(pngBytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      // Convert to PNG without alpha channel (RGB format)
      // Note: Flutter's toByteData doesn't directly support JPEG encoding
      // We'll save as PNG and let the system handle JPEG conversion
      final ByteData? rgbaData = await image.toByteData(
        format: ImageByteFormat.png,
      );

      if (rgbaData == null) {
        throw Exception('Failed to convert image');
      }

      // Save the image file
      final tempDir = await getTemporaryDirectory();
      final fileName = '${state.model.hashCode}.png'; // Changed to PNG
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(rgbaData.buffer.asUint8List());

      final message = "${event.message} ${state.secureLink}";

      // Get screen bounds for iPad share sheet positioning
      const sharePositionOrigin = Rect.fromLTWH(0, 0, 100, 100);

      await Share.shareXFiles(
        [XFile(filePath, name: fileName, mimeType: 'image/png')],
        text: message,
        subject: event.subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      // Optionally handle error, e.g., emit an error state or log
    } finally {
      emitter(state.copyWith(isCapturing: false));
    }
  }
}
