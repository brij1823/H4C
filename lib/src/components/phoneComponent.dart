import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/components/DialUserPic.dart';
import 'package:flutter_healthcare_app/src/components/dialButton.dart';
import 'package:flutter_healthcare_app/src/components/round_button.dart';
import 'package:flutter_healthcare_app/src/components/size_config.dart';
import 'package:flutter_healthcare_app/src/pages/AnalysisScreen.dart';
import 'package:flutter_healthcare_app/src/pages/IndexPage.dart';

import '../../constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  String _globalText = '';
  double _confidence = 1.0;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
    timer = Timer.periodic(Duration(seconds: 4), (Timer t) => _listen());
  }

  _listen() async {
    _speech.stop();
    print('here');
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatussss: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      this.setState(() {
        _globalText = _globalText + ' ' + _text;
      });
      _speech.stop();
      // _isListening = true;
      // _listen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Brij Patel",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white),
            ),
            Text(
              "Calling…",
              style: TextStyle(color: Colors.white60),
            ),
            VerticalSpacing(),
            DialUserPic(image: "assets/images/calling_face.png"),
            Spacer(),
            Text(
              'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                DialButton(
                  iconSrc: "assets/icons/Icon Mic.svg",
                  text: "Audio",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/icons/Icon Volume.svg",
                  text: "Microphone",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/icons/Icon Video.svg",
                  text: "Video",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IndexPage()),
                    );
                  },
                ),
                DialButton(
                  iconSrc: "assets/icons/Icon Message.svg",
                  text: "Message",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/icons/Icon User.svg",
                  text: "Add contact",
                  press: () {},
                ),
                DialButton(
                  iconSrc: "assets/icons/Icon Voicemail.svg",
                  text: "Voice mail",
                  press: () {},
                ),
              ],
            ),
            VerticalSpacing(),
            RoundedButton(
              iconSrc: "assets/icons/call_end.svg",
              press: () {
                timer.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnalysisScreen(_globalText)),
                );
              },
              color: kRedColor,
              iconColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
