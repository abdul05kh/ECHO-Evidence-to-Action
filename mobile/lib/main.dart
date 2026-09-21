import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'features/ai/model_adapter.dart';
import 'features/home/home_queue_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate the local model adapter
  final modelAdapter = EchoModelAdapter(
    currentMode: ModelRuntimeMode.prototypeRuntime,
  );

  runApp(EchoApp(modelAdapter: modelAdapter));
}

class EchoApp extends StatelessWidget {
  final ModelAdapter modelAdapter;

  const EchoApp({
    super.key,
    required this.modelAdapter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECHO — Evidence Capture & Handoff Orchestrator',
      debugShowCheckedModeBanner: false,
      theme: EchoTheme.lightTheme,
      home: HomeQueueScreen(modelAdapter: modelAdapter),
    );
  }
}
