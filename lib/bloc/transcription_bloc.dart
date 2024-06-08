import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insursight_test_app/bloc/transcription_event.dart';
import 'package:insursight_test_app/bloc/transcription_state.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranscriptionBloc extends Bloc<TranscriptionEvent, TranscriptionState> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  TranscriptionBloc() : super(TranscriptionInitial()) {
    on<LoadLanguages>(_onLoadLanguages);
    on<ChangeLocale>(_onChangeLocale);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<UpdateTranscription>(_onUpdateTranscription);
  }

  Future<void> _onLoadLanguages(
    LoadLanguages event,
    Emitter<TranscriptionState> emit,
  ) async {
    try {
      bool available = await _speech.initialize();
      if (available) {
        var locales = await _speech.locales();
        emit(TranscriptionLoaded(
          transcription: '',
          isListening: false,
          localeNames: locales,
          currentLocaleId: locales.first.localeId,
        ));
      } else {
        emit(TranscriptionError('Speech recognition not available'));
      }
    } catch (e) {
      emit(TranscriptionError('Error loading languages: $e'));
    }
  }

  void _onChangeLocale(
    ChangeLocale event,
    Emitter<TranscriptionState> emit,
  ) {
    if (state is TranscriptionLoaded) {
      final currentState = state as TranscriptionLoaded;
      emit(currentState.copyWith(currentLocaleId: event.newLocaleId));
    }
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (state is TranscriptionLoaded) {
      final currentState = state as TranscriptionLoaded;
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            add(StopListening());
          }
        },
        onError: (val) {
          add(StopListening());
        },
      );
      if (available) {
        _speech.listen(
          onResult: (val) {
            add(UpdateTranscription(val.recognizedWords));
          },
          localeId: currentState.currentLocaleId,
        );
        emit(currentState.copyWith(isListening: true));
      } else {
        emit(TranscriptionError('Error starting speech recognition'));
      }
    }
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<TranscriptionState> emit,
  ) async {
    if (state is TranscriptionLoaded) {
      final currentState = state as TranscriptionLoaded;
      await _speech.stop();
      emit(currentState.copyWith(isListening: false));
    }
  }

  void _onUpdateTranscription(
    UpdateTranscription event,
    Emitter<TranscriptionState> emit,
  ) {
    if (state is TranscriptionLoaded) {
      final currentState = state as TranscriptionLoaded;
      emit(currentState.copyWith(transcription: event.newTranscription));
    }
  }
}
