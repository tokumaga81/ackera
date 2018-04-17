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
    lie.count();
    for (maku x0 : m_list) x0.update(m_list, m_list.indexOf(x0), a_list);
    for (actin x1 : a_list)   x1.poly(f_list);

    t_total+=dt;
    specify();
    for (area x2 : f_list) {
      x2.mcn=0;
      x2.acn=0;
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
        pLine(i.nextpos, other);
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
