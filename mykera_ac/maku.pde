//MME ... membrane molecule neighborlist
//AAL ... actin-membrane action list
//The actual number of elementary particles is 10 ^ 14.
class maku {
  PVector pos, vel; // Position vector and speed vector
  int att;

  maku(float x, float y, float z) {
    pos=new PVector(x, y, z);
    pos=new PVector(x, y, z);
    vel=PVector.random3D().setMag(v0);
    att=0;
  }

  // Form the initial state
  void init() {
    float z0=0.0;
    float d=0.0;
    float r=m_size*.5;
    for (float y=0; y<y_max; y+=dy) {
      for (float x=0; x<m_size; x+=dx) {
        z0=abs(sqrt(r*r-(x-r)*(x-r)));
        f0.add(new maku(x, y, z0));
        f0.add(new maku(x, y, -z0));
      }
    }
    for (float x=0; x<m_size; x+=dx) {
      float z1=abs(sqrt(r*r-(x-r)*(x-r)));
      for (float a=-z1; a<z1; a+=dx) { 
        f0.add(new maku(x, 0, a));
        f0.add(new maku(x, y_max, a));
      }
    }
    m_num=f0.size();
    for (int p=0; p<m_num; p++) {
      ArrayList <Integer> itf = new ArrayList();
      ArrayList <Integer> line = new ArrayList();
      ArrayList <Float> nla = new ArrayList();
      for (int q=0; q<m_num; q++) {
        d=PVector.dist(f0.get(p).pos, f0.get(q).pos);

        if (dx*sqrt(2.0)>=d&&d>0) {
          //  if (abs(f0.get(p).pos.z-f0.get(q).pos.z)<15.0) {
          itf.add(q);
          line.add(q);
          nla.add(d);
          if (p>q) check(p, q);
        }
        // }
      }
      mme.put(p, itf);
      lin.put(p, line);
      nlm.put(p, nla);
    }
    book(f0, f1);
  }

  void check(int p, int q) {
    ArrayList<Integer> io=new ArrayList();
    io=lin.get(q);
    for (int i=0; i<io.size(); i++) {
      if (io.get(i)==p) {
        io.remove(i);
        break;
      }
    }
  }

  //Update the position according to the equation of motion
  void update(ArrayList<maku> P, int j, ArrayList<actin> A) {
    float[] k1=new float[6];
    float[] k2=new float[6];
    float[] k3=new float[6];
    float[] k4=new float[6];
    PVector f=new PVector();

    f.set(spring(P, j))
      .add(foractin(A, j)); //apply_Force

    k1[0]=f(f.x, vel.x)*dt;
    k1[1]=f(f.y, vel.y)*dt;
    k1[2]=f(f.z, vel.z)*dt;
    k1[3]=g(vel.x)*dt;
    k1[4]=g(vel.y)*dt;
    k1[5]=g(vel.z)*dt;

    k2[0]=f(f.x, vel.x+k1[0]*.5)*dt;
    k2[1]=f(f.y, vel.y+k1[1]*.5)*dt;
    k2[2]=f(f.z, vel.z+k1[2]*.5)*dt;
    k2[3]=g(vel.x+k1[0]*.5)*dt;
    k2[4]=g(vel.y+k1[1]*.5)*dt;
    k2[5]=g(vel.z+k1[2]*.5)*dt;

    k3[0]=f(f.x, vel.x+k2[0]*.5)*dt;
    k3[1]=f(f.y, vel.y+k2[1]*.5)*dt;
    k3[2]=f(f.z, vel.z+k2[2]*.5)*dt;
    k3[3]=g(vel.x+k2[0]*.5)*dt;
    k3[4]=g(vel.y+k2[1]*.5)*dt;
    k3[5]=g(vel.z+k2[2]*.5)*dt;

    k4[0]=f(f.x, vel.x+k3[0])*dt;
    k4[1]=f(f.y, vel.y+k3[1])*dt;
    k4[2]=f(f.z, vel.z+k3[2])*dt;
    k4[3]=g(vel.x+k3[0])*dt;
    k4[4]=g(vel.y+k3[1])*dt;
    k4[5]=g(vel.z+k3[2])*dt;

    vel.x+=( k1[0] + 2.0*k2[0] + 2.0*k3[0] + k4[0] )/6.0;
    vel.y+=( k1[1] + 2.0*k2[1] + 2.0*k3[1] + k4[1] )/6.0;
    vel.z+=( k1[2] + 2.0*k2[2] + 2.0*k3[2] + k4[2] )/6.0;
    pos.x+=( k1[3] + 2.0*k2[3] + 2.0*k3[3] + k4[3] )/6.0;
    // pos.y+=( k1[4] + 2.0*k2[4] + 2.0*k3[4] + k4[4] )/6.0;
    pos.z+=( k1[5] + 2.0*k2[5] + 2.0*k3[5] + k4[5] )/6.0;

    if (pos.y<0) pos.y=0.0;
  }

  float f(float f, float v) {
    float vis=1.0*pow(10.0, -3.7);//[kg/(m*s)]
    float m_mass=12.3*pow(10.0, -2.4); //[kg]

    return ((f-vis*v)/m_mass);
  }
  float g(float v) { //Differense of x
    return v;
  }

  // Interaction force //
  PVector spring(ArrayList<maku> M, int q) {
    PVector spr=new PVector();
    ArrayList<Integer> fds=mme.get(q);
    float k=1.0;
    for (int i=0; i<fds.size(); i++) {
      PVector other=new PVector(M.get(fds.get(i)).pos.x, M.get(fds.get(i)).pos.y, M.get(fds.get(i)).pos.z);
      PVector l=new PVector();
      PVector x=new PVector();
      float nl=nlm.get(q).get(i);

      x.set(PVector.sub(pos, other));
      if (x.mag()-nl==0.0) {
        strokeWeight(10.0);
        //  point(pos.x, pos.y, pos.z);
      }
      l.set(x)
        .setMag(nl);//Natural length
      spr.add(PVector.sub(x, l).mult(-k)); //Spring constant
    }
    d1[q]=spr.mag();
    return spr;
  }

  // Repulsive power with actin //
  PVector foractin(ArrayList<actin> A, int j) {
    PVector ans=new PVector(0, 0, 0);
    ArrayList<Integer> mem=aal.get(j);

    for (int p=0; p<mem.size(); p++) {
      PVector other=new PVector(A.get(mem.get(p)).bar.x, A.get(mem.get(p)).bar.y, A.get(mem.get(p)).bar.z);
      PVector r=new PVector();
      float x=0.0;
      float s=70.0;

      r.set(PVector.sub(pos, other));
      x=r.mag()*r.mag();
      r.normalize()
        .mult(s/x);
      ans.add(r);
    }
    d2[j]=ans.mag();
    return ans;
  }
}
