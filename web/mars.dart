import 'dart:html';
import 'world.dart';
import 'dart:async';

World mars;

void main() {
  mars = new World()
    ..Base()
    ..Generate()
    ..Smooth();

  Timer atimer = new Timer.periodic(
      new Duration(milliseconds: 1000), (Timer timer) => drawOverheadView());
}

void drawOverheadView() {
  CanvasElement ca = querySelector("#surface");
  CanvasRenderingContext2D cc = ca.getContext("2d");
  cc.fillStyle = "#000000";

  num h = 0;
  num w = 8;
  for (int x = 0; x < mars.Width; x++) {
    for (int y = 0; y < mars.Length; y++) {
      h = (mars.map_data[x][y]) % 256;
      cc.fillStyle = "rgb($h,0,0)";
      cc.fillRect(x * w, y * w, w, w);
    }
  }

  //Recreate
  mars = new World()
    ..Base()
    ..Generate()
    ..Smooth();
}
