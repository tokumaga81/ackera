// The variables etc ...//
import java.util.*;
import com.amd.aparapi.*;

ArrayList<maku> f0=new ArrayList<maku>();
ArrayList<actin> f1=new ArrayList<actin>();
ArrayList<area> f2=new ArrayList<area>();

actin decoy =new actin(0, 0, 0);
maku fake = new maku(0, 0, 0);
area lie =new area(f0, f1, f2);
adm kera=new adm(f0, f1, f2);
float v0=100.0;
float m_size =500.0; //*20 scale ...30 [micro meter]
float y_max =20.0;
float dx=m_size/30.0;
float dy=y_max/2.0;
Map<Integer, ArrayList<Integer>> mme=new HashMap<Integer, ArrayList<Integer>>();
Map<Integer, ArrayList<Integer>> aal=new HashMap<Integer, ArrayList<Integer>>();
Map<Integer, ArrayList<Integer>> lin=new HashMap<Integer, ArrayList<Integer>>();
float t_total=0.0;
float as=m_size*2.0;
int N =13;
int W =1000;
float y0=y_max;
// Variables related to FILE output //
PrintWriter mfile;
PrintWriter afile;
PrintWriter rfile;
PrintWriter ffile;
PrintWriter tfile;

// Variables of membrane molecule motion relation //
float dt=.001;

// Variables on actin polymerization //
int a_num=3000;
float p_spe=4.0;  
float r_spe=4.0;
//Variables on priparation
float angy=-PI*1.5;
float angx=0.0;
//Variables on data
int rm=(int)(W+m_size)/(W/N)*N*N+(int)W/(height/N)*N+(int)W/(W/N);
int d0[]=new int[rm];
int d3[]=new int[rm];
int are_n;
int m_num;
float[] d1=new float[10000];
float[] d2=new float[10000];
int u=0;

void setup() {
  size(1000, 750, P3D);
  mfile = createWriter("./data/maku.txt");
  afile = createWriter("./data/actin.txt");
  rfile = createWriter("./data/poly.txt"); 
  ffile = createWriter("./data/area.txt");
  tfile = createWriter("./data/test.txt");

  decoy.init(f1);
  fake.init(f0, f1);
  lie.init();
}
void draw() {
  preparation();
  kera.run();
  u++;
  if (u%25==0) saveFrame("./frame/#####.tif");
}

void preparation() {
  float y=0.0;
  int p1=1000;

  background(51, 51, 51);
  translate(width/4.0, height/2.0, -100);
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
  showText3d();
}

//============   TOOL  ===================
void pLine(PVector a, PVector b) {
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

int call(float x, float y, float z) {
  int i=(int)x/(W/N);
  int j=(int)y/(height/N);
  int u=(int)(z+m_size)/(W/N);
  return u*N*N+j*N+i;
}

float[] Ractin() {
  float dr =m_size*3/8;
  float r=m_size/2.5;
  float[] ans=new float[3];

  dr=0;
  while ((ans[0]-m_size/2)*(ans[0]-m_size/2) +ans[2]*ans[2] <= (r*.5)*(r*.5)|| (ans[0]-m_size/2)*(ans[0]-m_size/2) +ans[2]*ans[2] >= r*r) {
    ans[0]=random(dr, m_size*7/8);
    ans[1]=random(y_max/15, y_max*1/3);
    ans[2]=random(-m_size*3/4, m_size*3/4);
  }

  return(ans);
}

void showText3d() {
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  text("TIME:"+nf(t_total, 1, 3)+"", 20, 20);
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}
//================================================