class actin {
  PVector lea, tra, var; // Leading edge, trailing edge and a vector that increases with time.
  int att;

  actin(float x, float y, float z) {
    tra=new PVector(x, y, z);
    var=PVector.random3D().normalize();
    lea =new PVector(x, y, z);
    att=0;
  }

  void init (ArrayList<actin> f1) {

    for (int i=0; i<a_num; i++) {
      float[] r=new float [3];
      r=Ractin();
      f1.add(new actin(r[0], r[1], r[2]));
    }

    lea.add(var);
  }

  void poly(ArrayList<area> f2) {
    int c=f2.get(att).acn;
    float p=map(c, 0, a_num, 0, 100); 

    if (p<2.2) reset();
    else {
      if (random(0.0, 100.0)<p*10) {
        float s=p_spe*dt;
        s*=pow(c, 1.5);
        var.add(var.setMag(s));
        lea.set(PVector.add(tra, var));
      }

      if (random(0.0, 100.0)<p*10) {
        PVector e =new PVector();
        e.set(PVector.sub(lea, tra));
        float s=r_spe*dt;
        s/=pow(c, 1.5);
        if (e.mag()>s) {
          e.setMag(s);
          tra.add(e);
          var.setMag(var.mag()-e.mag());
        } else reset();
      }
      if (lea.y<0.0) reset();
    }
    if (lea.mag()-tra.mag()==0.0) reset();
  }


  void reset() {
    float[] b=new float[3];
    PVector cy=new PVector(0, 1, 0);
    float j=-1.0;

    b=Ractin();
    tra.set(b[0], b[1], b[2]);
    lea.set(tra.add(var));

    while (0.0>j&&j>0.2) {
      var=PVector.random3D().normalize();
      j=abs(PVector.dot(var, cy));
    }
  }
}