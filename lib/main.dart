import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import './camera.dart';
import './common.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Surveillance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Video Surveillance'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<CamereState> cameraStates = [
  CamereState(1, false, '7'),
  CamereState(2, false, '95'),
  CamereState(3, false, '13'),
  CamereState(4, false, '22'),
];


class _MyHomePageState extends State<MyHomePage> {
  bool isPlaying;

  @override
  void initState() {
    super.initState();
    cameraStates.forEach((camera) {
      camera.videoControler = VideoPlayerController.network(
      camera.videoUrl,
    );

    camera.videoControler..addListener(() {
       bool isPlaying = camera.videoControler.value.isPlaying;

       print("${camera.number} playing $isPlaying");

    })
    ..initialize()
    .then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          camera.videoControler.setLooping(true);

          camera.videoControler.play();

        });
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Align(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("Entrer le mot de passe pour controler une caméra."),
                ],
              ),
            ),
            Camera(cameraStates[0], cameraStateChanged),
            Camera(cameraStates[1], cameraStateChanged),
            Camera(cameraStates[2], cameraStateChanged),
            Camera(cameraStates[3], cameraStateChanged),
          ],
        ),
      ),
    );
  }

  cameraStateChanged(context, int number, {bool pauseState, String password}) {
    var index = number -1;
    var cameraState = cameraStates[index];
    setState(() {
      if (password != null) {
        print("Changing password");
        cameraState.input = password;
      }
      if (pauseState != null) {
        print("Changing pauseState");
        if (cameraState.unlocked) {
          cameraState.pauseState = pauseState;
          if (cameraStates.any((x) => !x.pauseState)) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(!pauseState
                    ? "Caméra $number activée"
                    : "Caméra  $number desactivée")));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Surveillance désactivée. Attention la maison n'est plus surveillée"),
                duration: Duration(
                  seconds: 15,
                )));
          }
        } else {
          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text("Mauvais mot de passe")));
        }
      }
    });
  }
}
