class area {
  int acn;
  int mcn;

  ArrayList <maku> m_list; // Membrane molecule List
  ArrayList <actin> a_list; // Actin List
  ArrayList <area> f_list; //field infomation

  area(ArrayList <maku> x, ArrayList <actin> y, ArrayList<area> z) {
    acn=0;
    mcn=0;
    m_list = x;
    a_list = y;
    f_list = z;
  }

  void init() {
    are_n=call(W, W, W);
    for (int j=0; j<are_n; j++) 
      f_list.add(new area(m_list, a_list, f_list));
  }

  void count() {
    for (actin x1 : a_list) {
      int index=call(x1.lea.x, x1.lea.y, x1.lea.z);
      f_list.get(index).acn++;
      x1.att=index;
    }

    for (maku x2 : m_list) {
      int index=call(x2.damy.x, x2.damy.y, x2.damy.z);
      f_list.get(index).mcn++;
      x2.att=index;
      if (x2.pos.y>y0) y0=x2.pos.y;
    }
    for (area x3 : f_list) {
      d0[f_list.indexOf(x3)]=x3.acn;
      d3[f_list.indexOf(x3)]=x3.mcn;
    }
  }
}