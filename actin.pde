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

  void init () {
    box_reg();

    for (int i=0; i<a_num; i++) {
      float[] r=new float [3];
      r=Ractin();
      f1.add(new actin(r[0], r[1], r[2]));
    }
  }

  void poly() {
    int c=f2.get(att).acn;
    float p=0.0;
    float fp=5.0;
    float fd=5.0;
    float rc=2.5;
    boolean ft=true;
    boolean fl=true;
    boolean fr=true;
    boolean fb=true;
    boolean fc=true;

    for (int g=0; g<(N-2); g++) {
      if (att==top[g])ft=false;
      if (att==lef[g])fl=false;
      if (att==rig[g])fr=false;
      if (att==bot[g])fb=false;
    }
    for (int j=0; j<4; j++) if (att==cor[j]) fc=false;

    if (fl==true&&fc==true) 
      c+=f2.get(att-1).acn;

    if (ft==true&&fc==true) 
      c+=f2.get(att-N).acn;

    if (fr==true&&fc==true) 
      c+=f2.get(att+1).acn;

    if (fb==true&&fc==true) 
      c+=f2.get(att+N).acn;

    if (fc==false)println("This is corner!!");

    if (ft==true&&fl==true&&fc==true) 
      c+=f2.get(att-(N+1)).acn;

    if (fl==true&&fb==true&&fc==true) 
      c+=f2.get(att+(N-1)).acn;

    if (fb==true&&fr==true&&fc==true) 
      c+=f2.get(att+(N+1)).acn;

    if (fr==true&&ft==true&&fc==true) 
      c+=f2.get(att-(N-1)).acn;

    p=map(c, 0, a_num, 0, 100);
    fp*=exp(p*0.1);
    if (p<rc) reset();
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
        } else reset();
      }
      if (bar.y<0.0) reset();
    }
    arf();
  }

  void arf() {
    PVector b=new PVector(f0.get(mini).pos.x, f0.get(mini).pos.y, f0.get(mini).pos.z);
    PVector e1=new PVector(0, 0, 0);
    PVector e2=new PVector(0, 0, 0);
    float d4 =0.0;
    float d8 =0.0;
    e1.set(PVector.sub(bar, b));
    d4=e1.mag();
    e2.set(PVector.sub(poi, b));
    d8=e2.mag();
    e1.setMag(36/d4);
    e2.setMag(36/d8);
    bar.sub(e1);
    poi.sub(e2);
  }

  void reset() {
    int a=ym.size();
    if (a>0) {
      int b=(int)random(0, a);
      int i =ym.get(b);
      PVector tar=f0.get(i).nextpos;
      PVector e=new PVector();
      PVector ne =new PVector();

      e.set((maxx-minx)*.5, 15.0, 0);
      ne.set(PVector.sub(tar, e))
        .mult(0.9);
      ne.set(PVector.add(e, ne));
      poi.set(ne);
      dir=dircounter();
      bar=PVector.add(poi, dir);
    }
  }
}
