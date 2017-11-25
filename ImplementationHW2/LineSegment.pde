
class LineSegment {
  private Point leftPoint;
  private Point rightPoint;
  private int verticalShift;
  public boolean reported = false;
  /**
   * I know 'colorObj' is a terrible name, but 
   * it seems like Processing has 'color' as a
   * key word or something and doesn't let me 
   * run the script with 'color' as an instance
   * variable name. Weird stuff.
   */
  private Color colorObj;

  LineSegment(int x1, int x2, int y) {
    leftPoint = new Point(Math.min(x1, x2), y);
    rightPoint = new Point(Math.max(x1, x2), y);
    verticalShift = y;
    colorObj = new Color(0, 0, 0);
  }

  public Point getLeftPoint() {
    return leftPoint;
  }

  public Point getRightPoint() {
    return rightPoint;
  }
  public int getVerticalShift() {
    return verticalShift;
  }

  public int getWeight() {
    return width;
  }


  /**
   * Don't actually try to use the color object when drawing,
   * but get the color, and then access the rbg attibutes of 
   * the object.
   * For example: 'lineSegment.getColor().getRed()'
   *              'lineSegment.getColor().getBlue()'
   *              'lineSegment.getColor().getGreen()'
   */
  public Color getColor() {
    return colorObj;
  }

  public void setColor(Color colorObj) {
    this.colorObj = colorObj;
  }

  public void markReported() {
    reported = true;
  }

  public void unmarkReported() {
    reported = false;
  }

  @Override
    public String toString() {
    return getLeftPoint().toString() + " " + getRightPoint();
  }
}