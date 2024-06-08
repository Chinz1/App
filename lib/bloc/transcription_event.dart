import 'package:equatable/equatable.dart';

abstract class TranscriptionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadLanguages extends TranscriptionEvent {}

class ChangeLocale extends TranscriptionEvent {
  final String newLocaleId;

  ChangeLocale(this.newLocaleId);

  @override
  List<Object> get props => [newLocaleId];
}

class StartListening extends TranscriptionEvent {}

class StopListening extends TranscriptionEvent {}

class UpdateTranscription extends TranscriptionEvent {
  final String newTranscription;

  UpdateTranscription(this.newTranscription);

  @override
  List<Object> get props => [newTranscription];
}
