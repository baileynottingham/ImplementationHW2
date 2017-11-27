/**
 * Maintain three integers that represent the rgb value for red, green, and blue.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
public class Color {

  private int red;
  private int green;
  private int blue;

  /**
   * Create a color object with inital values. 
   */
  public Color(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }

  /**
   * get the red value.
   */
  public int getRed() {
    return this.red;
  }

  /**
   * set the red value.
   */
  public void setRed(int r) {
    this.red = r;
  }

  /**
   * get the green value.
   */
  public int getGreen() {
    return this.green;
  }

  /**
   * set the green value.
   */
  public void setGreen(int g) {
    this.green = g;
  }

  /**
   * get the blue value.
   */
  public int getBlue() {
    return this.blue;
  }

  /**
   * set the blue value.
   */
  public void setBlue(int b) {
    this.blue = b;
  }

 /**
  * set the color to black.
  */
  public void setBlack() {
    red = 0;
    green = 0;
    blue = 0;
  }
}