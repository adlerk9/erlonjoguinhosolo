// Alien Paper Climb — Processing 4
// Endless climber no estilo caderno.

final int STATE_MENU = 0;
final int STATE_PLAY = 1;
final int STATE_OVER = 2;

final float GRAVITY = 0.52;
final float JUMP_V = -13.2;
final float MOVE_SPEED = 4.15;

int state = STATE_MENU;
Player player;
ArrayList<Platform> platforms;
ArrayList<Enemy> enemies;
ArrayList<Projectile> shots;

float camY;
float spawnY;
float highestPlatformY;
int score;
int highScore;
int maxHeightPx;
boolean newRecord;
String overReason = "";
boolean keyLeft, keyRight, keyFire;
int paperSeed = 7;
int jumpSfxWait = 0;

void setup() {
  size(480, 720);
  noiseSeed(paperSeed);
  textFont(createFont("Georgia", 16, true));
}

void draw() {
  drawNotebook();
  if (state == STATE_MENU) {
    drawTitleDecor();
    drawMenu();
  } else if (state == STATE_PLAY) {
    updatePlay();
    drawWorld();
    drawHud();
  } else {
    drawWorld();
    drawHud();
    drawGameOver();
  }
}

void startGame() {
  platforms = new ArrayList<Platform>();
  enemies = new ArrayList<Enemy>();
  shots = new ArrayList<Projectile>();
  score = 0;
  maxHeightPx = 0;
  newRecord = false;
  overReason = "";
  spawnY = height - 90;
  player = new Player(width * 0.5, spawnY - 36);
  platforms.add(new Platform(width * 0.5 - 70, spawnY, 140, 16, 0));
  highestPlatformY = spawnY;
  for (int i = 0; i < 14; i++) {
    spawnNextPlatform();
  }
  camY = player.y - height * 0.62;
  state = STATE_PLAY;
}

void spawnNextPlatform() {
  float gap = random(68, 98);
  highestPlatformY -= gap;
  float w = random(64, 130);
  float x = random(36, width - 36 - w);
  float vx = 0;
  if (random(1) < 0.24) {
    vx = random(1.1, 2.0) * (random(1) < 0.5 ? -1 : 1);
  }
  Platform p = new Platform(x, highestPlatformY, w, 14, vx);
  platforms.add(p);
  if (w > 78 && random(1) < 0.32) {
    enemies.add(new Enemy(p));
  }
}

void updatePlay() {
  if (jumpSfxWait > 0) jumpSfxWait--;
  player.update();
  for (Platform p : platforms) p.update();
  for (Enemy e : enemies) e.update();

  for (int i = shots.size() - 1; i >= 0; i--) {
    Projectile b = shots.get(i);
    b.update();
    if (b.dead || b.x < -40 || b.x > width + 40) {
      shots.remove(i);
      continue;
    }
    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);
      if (b.hits(e)) {
        shots.remove(i);
        enemies.remove(j);
        playSfx("hit");
        break;
      }
    }
  }

  resolvePlayerPlatforms();
  resolvePlayerEnemies();

  float climbed = spawnY - player.y;
  if (climbed > maxHeightPx) {
    maxHeightPx = int(climbed);
    score = maxHeightPx;
  }

  float targetCam = player.y - height * 0.62;
  if (targetCam < camY) camY = lerp(camY, targetCam, 0.18);

  while (highestPlatformY > camY - 80) {
    spawnNextPlatform();
  }
  cullBelow();

  if (player.y > camY + height + 48) {
    gameOver("Caiu da folha");
  }
}

void resolvePlayerPlatforms() {
  player.onGround = false;
  for (Platform p : platforms) {
    if (player.landedOn(p)) {
      player.y = p.y - player.h;
      player.vy = JUMP_V;
      player.onGround = true;
      if (jumpSfxWait <= 0) {
        playSfx("jump");
        jumpSfxWait = 8;
      }
    }
  }
}

