class Player {
  float x, y, vx, vy;
  float w = 26;
  float h = 32;
  int facing = 1;
  int lives = 3;
  int hurtTimer = 0;
  int fireCooldown = 0;
  boolean onGround = false;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    vx = 0;
    if (keyLeft) {
      vx = -MOVE_SPEED;
      facing = -1;
    }
    if (keyRight) {
      vx = MOVE_SPEED;
      facing = 1;
    }
    vy += GRAVITY;
    if (vy > 16) vy = 16;
    x += vx;
    y += vy;
    x = constrain(x, 18, width - 18 - w);
    if (hurtTimer > 0) hurtTimer--;
    if (fireCooldown > 0) fireCooldown--;
    if (keyFire) tryShoot();
  }

  void tryShoot() {
    if (fireCooldown > 0 || shots == null) return;
    fireCooldown = 16;
    float bx = facing > 0 ? x + w : x - 8;
    shots.add(new Projectile(bx, y + h * 0.45, facing * 8.5));
    playSfx("shot");
  }

  void hurt() {
    lives--;
    hurtTimer = 70;
    vy = -8;
    vx = -facing * 6;
    x += vx * 3;
  }

  boolean landedOn(Platform p) {
    if (vy <= 0) return false;
    float nx = x;
    float ny = y;
    float px = p.x;
    float py = p.y;
    boolean overlapX = nx + w > px && nx < px + p.w;
    boolean feet = ny + h >= py && ny + h <= py + p.h + vy + 4;
    return overlapX && feet;
  }

  boolean hits(Enemy e) {
    return x + w > e.x() && x < e.x() + e.w && y + h > e.y() && y < e.y() + e.h;
  }

  void draw() {
    if (hurtTimer > 0 && (hurtTimer / 4) % 2 == 0) return;
    float cx = x + w * 0.5;
    float cy = y + h * 0.5;
    sketchEllipse(cx, cy + 2, 24, 26, color(92, 186, 92), color(28, 72, 40));
    sketchEllipse(cx - 5, cy - 2, 7, 8, color(250), color(30, 50, 40));
    sketchEllipse(cx + 6, cy - 2, 7, 8, color(250), color(30, 50, 40));
    fill(30);
    noStroke();
    ellipse(cx - 5 + facing, cy - 2, 3.2, 3.2);
    ellipse(cx + 6 + facing, cy - 2, 3.2, 3.2);
    stroke(40, 90, 50);
    strokeWeight(2);
    noFill();
    float ax = cx - 6;
    float ay = y + 2;
    line(ax, ay, ax - 2, ay - 10);
    line(cx + 6, ay, cx + 8, ay - 10);
    fill(70, 200, 90);
    noStroke();
    ellipse(ax - 2, ay - 11, 5, 5);
    ellipse(cx + 8, ay - 11, 5, 5);
    stroke(40, 80, 50);
    strokeWeight(2);
    line(x + 6, y + h - 2, x + 4, y + h + 5);
    line(x + w - 6, y + h - 2, x + w - 3, y + h + 5);
  }
}
