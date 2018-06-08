import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CamereState {
  int number;
  bool pauseState;
  String password;
  String input = "";
  TextEditingController   passwordControler = new TextEditingController();
  VideoPlayerController videoControler;
  bool get unlocked => password == input;
  String get videoUrl => 'https://storage.googleapis.com/escape_game/cameras/camera.$number.mp4';


  CamereState(this.number, this.pauseState, this.password);
}

