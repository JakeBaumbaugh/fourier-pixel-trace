class Term {

  int index;
  ComplexNum c;

  public Term(int ind) {
    index = ind;
  }

  void makeCoefficient(ArrayList<Point> path) {
    c = new ComplexNum(0, 0);
    for (int u=0; u<path.size(); u++) {
      float theta = -TWO_PI*index*u/path.size();
      ComplexNum func = new ComplexNum(path.get(u).coords.x, path.get(u).coords.y);
      ComplexNum eTerm = new ComplexNum(cos(theta), sin(theta));
      ComplexNum sumTerm = multComplex((float)1/path.size(), multComplex(func, eTerm));
      c.addSelf(sumTerm);
    }
  }
}
