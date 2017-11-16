public class Color {
  private int red;
  private int green;
  private int blue;

  public Color(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }

  public int getRed() {
    return this.red;
  }

  public void setRed(int r) {
    this.red = r;
  }

  public int getGreen() {
    return this.green;
  }

  public void setGreen(int g) {
    this.green = g;
  }

  public int getBlue() {
    return this.blue;
  }

  public void setBlue(int b) {
    this.blue = b;
  }

  public void setBlack() {
    red = 0;
    green = 0;
    blue = 0;
  }
}