void resolvePlayerEnemies() {
  if (player.hurtTimer > 0) return;
  for (Enemy e : enemies) {
    if (player.hits(e)) {
      player.hurt();
      playSfx("hurt");
      if (player.lives <= 0) {
        gameOver("Sem vidas");
      }
      break;
    }
  }
}

void cullBelow() {
  float cut = camY + height + 160;
  for (int i = platforms.size() - 1; i >= 0; i--) {
    if (platforms.get(i).y > cut) platforms.remove(i);
  }
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    if (e.home.y > cut || !platforms.contains(e.home)) enemies.remove(i);
  }
}

void gameOver(String reason) {
  if (state != STATE_PLAY) return;
  overReason = reason;
  if (score > highScore) {
    highScore = score;
    newRecord = true;
    playSfx("record");
  } else {
    playSfx("over");
  }
  state = STATE_OVER;
}

void drawWorld() {
  pushMatrix();
  translate(0, -camY);
  for (Platform p : platforms) p.draw();
  for (Enemy e : enemies) e.draw();
  for (Projectile b : shots) b.draw();
  if (player != null) player.draw();
  popMatrix();
}

void drawTitleDecor() {
  Player dummy = new Player(width * 0.5, 250);
  dummy.facing = 1;
  dummy.draw();
  Platform sample = new Platform(width * 0.5 - 50, 286, 100, 14, 0);
  sample.draw();
}

void drawMenu() {
  drawTape(70, 40, 340, 86);
  fill(40, 55, 90);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Alien Paper Climb", width * 0.5, 72);
  textSize(13);
  fill(70, 80, 110);
  text("subida vertical no caderno", width * 0.5, 102);

  drawPaperCard(60, 430, 360, 230);
  fill(45, 50, 70);
  textAlign(LEFT, TOP);
  textSize(15);
  float tx = 88;
  float ty = 452;
  text("Controles", tx, ty);
  textSize(13);
  text("A / ←    esquerda", tx, ty + 32);
  text("D / →    direita", tx, ty + 54);
  text("Espaço   disparar", tx, ty + 76);
  text("Pulo     automático nas plataformas", tx, ty + 98);

  textAlign(CENTER);
  textSize(16);
  fill(30, 90, 55);
  text("Enter — começar", width * 0.5, 620);
  textSize(11);
  fill(90);
  text("Dupla: preencher nomes no itch.io", width * 0.5, 644);
}

void drawHud() {
  drawPaperCard(10, 10, 168, 78);
  fill(40, 50, 70);
  textAlign(LEFT, TOP);
  textSize(13);
  text("Vidas  " + hearts(player.lives), 22, 20);
  text("Altura  " + maxHeightPx + " px", 22, 42);
  text("Recorde " + highScore, 22, 64);
}

String hearts(int n) {
  String s = "";
  for (int i = 0; i < 3; i++) s += (i < n) ? "• " : "○ ";
  return s;
}

void drawGameOver() {
  drawTape(50, 250, 380, 200);
  fill(50, 40, 70);
  textAlign(CENTER, CENTER);
  textSize(26);
  text("Game Over", width * 0.5, 290);
  textSize(14);
  fill(70, 60, 90);
  text(overReason, width * 0.5, 324);
  text("Pontuação  " + score, width * 0.5, 356);
  text("Recorde    " + highScore, width * 0.5, 378);
  if (newRecord) {
    fill(30, 110, 60);
    text("Novo recorde!", width * 0.5, 404);
  }
  fill(40);
  text("Enter — outra folha", width * 0.5, 428);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) keyLeft = true;
    if (keyCode == RIGHT) keyRight = true;
  }
  if (key == 'a' || key == 'A') keyLeft = true;
  if (key == 'd' || key == 'D') keyRight = true;
  if (key == ' ') keyFire = true;
  if (key == ENTER || key == RETURN) {
    if (state == STATE_MENU || state == STATE_OVER) startGame();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) keyLeft = false;
    if (keyCode == RIGHT) keyRight = false;
  }
  if (key == 'a' || key == 'A') keyLeft = false;
  if (key == 'd' || key == 'D') keyRight = false;
  if (key == ' ') keyFire = false;
}
