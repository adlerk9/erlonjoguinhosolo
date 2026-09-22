import javax.sound.sampled.*;

void playSfx(String id) {
  if (id.equals("jump")) blip(new int[] { 720 }, new int[] { 55 });
  else if (id.equals("shot")) blip(new int[] { 980, 640 }, new int[] { 35, 40 });
  else if (id.equals("hit")) blip(new int[] { 520, 780 }, new int[] { 45, 70 });
  else if (id.equals("hurt")) blip(new int[] { 400, 240 }, new int[] { 80, 120 });
  else if (id.equals("over")) blip(new int[] { 300, 220, 160 }, new int[] { 140, 140, 220 });
  else if (id.equals("record")) blip(new int[] { 523, 659, 784, 1046 }, new int[] { 90, 90, 90, 160 });
}

void blip(final int[] hz, final int[] ms) {
  Thread t = new Thread(new Runnable() {
    public void run() {
      for (int i = 0; i < hz.length; i++) {
        squareTone(hz[i], ms[i]);
      }
    }
  });
  t.setDaemon(true);
  t.start();
}

void squareTone(int freq, int millis) {
  float sr = 22050;
  int n = (int) (sr * millis / 1000f);
  byte[] buf = new byte[n];
  for (int i = 0; i < n; i++) {
    float t = i / sr;
    float s = (Math.sin(2 * Math.PI * freq * t) > 0) ? 0.12f : -0.12f;
    float env = 1 - (i / (float) n);
    int v = (int) (s * env * 127);
    if (v > 127) v = 127;
    if (v < -127) v = -127;
    buf[i] = (byte) v;
  }
  try {
    AudioFormat fmt = new AudioFormat(sr, 8, 1, true, false);
    SourceDataLine line = AudioSystem.getSourceDataLine(fmt);
    line.open(fmt, n);
    line.start();
    line.write(buf, 0, n);
    line.drain();
    line.stop();
    line.close();
  } catch (Exception ex) {
  }
}
