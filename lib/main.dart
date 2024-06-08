import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insursight_test_app/bloc/transcription_bloc.dart';
import 'package:insursight_test_app/screens/transcription_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranscriptionBloc(),
      child: MaterialApp(
        title: 'Voice Transcription App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TranscriptionPage(),
      ),
    );
  }
}
