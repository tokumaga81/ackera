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
    are_n=N*N*sN;
    for (int j=0; j<are_n; j++) 
      f_list.add(new area(m_list, a_list, f_list));
  }

  void count() {
    for (actin x1 : a_list) {
      int index=call(x1.bar.x, x1.bar.y, x1.bar.z);
      f_list.get(index).acn++;
      x1.att=index;
    }

    for (maku x2 : m_list) {
      int index=call(x2.nextpos.x, x2.nextpos.y, x2.nextpos.z);
      f_list.get(index).mcn++;
      x2.att=index;
    }
    for (area x3 : f_list) {
      d0[f_list.indexOf(x3)]=x3.acn;
      d3[f_list.indexOf(x3)]=x3.mcn;
    }
    book(m_list, a_list);
  }
}
