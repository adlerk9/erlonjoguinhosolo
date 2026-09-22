void drawNotebook() {
  background(245, 236, 214);
  stroke(210, 80, 80, 140);
  strokeWeight(2);
  line(48, 0, 48, height);
  stroke(170, 196, 220, 160);
  strokeWeight(1);
  for (int y = 28; y < height; y += 28) {
    line(0, y, width, y);
  }
  noStroke();
  fill(220, 70, 70, 40);
  ellipse(28, 70, 14, 14);
  ellipse(28, 210, 14, 14);
  ellipse(28, 350, 14, 14);
  ellipse(28, 490, 14, 14);
  ellipse(28, 630, 14, 14);
}

float wob(float x, float y, int i) {
  return (noise(x * 0.031, y * 0.031, i * 1.7) - 0.5) * 3.4;
}

void sketchRect(float x, float y, float w, float h, int fillC, int strokeC) {
  fill(fillC);
  stroke(strokeC);
  strokeWeight(1.7);
  beginShape();
  vertex(x + wob(x, y, 0), y + wob(x, y, 1));
  vertex(x + w + wob(x + w, y, 2), y + wob(x + w, y, 3));
  vertex(x + w + wob(x + w, y + h, 4), y + h + wob(x + w, y + h, 5));
  vertex(x + wob(x, y + h, 6), y + h + wob(x, y + h, 7));
  endShape(CLOSE);
}

void sketchEllipse(float cx, float cy, float w, float h, int fillC, int strokeC) {
  fill(fillC);
  stroke(strokeC);
  strokeWeight(1.6);
  beginShape();
  int n = 12;
  for (int i = 0; i < n; i++) {
    float a = TWO_PI * i / n;
    float px = cx + cos(a) * w * 0.5 + wob(cx + i, cy, i);
    float py = cy + sin(a) * h * 0.5 + wob(cx, cy + i, i + 3);
    vertex(px, py);
  }
  endShape(CLOSE);
}

void drawPaperCard(float x, float y, float w, float h) {
  sketchRect(x + 3, y + 4, w, h, color(230, 220, 195, 220), color(120, 100, 80, 80));
  sketchRect(x, y, w, h, color(252, 248, 235, 235), color(70, 55, 40));
}

void drawTape(float x, float y, float w, float h) {
  drawPaperCard(x, y, w, h);
  fill(236, 214, 120, 180);
  noStroke();
  rect(x + 18, y - 8, 46, 16, 2);
  rect(x + w - 64, y + h - 8, 46, 16, 2);
}
