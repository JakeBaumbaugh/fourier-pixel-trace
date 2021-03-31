class ComplexNum {
  float real;
  float imag;
  
  public ComplexNum(float a, float b) {
    real = a;
    imag = b;
  }
}

public ComplexNum addComplex (ComplexNum c1, ComplexNum c2) {
  return new ComplexNum(c1.real+c2.real, c1.imag+c2.imag);
}

public ComplexNum subComplex (ComplexNum c1, ComplexNum c2) {
  return new ComplexNum(c1.real-c2.real, c1.imag-c2.imag);
}

public ComplexNum multComplex (ComplexNum c1, ComplexNum c2) {
  return new ComplexNum(c1.real*c2.real-c1.imag*c2.imag, c1.real*c2.imag+c1.imag*c2.real);
}

public ComplexNum multComplex (float n, ComplexNum c) {
  return new ComplexNum(n*c.real, n*c.imag);
}
