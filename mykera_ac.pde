// The diriables etc ...//
import java.util.*;
import com.amd.aparapi.*;
import processing.opengl.*;

ArrayList<maku> f0=new ArrayList<maku>();
ArrayList<actin> f1=new ArrayList<actin>();
ArrayList<area> f2=new ArrayList<area>();

actin decoy =new actin(0, 0, 0);
maku fake = new maku(0, 0, 0);
area lie =new area(f0, f1, f2);
adm kera=new adm(f0, f1, f2);
float v0=pow(10.0, -4);//[m/s]
float m_size =500.0; //[mm]
float y_max =30.0;
float dx=m_size/30.0;
float dy=y_max/5.0;


Map<Integer, ArrayList<Integer>> mme=new HashMap<Integer, ArrayList<Integer>>();
Map<Integer, ArrayList<Integer>> aal=new HashMap<Integer, ArrayList<Integer>>();
Map<Integer, ArrayList<Integer>> lin=new HashMap<Integer, ArrayList<Integer>>();
float t_total=0.0;
int sN=4;
int N =30;
int W =(int)(m_size*2.0);
int[] top=new int[(N-2)];
int[] lef=new int[(N-2)];
int[] rig=new int[(N-2)];
int[] bot=new int[(N-2)];
int[] cor=new int[4];
int sss=0;
float minx=100.0;
int mini=320;
float maxx=m_size;
int maxi=3322;
float maxaa=0.0;
int maxai=310;
float pm=400.0;
float dpm=0.0;
float m2=m_size/2.0;

// diriables related to FILE output //
PrintWriter mfile;
PrintWriter afile;
PrintWriter rfile;
PrintWriter ffile;
PrintWriter tfile;

// diriables of membrane molecule motion relation //
float dt=.001;

// diriables on actin polymerization //
int a_num=1400;
float p_spe=20.0;  
float r_spe=20.0;
//diriables on priparation
float angy=-PI*1.5;
float angx=0.0;
//diriables on data
int rm=10000;
//int rm=(int)(W+m_size)/(W/N)*N*N+(int)W/(int(y_max)*3/sN)*N+(int)W/(W/N);
int d0[]=new int[rm];
int d3[]=new int[rm];
int m_num;
float[] d1=new float[10000];
float[] d2=new float[10000];
int str=0;
int dly=0;
ArrayList <Integer> ym = new ArrayList();

void setup() {
  size(800, 800, OPENGL);
  mfile = createWriter("./data/maku.txt");
  afile = createWriter("./data/actin.txt");
  rfile = createWriter("./data/poly.txt"); 
  ffile = createWriter("./data/area.txt");
  tfile = createWriter("./data/test.txt");
  decoy.init();
  fake.init();
  lie.init();
}
void draw() {
  preparation();
  kera.run();
  str++;
  if (str%10==0) saveFrame("./frame/#####.tif");
}

void preparation() {
  float y=0.0;
  int p1=1000;

  background(51, 51, 51);
  translate(width/4.0, height/2.0, -750);
  rotateX(angy);  
  rotateY(angx);
  strokeWeight(4.0);
  for (int i=-p1; i<=p1; i++) {
    y=map(i, -p1, p1, 0, 255);
    stroke(y);
    point(i, 0, 0);
    stroke(y, 0, 0);
    point(0, i, 0);
    stroke(y, y, 0);
    point(0, 0, i);
    //=========AXIS COLORS============
    // -- x ... white
    // -- y ... red
    // -- z ... yellow
    //================================
  }
  stroke(227.0);
  strokeWeight(10.0);
  point(0, 0, 0);
  for (float j=0; j<W; j+=W/N) {
    stroke(229);
    strokeWeight(1.0);
    line(j, 0, -W/2, j, 0, W/2);
    line(0, 0, j-W/2, W, 0, j-W/2);
  }
  showText3d();
}

