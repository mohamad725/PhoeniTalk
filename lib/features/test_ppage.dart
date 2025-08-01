import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:uniapp/core/services/speech_to_text_service.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  late final SpeechToTextService _speechService;
  bool _isListening = false;
  String _transcript = 'Tap the mic to start';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _speechService = SpeechToTextService(
      deepgram: Deepgram('821d8edffaa235b802b89c1649a285b3b2a34cbc'),
    );
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    try {
      if (_isListening) {
        await _speechService.stopListening();
        setState(() => _isListening = false);
      } else {
        setState(() {
          _isListening = true;
          _transcript = 'Listening...';
          _errorMessage = '';
        });

        final stream = await _speechService.startListening();
        stream?.listen(
          (result) {
            if (result.transcript?.isNotEmpty == true) {
              setState(() => _transcript = result.transcript!);
            }
          },
          onError: (error) {
            setState(() {
              _isListening = false;
              _errorMessage = 'Error: ${error.toString()}';
            });
          },
        );
      }
    } catch (e) {
      setState(() {
        _isListening = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Microphone Permission'),
                      content: const Text(
                        'This app needs microphone permission to work. '
                        'Please grant permission in app settings if denied.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transcript:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _transcript,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _toggleListening,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(_isListening ? Icons.stop : Icons.mic, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              _isListening
                  ? 'Listening... Speak now'
                  : 'Tap to start recording',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
