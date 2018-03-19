void keyPressed() { 
  if (key == ENTER) {
    datapush();
    exit();
  }
  if (key==TAB) 
    angy+=PI*.5;

  if (key=='p') {
    String path="./data/SC/screenshot"+(int)random(0, 999999)+".jpg";
    save(path);
  }
  if (key == CODED) {     
    if (keyCode == RIGHT) angx-=4*PI/360;
    else if (keyCode == LEFT) angx+=4.0*PI/360;
    else if (keyCode == UP) angy-=4*PI/360;
    else if (keyCode == DOWN)angy+=4.0*PI/360;
  }
}


void datapush() {
  mfile.println("Total number of membrane molecules:  "+f0.size()+"\n"+"TIME:"+nf(t_total, 1, 2));
  mfile.println("\nIndex [area] || ACTIN  || AAL || MME || Fa || Fm");
  for (int j=0; j<f0.size(); j++) {
    int a=call(f0.get(j).pos.x, f0.get(j).pos.y, f0.get(j).pos.z);
    mfile.println(nf(j, 6, 0)+" "+"["+nf(a, 4, 0)+"]||"+"       "+d0[a]+" ||   "+aal.get(j).size()+"||     "+mme.get(j).size()+"|| "+nf(d2[j], 1, 2)+"||"+nf(d1[j], 1, 2));
  }

  afile.println("Total number of F-actin :"+f1.size()+"\n");
  rfile.println("This file is a text file describing data with respect to polymerization of actin molecule.\n");
  for (int i=0; i<f1.size(); i++) {
    PVector ac0 =new PVector();
    PVector ac1=new PVector();
    int att=f1.get(i).att;

    ac0=f1.get(i).lea;
    ac1=f1.get(i).tra;
    afile.println("actin. "+i+"  area. "+att+"  Number of maku in the vicinity. "+d3[att]);
    rfile.println("actin."+i+"(area:"+att+"["+nf(map(d0[att], 0, a_num, 0, 100), 1, 2)+"%])"+" LENGTH:"+ac0.sub(ac1).mag()+" direction:"+ac0.sub(ac1).normalize());
  }
  ffile.println("This file is a text summarizing information for each area.");
  ffile.println("The length of one side of the area  =  "+W/N+".");
  ffile.println("Total number of areas = "+rm+".");
  ffile.println("area index || actin || maku");
  tfile.println("mme"+mme+"lin"+lin);


  for (int q=0; q<are_n; q++) {
    ffile.println("    area"+q+":      "+d0[q]+":    "+d3[q]);
  }
  tfile.flush();
  tfile.close(); 
  mfile.flush();
  mfile.close(); 
  afile.flush();
  afile.close();
  ffile.flush();
  ffile.close();
  rfile.flush();
  rfile.close();
}