//============   TOOL  ===================
void pLine(PVector a, PVector b) {
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

int call(float x, float y, float z) {
  int i=(int)x/(W/N);
  int j=(int)y/(int)(y_max*3/sN);
  int u=(int)(z+W/2)/(W/N);
  return j*N*N+u*N+i;
}

float[] recall(int d) {
  float ans[]=new float[3];

  for (int i=0; i<N; i++) {
    for (int u=0; u<N; u++) {
      if (u*N+i == d) {
        ans[0]=i;
        ans[1]=0;
        ans[2]=u;
      }
    }
  }
  return ans;
}

float[] Sactin() {
  float ri=185.0;
  float ro=200.0;
  float[] ans=new float[3];
  ans[0]=-1;
  ans[1]=-1;
  ans[2]=-1;

  while ((ans[0]-m2)*(ans[0]-m2) +ans[2]*ans[2] >=ro*ro|| (ans[0]-m2)*(ans[0]-m2) +ans[2]*ans[2] <= ri*ri) {
    ans[0]=random(m2, 2.0*m2*9.5/10);
    ans[1]=random(y_max/15, y_max*1/3);
    ans[2]=random(-2.0*m2*9.5/10, 2.0*m2*9.5/10);
  }
  return(ans);
}

float[] Ractin() {
  float[] ans =new float [3];
  float dr =m_size*3/8;  
  float r1=230;
  float r2=170;

  while ((ans[0]-m2)*(ans[0]-m2) +ans[2]*ans[2] <= r2*r2|| (ans[0]-m2)*(ans[0]-m2) +ans[2]*ans[2] >= r1*r1) {
    ans[0]=random(dr, m_size);
    ans[1]=random(y_max/15, y_max*1/3);
    ans[2]=random(-m_size*3/4, m_size*3/4);
  }

  return(ans);
}

PVector dircounter() {
  PVector cy=new PVector(0, 1, 0);
  PVector x=PVector.random3D().normalize();
  float j=abs(PVector.dot(x, cy));

  while (j>0.2) {
    x=PVector.random3D().normalize();
    j=abs(PVector.dot(x, cy));
  }
  return(x);
}

void book(ArrayList<maku> f0, ArrayList<actin> f1) {
  for (maku x : f0) {
    ArrayList<Integer> bbb=new ArrayList();
    for (actin y : f1) {
      if (y.att==x.att) {
        bbb.add(f1.indexOf(y));
      }
    }
    aal.put(f0.indexOf(x), bbb);
  }
}

boolean linecorss(PVector a) {
  boolean ans=false;

  if (a.x<(maxx-minx))
    ans=true;

  return ans;
}

void box_reg() {
  int i=0;
  int j=0;
  int k=0;
  int h=0;
  int p=0;

  for (int u=0; u<4; u+=2) {
    cor[u]=h*N*(N-1);
    cor[u+1]=(h*N+1)*(N-1);
    h++;
  }
  for (i=0; i<N-2; i++)  top[i]=i+1;
  for (j=0; j<N-2; j++) {
    lef[j]=N*(j+1);
    rig[j]=N*(j+2)-1;
  }
  for (p=0; p<N-2; p++) {
    bot[p]=N*(N-1)+k;
    k++;
  }
}

void showText3d() {
  textFont(createFont("Nina", 15));
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  text("TIME: "+nf(t_total, 1, 3)+"", 20, 20);
  text("Pnumber: "+f0.size(), 20, 45);
  text("Anumber: "+f1.size(), 20, 70);
  text(f2.size()+" area: "+N+"×"+sN+"×"+N, 20, 95);
  text("areascale "+"\n"+"="+W/N+"[mm] ×"+y_max*3/sN+"[mm] ×"+W/N+"[mm]", 20, 120);
  textFont(createFont("Nina", 15));
  text("[REAL TIME] : "+millis()+" ms ", 20, 780);

  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}
//================================================
