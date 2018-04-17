class actin {
  PVector bar, poi, dir;
  int att;
  int pol_num;

  actin(float x, float y, float z) {
    poi=new PVector(x, y, z);
    dir=dircounter();
    bar =PVector.add(poi, dir);
    att=0;
    pol_num=0;
  }

  void init (ArrayList<actin> f1) {

    for (int i=0; i<a_num; i++) {
      float[] r=new float [3];
      r=Ractin();
      f1.add(new actin(r[0], r[1], r[2]));
    }
  }

  void poly(ArrayList<area> f2) {
    int c=f2.get(att).acn;
    float p=map(c, 0, a_num, 0, 100);
    float fp=1.0;
    float fd=1/c;

    if (p<1.0) reset();
    else {

      if (random(0.0, 100.0)<p*10) {
        float s=p_spe*dt*fp;
        dir.setMag(s+dir.mag());
        bar.set(PVector.add(poi, dir));
        pol_num++;
      }

      if (random(0.0, 100.0)<10/p) {
        PVector e =new PVector();
        e.set(PVector.sub(bar, poi));
        float s=r_spe*dt*fd;
        if (e.mag()>s) {
          e.setMag(s);
          poi.add(e);
          dir.setMag(dir.mag()-e.mag());
        }
      }

      if (bar.y<0.0) reset();
    }
  }


  void reset() {
    float[] b=new float[3];

    b=Ractin();
    poi.set(b[0], b[1], b[2]);
    dir=dircounter();
    bar=PVector.add(poi, dir);
  }
}
