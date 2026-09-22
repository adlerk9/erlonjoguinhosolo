class Projectile {
  float x, y, vx;
  float r = 5;
  boolean dead = false;

  Projectile(float x, float y, float vx) {
    this.x = x;
    this.y = y;
    this.vx = vx;
  }

  void update() {
    x += vx;
  }

  boolean hits(Enemy e) {
    return x + r > e.x() && x - r < e.x() + e.w && y + r > e.y() && y - r < e.y() + e.h;
  }

  void draw() {
    sketchEllipse(x, y, r * 2, r * 2, color(90, 210, 130), color(30, 80, 50));
  }
}
