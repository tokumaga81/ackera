//MME ... membrane molecule neighborlist
//AAL ... actin-membrane action list

class maku {
  PVector pos, vel; // Position vector and speed vector
  PVector damy;
  int att;

  maku(float x, float y, float z) {
    att=0;
    pos=new PVector(x, y, z);
    damy=new PVector(x, y, z);
    vel=PVector.random3D().setMag(v0);
  }

  // Form the initial state
  void init(ArrayList<maku> f0, ArrayList<actin> f1) {
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
      for (int q=0; q<m_num; q++) {
        d=PVector.dist(f0.get(p).pos, f0.get(q).pos);
        if (dx+dx*.3>=d&&d>0) {
          itf.add(q);
          line.add(q);
          if (p>q) {
            check(p, q);
          }
        }
      }
      mme.put(p, itf);
      lin.put(p, line);
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

  void book(ArrayList<maku> f0, ArrayList<actin> f1) {   
    float g=0.0;

    for (maku x : f0) {
      ArrayList<Integer> bbb=new ArrayList();
      for (actin y : f1) {
        g=PVector.dist(x.pos, y.lea);
        if (g<y_max*.5) bbb.add(f1.indexOf(y));
      }
      aal.put(f0.indexOf(x), bbb);
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
    pos.set(damy);

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
    damy.x+=( k1[3] + 2.0*k2[3] + 2.0*k3[3] + k4[3] )/6.0;
    damy.y+=( k1[4] + 2.0*k2[4] + 2.0*k3[4] + k4[4] )/6.0;
    damy.z+=( k1[5] + 2.0*k2[5] + 2.0*k3[5] + k4[5] )/6.0;
    //torus-area
    if (damy.y<0) damy.y=0.0;
    if (damy.x>as) damy.x-=as*2.0;
    if (damy.y>as) damy.y-=as*2.0;
    if (damy.z>as*.5) damy.z-=as;
  }

  float f(float f, float v) { //Differense of v
    float vis=3.5;
    float m_mass=.5;

    return ((f-vis*v)/m_mass);
  }
  float g(float v) { //Differense of x
    return v;
  }

  // Interaction force //
  PVector spring(ArrayList<maku> M, int q) {
    PVector spr=new PVector();
    ArrayList<Integer> fds=mme.get(q);
    float k=50.0;

    for (int i=0; i<fds.size(); i++) {
      PVector other=new PVector(M.get(fds.get(i)).pos.x, M.get(fds.get(i)).pos.y, M.get(fds.get(i)).pos.z);
      PVector l=new PVector();
      PVector x=new PVector();

      x.set(PVector.sub(pos, other));
      l.set(x)
        .setMag(dx);//Natural length
      spr.add(PVector.sub(x, l).mult(-k)); //Spring constant
    }
    d1[q]=spr.mag();
    return spr;
  }

  // Repulsive power with actin //
  PVector foractin(ArrayList<actin> A, int j) {
    PVector ans=new PVector(0, 0, 0);
    ArrayList<Integer> mem =aal.get(j);

    for (int p=0; p<mem.size(); p++) {
      PVector other=new PVector(A.get(mem.get(p)).lea.x, A.get(mem.get(p)).lea.y, A.get(mem.get(p)).lea.z);
      PVector r=new PVector();
      float x;
      float a=m_size/3000;
      float s=215.0;

      r.set(PVector.sub(pos, other));
      x=r.mag();
      if (x<a) x+=a;
      r.normalize()
        .mult(s/(x-a));
      ans.add(r);
    }
    d2[j]=ans.mag();
    return ans;
  }
}