import 'dart:io';
import 'dart:typed_data';

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
      // Capture the image from the widget
      final ByteData imageBytes = await Helper.capture(event.objectKey);
      final tempDir = await getTemporaryDirectory();
      final fileName = '${state.model.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes.buffer.asUint8List());

      final message = "${event.message} ${state.secureLink}";
      await Share.shareXFiles(
        [XFile(filePath, name: fileName)],
        text: message,
        subject: event.subject,
      );
    } catch (e) {
      // Optionally handle error, e.g., emit an error state or log
    } finally {
      emitter(state.copyWith(isCapturing: false));
    }
  }
}
