class Platform {
  float x, y, w, h, vx;

  Platform(float x, float y, float w, float h, float vx) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.vx = vx;
  }

  void update() {
    if (vx == 0) return;
    x += vx;
    if (x < 24 || x + w > width - 24) {
      vx *= -1;
      x = constrain(x, 24, width - 24 - w);
    }
  }

  void draw() {
    int fillC = vx == 0 ? color(210, 186, 140) : color(186, 210, 170);
    sketchRect(x, y, w, h, fillC, color(70, 55, 40));
    stroke(90, 70, 45, 120);
    strokeWeight(1);
    line(x + 6, y + 5, x + w - 6, y + 5);
  }
}
