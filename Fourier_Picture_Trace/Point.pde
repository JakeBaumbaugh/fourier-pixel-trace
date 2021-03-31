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
}
