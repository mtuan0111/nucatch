import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_event.dart';
import 'package:nucatch/blocs/objects/turnRecorded/turn_recorded_state.dart';
import 'package:share_plus/share_plus.dart';

class TurnRecordedBloc extends Bloc<TurnRecordedEvent, TurnRecordedState> {
  TurnRecordedBloc(super.initialState) {
    on<ShareEvent>(_onShareEvent);
  }

  Future<void> _onShareEvent(
    ShareEvent event,
    Emitter<TurnRecordedState> emitter,
  ) async {
    await Share.share(
      event.message + dotenv.env['PROFILE_URL']!,
      subject: event.subject,
      // sharePositionOrigin: Rect.fromLTWH(
      //   0,
      //   0,
      //   event.objectKey?.currentContext?.size?.width ?? 200,
      //   event.objectKey?.currentContext?.size?.height ?? 200,
      // ),
    );

    return;
  }
}
