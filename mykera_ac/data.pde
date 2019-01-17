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
  // maku
  mfile.println("Total number of membrane molecules:  "+f0.size()+"\n"+"TIME:"+nf(t_total, 1, 2)+"\n"+"realtime:"+millis()+" ms");
  mfile.println("\nIndex [area] || ACTIN   || AAL||   MME || Fa || Fm");
  for (int j=0; j<f0.size(); j++) {
    int b=f0.get(j).att;
    mfile.println(nf(j, 6, 0)+" "+"["+nf(b, 4, 0)+"]||"+"       "+d0[b]+" ||   "+aal.get(j).size()+"||     "+mme.get(j).size()+"|| "+nf(d2[j], 2, 7)+"||"+nf(d1[j], 2, 7));
  }

  //actin and polymerazation
  afile.println("Total number of F-actin :"+f1.size()+"\n");
  rfile.println("This file is a text file describing data with respect to polymerization of actin molecule.\n");
  for (int i=0; i<f1.size(); i++) {
    PVector ac0 =new PVector();
    PVector ac1=new PVector();
    float ac2=0.0;
    int att=f1.get(i).att;

    ac0=f1.get(i).bar;
    ac1=f1.get(i).poi;
    ac2=f1.get(i).pol_num;

    afile.println("actin. "+i+"  poi="+ac1+"bar="+ac0+"  area. "+att+"  Number of maku in the vicinity. "+d3[att]+"\n"+" poly"+ac2/(t_total/dt)*100+"%");
    rfile.println("actin."+i+"(area:"+att+"["+nf(map(d0[att], 0, a_num, 0, 100), 1, 2)+"%])"+" LENGTH:"+ac0.sub(ac1).mag()+" direction:"+ac0.sub(ac1));
  }

  // field
  ffile.println("This file is a text summarizing information for each area.");
  ffile.println("Total number of areas = "+f2.size()+".");
  ffile.println("area index || actin || maku");
  tfile.println("mme"+mme+"\n lin"+lin);

  for (int q=0; q<f0.size(); q++) {
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
