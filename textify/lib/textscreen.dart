import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'constants.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SpeechToText _words;
  bool _activate=false;
  String message ="Un-mute and start speaking";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _words=SpeechToText();
  }
  void listening() async {
    if (!_activate) {
      bool available = await _words.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _activate = true);
        _words.listen(
          onResult: (val) => setState(() {
            message = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _activate = false);
      _words.stop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EAED),
      appBar: AppBar(
        backgroundColor: Color(0xFF16235A),
        centerTitle: true,
        title: Text('textify', style: titleText,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _activate,
        glowColor: Color(0xFF16235A),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed:listening,
          backgroundColor: Color(0xFF16235A),
          child: Icon( _activate? Icons.mic:Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              padding: EdgeInsets.fromLTRB(10,10,10, 150),
              child: Center(child: SelectableText(message,style: mainText,))
          ),
        ),
      ),
    );
  }
}
