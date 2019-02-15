// In this class, we manage and control actin class and membrane class.
class adm extends Kernel {
  ArrayList <maku> m_list; // Membrane molecule List
  ArrayList <actin> a_list; // Actin List
  ArrayList <area> f_list; // Area info.

  adm(ArrayList <maku> x, ArrayList <actin> y, ArrayList<area> z) {
    m_list = x;
    a_list = y;
    f_list = z;
  }

  @Override
    void run() {
    //MEMBRANE-cal
    lie.count();
    for (maku x0 : m_list) {
      if (x0.pos.x<minx) {
        minx=x0.pos.x;
        mini=m_list.indexOf(x0);
      }
      if (x0.pos.x>maxx) {
        maxx=x0.pos.x;
        maxi=m_list.indexOf(x0);
      }
      x0.update(m_list, m_list.indexOf(x0), a_list);
      if (x0.pos.y>y_max*(1/4)&&x0.pos.y<y_max*(3/4)) {
        if (x0.pos.x>(maxx-minx)/2.0)  ym.add(m_list.indexOf(x0));
      }
      if (x0.pos.x>(maxx-minx)*(0.85/5.0)&&x0.pos.x<(maxx-minx)*(1.15/5.0)) {
        if (x0.pos.z>165) fsp.add(m_list.indexOf(x0));
        if (x0.pos.z<-165) fsn.add(m_list.indexOf(x0));
      }
    }

    //F-ACTIN-cal
    if (dly%15==0) { 
      for (actin x1 : a_list) {
        if (x1.bar.x>pm) {
          dpm=.5*(x1.bar.x-pm);
          pm=x1.bar.x;
          m2+=dpm;
        }
        x1.poly();
      }
    }
    dly++;
    t_total+=dt;
    specify();
    dpm=0.0;

    //AREA-cal
    for (area x2 : f_list) {
      if (maxaa<x2.acn) {
        maxaa=x2.acn;
        maxai=f_list.indexOf(x2);
      }
      x2.mcn=0;
      x2.acn=0;
    }
    ym.clear();
    if (t_total>at) {
      saveFrame("./frame/#####.tif");
      at+=4.0;
      if (t_total>17.0) exit();
    }
  }

  void specify() {
    int k=0;
    int u=0;
    for (maku i : m_list) {
      int j=aal.get(m_list.indexOf(i)).size();
      ArrayList<Integer> s=new ArrayList();
      float red=0.0;
      float green=255.0;

      k=m_list.indexOf(i);
      s=lin.get(k);
      strokeWeight(.5);
      //to draw line
      stroke(red+j*j, green-j*j, 65);
      for (int h=0; h<s.size(); h++) {
        PVector other =new PVector();
        other =m_list.get(s.get(h)).pos;
        pLine(i.pos, other);
      }
    }

    for (actin c : a_list) {
      u=a_list.indexOf(c);
      stroke(229, 0, 11);
      strokeWeight(1.0);
      pLine(a_list.get(u).bar, a_list.get(u).poi);
      stroke(255);
      strokeWeight(3.0);
      point(a_list.get(u).bar.x, a_list.get(u).bar.y, a_list.get(u).bar.z);
    }
  }
}
