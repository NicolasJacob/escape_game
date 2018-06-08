import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import './common.dart';

class Camera extends StatelessWidget {
  final int number;
  final CamereState cameraState;
  final onChanged;

  Camera(this.cameraState, this.onChanged):
    this.number = cameraState.number;

  getImage() {
   return  cameraState.videoControler.value.initialized && !cameraState.pauseState
              ? AspectRatio(
                  aspectRatio: cameraState.videoControler.value.aspectRatio,
                  child: VideoPlayer(cameraState.videoControler),
                )
              : Image(
                        image: AssetImage("assets/img/camera.$number.jpg"),
                        width: 120.0,
                      );
  }
  @override
  Widget build(BuildContext context) {
    var cameraThumbnail = Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        alignment: FractionalOffset.centerLeft,
        child: Image(
          image: AssetImage("assets/camera.jpg"),
          height: 40.0,
          width: 40.0,
        ));

    final cameraCard = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: cameraState.unlocked
              ? (cameraState.pauseState
                  ? Colors.orange[200]
                  : Colors.greenAccent[200])
              : Colors.grey,
          margin: EdgeInsets.only(left: 46.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                      "Caméra $number " +
                          (cameraState.pauseState
                              ? "(en pause)"
                              : "(en marche)"),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 20.0),
                      child: getImage(),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: cameraState.passwordControler,
                      onChanged: (v) => onChanged(context, number, password: v),
                      decoration: InputDecoration(
                          labelText: "Mot de passe",
                          border: InputBorder.none,
                          hintText: "Mot de passe"),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Mode pause : "),
                        Checkbox(
                            value: cameraState.pauseState,
                            onChanged: (value) =>
                                onChanged(context, number, pauseState: value)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );

    return Container(
     margin: const EdgeInsets.symmetric(
       vertical: 16.0,
       horizontal: 24.0,
     ),
     child: Stack(
       children: <Widget>[
         cameraCard,
         cameraThumbnail,
       ],
     )
   );
  }
}
