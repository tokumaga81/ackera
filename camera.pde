void controllcamera() {

  camera(
    mouseX, mouseY, 0.0, 
    m_size*.5, 0, -  300.0, 
    0.0, 0.0, 1.0);

  showxyz();
}

void showxyz() {
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  text(nf(mouseX, 1, 3)+","+nf(mouseY, 1, 3), mouseX, mouseY);
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}
