import 'dart:math';

/***
 * Simple terrain generator inspired by:
 * http://en.wikipedia.org/wiki/Diamond-square_algorithm
 */
class World {
  int Width = 64;
  int Length = 64;
  Random rng = new Random();
  int Iterations = 6;
  List map_data = [];

  ///Ctor
  World() {
    Reset();
  }

  ///Creates a flat land.
  void Reset() {
    var row = [];

    for (int y = 0; y < Length; y++) {
      row = [];
      for (int x = 0; x < Width; x++) {
        row.add(0);
      }
      map_data.add(row);
    }
  }

  /// Starting point - random terrain.
  /// Some of the magic numbers in here should be configurable.
  void Base() {
    for (int y = 0; y < Length; y++) {
      for (int x = 0; x < Width; x++) {
        map_data[x][y] = rng.nextInt(55) + 200;
      }
    }
  }

  /// This method performs the random midpoint displacement.
  void SetCorners(int x, int y, int w, int h, [List v = null]) {
    if (w < 1) return;

    if (v != null) {
      map_data[x][y] = v[0];
      map_data[x + w][y] = v[1];
      map_data[x][y + h] = v[2];
      map_data[x + w][y + h] = v[3];
    }

    int hw = (w / 2).floor();
    int hh = (h / 2).floor();
    int total = map_data[x][y] +
        map_data[x + w][y] +
        map_data[x][y + h] +
        map_data[x + w][y + h] +
        rng.nextInt(4 + h) +
        4;

    map_data[x + hw][y + hh] = (total / 4.0).floor();

    ///Subdivide
    SetCorners(x, y, hw, hh);
    SetCorners(x + hw, y, hw, hh);
    SetCorners(x, y + hh, hw, hh);
    SetCorners(x + hw, y + hh, hw, hh);
  }

  /// This is where the real terrain is formed.
  /// Some of the magic numbers in here should be configurable.
  void Generate() {
    int w = Width - 1;
    int h = Length - 1;
    SetCorners(0, 0, w, h, [155, 155, 155, 155]);
    SetCorners(rng.nextInt(5) + 14, 0, 15, 15);
  }

  /// Smooth out the terrain for a more natural look.
  void Smooth() {
    int average = 0;
    for (int yl = 1; yl < (Length - 1); yl++) {
      for (int xl = 1; xl < (Width - 1); xl++) {
        average = (1.1 *
                ((map_data[xl][yl] +
                        map_data[xl + 1][yl] +
                        map_data[xl][yl + 1] +
                        map_data[xl + 1][yl + 1]) /
                    4))
            .floor();
        map_data[xl][yl] = average;
        map_data[xl + 1][yl] = average;
        map_data[xl + 1][yl + 1] = average;
        map_data[xl][yl + 1] = average;
        map_data[xl - 1][yl] = average;
        map_data[xl - 1][yl - 1] = average;
        map_data[xl][yl - 1] = average;
      } //x loop
    } //y loop
  }
}
