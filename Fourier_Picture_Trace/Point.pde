class Point {
  PVector coords;
  boolean spreadUsed = false;
  boolean used = false;
  
  public Point(float x, float y) {
    coords = new PVector(x, y);
  }
  
  public Point(PVector xy) {
    coords = xy;
  }
  
  void scaleCoords(float imgW, float imgH) {
    coords.x = map(coords.x, 0, imgW, -1, 1);
    coords.y = map(coords.y, 0, imgH, -1, 1);
  }
}
