ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Point> path = new ArrayList<Point>();
ArrayList<Term> terms = new ArrayList<Term>();

float time = 0;
float timeStep = 0.002;
int maxIndex = 600;
int pointsPerFrame = 5;

float scale = 250;

void setup() {
  size(800, 800);
  println("Loading image...");
  PImage img = loadImage("img.png");
  println("Image loaded. Gathering points...");
  ArrayList<Point> inputPoints = getBlackPoints(img);
  println("Points gathered. Generating path...");
  path = getPath(inputPoints);
  println("Path generated. Generating coefficients...");
  terms.add(new Term(0));
  terms.get(0).makeCoefficient(path, img.width, img.height);
  for (int i = 1; i <= maxIndex; i++) {
    Term a = new Term(i);
    Term b = new Term(-i);
    a.makeCoefficient(path, img.width, img.height);
    b.makeCoefficient(path, img.width, img.height);
    terms.add(a);
    terms.add(b);
  }
  println("Coefficients generated.");
  noFill();
  strokeWeight(2);
}

void draw() {
  background(0);
  translate(width/2, height/2);

  noFill();  
  stroke(192, 128);
  strokeWeight(1);
  for (float i = 0; i < pointsPerFrame; i++) {
    ComplexNum c = new ComplexNum(0, 0);
    for (Term t : terms) {
      ComplexNum add = new ComplexNum(scale*cos(t.index*TWO_PI*(time+i/pointsPerFrame*timeStep)), scale*sin(t.index*TWO_PI*(time+i/pointsPerFrame*timeStep)));
      add = multComplex(add, t.c);
      float circDiam = 2 * sqrt(add.real*add.real + add.imag*add.imag);
      if (i==0) {
        ellipse(c.real, c.imag, circDiam, circDiam);
        line(c.real, c.imag, c.real+add.real, c.imag+add.imag);
      }
      c.real += add.real;
      c.imag += add.imag;
    }

    points.add(new PVector(c.real, c.imag));
  }

  rect(-scale, -scale, scale*2, scale*2);
  strokeWeight(2);
  int iMin = max(0, round(points.size()-(pointsPerFrame/timeStep)));
  int iMax = points.size()-1;
  for (int i = iMin; i < iMax; i++) {
    stroke(192, 64, 64, map(i, iMin, iMax, 8, 255));
    line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
  }

  fill(255, 0, 0);
  text(frameRate, -width/2+20, -height/2+20);

  time = (time + timeStep) % 1;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT)
      maxIndex = max(1, maxIndex/2);
    else if (keyCode == RIGHT)
      maxIndex *= 2;
  }
}

ArrayList<Point> getPath(ArrayList<Point> points) {
  ArrayList<Point> path = new ArrayList<Point>();
  ArrayList<Point> stem1 = new ArrayList<Point>();
  ArrayList<Point> stem2 = new ArrayList<Point>();
  stem1.add(points.get(0));
  points.get(0).used = true;
  stem2.add(points.get(1));
  points.get(1).used = true;
  while (stem1.size() + stem2.size() != points.size()) {
    int s1size = stem1.size();
    int s2size = stem2.size();
    for (int i = 0; i < s1size; i++) {
      Point p = stem1.get(i);
      if (!p.spreadUsed) {
        p.spreadUsed = true;
        int indexAbove = indexOfPoint(points, p.coords.x, p.coords.y-1);
        if (indexAbove != -1) {
          Point pAbove = points.get(indexAbove);
          if (!pAbove.used) {
            pAbove.used = true;
            stem1.add(pAbove);
          }
        }
        int indexBelow = indexOfPoint(points, p.coords.x, p.coords.y+1);
        if (indexBelow != -1) {
          Point pBelow = points.get(indexBelow);
          if (!pBelow.used) {
            pBelow.used = true;
            stem1.add(pBelow);
          }
        }
        int indexLeft = indexOfPoint(points, p.coords.x-1, p.coords.y);
        if (indexLeft != -1) {
          Point pLeft = points.get(indexLeft);
          if (!pLeft.used) {
            pLeft.used = true;
            stem1.add(pLeft);
          }
        }
        int indexRight = indexOfPoint(points, p.coords.x+1, p.coords.y);
        if (indexRight != -1) {
          Point pRight = points.get(indexRight);
          if (!pRight.used) {
            pRight.used = true;
            stem1.add(pRight);
          }
        }
      }
    }
    for (int i = 0; i < s2size; i++) {
      Point p = stem2.get(i);
      if (!p.spreadUsed) {
        p.spreadUsed = true;
        int indexAbove = indexOfPoint(points, p.coords.x, p.coords.y-1);
        if (indexAbove != -1) {
          Point pAbove = points.get(indexAbove);
          if (!pAbove.used) {
            pAbove.used = true;
            stem2.add(pAbove);
          }
        }
        int indexBelow = indexOfPoint(points, p.coords.x, p.coords.y+1);
        if (indexBelow != -1) {
          Point pBelow = points.get(indexBelow);
          if (!pBelow.used) {
            pBelow.used = true;
            stem2.add(pBelow);
          }
        }
        int indexLeft = indexOfPoint(points, p.coords.x-1, p.coords.y);
        if (indexLeft != -1) {
          Point pLeft = points.get(indexLeft);
          if (!pLeft.used) {
            pLeft.used = true;
            stem2.add(pLeft);
          }
        }
        int indexRight = indexOfPoint(points, p.coords.x+1, p.coords.y);
        if (indexRight != -1) {
          Point pRight = points.get(indexRight);
          if (!pRight.used) {
            pRight.used = true;
            stem2.add(pRight);
          }
        }
      }
    }
    println(stem1.size()+"   "+stem2.size() + "   " + points.size());
    if (stem1.size() == s1size && stem2.size() == s2size) {
      break;
    }
  }
  path.addAll(stem1);
  for (int i = stem2.size()-1; i >= 0; i--) {
    path.add(stem2.get(i));
  }
  return path;
}

int indexOfPoint(ArrayList<Point> blackPoints, PVector target) {
  for (int i = 0; i < blackPoints.size(); i++) {
    PVector coords = blackPoints.get(i).coords;
    if (coords.equals(target)) {
      return i;
    }
  }
  return -1;
}
int indexOfPoint(ArrayList<Point> blackPoints, float x, float y) {
  return indexOfPoint(blackPoints, new PVector(x, y));
}

ArrayList<Point> getBlackPoints(PImage im) {
  ArrayList<Point> blackPoints = new ArrayList<Point>();
  im.loadPixels();
  for (int i = 0; i < im.pixels.length; i++) {
    if (brightness(im.pixels[i]) <= 32) {
      float pointX = i%im.width;
      float pointY = i/im.width;
      println(pointX + ", " + pointY);
      blackPoints.add(new Point(pointX, pointY));
    }
  }
  return blackPoints;
}
