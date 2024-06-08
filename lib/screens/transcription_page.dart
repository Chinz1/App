import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insursight_test_app/bloc/transcription_bloc.dart';
import 'package:insursight_test_app/bloc/transcription_event.dart';
import 'package:insursight_test_app/bloc/transcription_state.dart';

class TranscriptionPage extends StatefulWidget {
  @override
  _TranscriptionPageState createState() => _TranscriptionPageState();
}

class _TranscriptionPageState extends State<TranscriptionPage> {
  late TranscriptionBloc _transcriptionBloc;

  @override
  void initState() {
    super.initState();
    _transcriptionBloc = BlocProvider.of<TranscriptionBloc>(context);
    _transcriptionBloc.add(LoadLanguages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Transcription App'),
      ),
      body: Center(
        child: BlocBuilder<TranscriptionBloc, TranscriptionState>(
          builder: (context, state) {
            if (state is TranscriptionInitial) {
              return const CircularProgressIndicator();
            } else if (state is TranscriptionLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    state.transcription,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: state.currentLocaleId,
                    items: state.localeNames
                        .map((locale) => DropdownMenuItem(
                              value: locale.localeId,
                              child: Text(locale.name),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _transcriptionBloc.add(ChangeLocale(newValue));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          _transcriptionBloc.add(StartListening());
                        },
                        child: Icon(
                            state.isListening ? Icons.mic : Icons.mic_none),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: () {
                          _transcriptionBloc.add(StopListening());
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.stop),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  state.isListening
                      ? const Text(
                          "Listening...",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      : Container(),
                ],
              );
            } else if (state is TranscriptionError) {
              return Text('Error: ${state.message}');
            }
            return Container();
          },
        ),
      ),
    );
  }
}
