import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

abstract class TranscriptionState extends Equatable {
  @override
  List<Object> get props => [];
}

class TranscriptionInitial extends TranscriptionState {}

class TranscriptionLoaded extends TranscriptionState {
  final String transcription;
  final bool isListening;
  final List<stt.LocaleName> localeNames;
  final String currentLocaleId;

  TranscriptionLoaded({
    required this.transcription,
    required this.isListening,
    required this.localeNames,
    required this.currentLocaleId,
  });

  TranscriptionLoaded copyWith({
    String? transcription,
    bool? isListening,
    List<stt.LocaleName>? localeNames,
    String? currentLocaleId,
  }) {
    return TranscriptionLoaded(
      transcription: transcription ?? this.transcription,
      isListening: isListening ?? this.isListening,
      localeNames: localeNames ?? this.localeNames,
      currentLocaleId: currentLocaleId ?? this.currentLocaleId,
    );
  }

  @override
  List<Object> get props =>
      [transcription, isListening, localeNames, currentLocaleId];
}

class TranscriptionError extends TranscriptionState {
  final String message;

  TranscriptionError(this.message);

  @override
  List<Object> get props => [message];
}
