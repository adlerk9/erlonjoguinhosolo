class Enemy {
  Platform home;
  float offset;
  float dir = 1;
  float speed = 1.15;
  float w = 22;
  float h = 18;

  Enemy(Platform home) {
    this.home = home;
    this.offset = random(4, max(4, home.w - w - 4));
    if (random(1) < 0.5) dir = -1;
  }

  float x() {
    return home.x + offset;
  }

  float y() {
    return home.y - h;
  }

  void update() {
    offset += dir * speed;
    if (offset < 2) {
      offset = 2;
      dir = 1;
    }
    if (offset > home.w - w - 2) {
      offset = home.w - w - 2;
      dir = -1;
    }
  }

  void draw() {
    float cx = x() + w * 0.5;
    float cy = y() + h * 0.5;
    sketchEllipse(cx, cy, 22, 16, color(232, 118, 96), color(90, 40, 36));
    fill(40);
    noStroke();
    ellipse(cx - 4, cy - 2, 3, 4);
    ellipse(cx + 4, cy - 2, 3, 4);
    stroke(90, 40, 36);
    strokeWeight(1.6);
    line(cx - 8, cy - 8, cx - 5, cy - 4);
    line(cx + 8, cy - 8, cx + 5, cy - 4);
  }
}
