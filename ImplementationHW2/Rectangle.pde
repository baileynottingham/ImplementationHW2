
class Rectangle {
   
  private int xmin;
  private int xmax;
  private int ymin;
  private int ymax;
  
  Rectangle(int xmin, int xmax, int ymin, int ymax) {
    this.xmin = xmin;
    this.xmax = xmax;
    this.ymin = ymin;
    this.ymax = ymax;
  }

  public int getXMin() {
    return xmin;
  }

  public int getXMax() {
    return xmax;
  }

  public int getYMin() {
    return ymin;
  }

  public int getYMax() {
    return ymax;
  }

  /**
   * Checks that the line doesn't lay on this region.
   */
  public boolean isDisjoint(LineSegment lineSegment) {
    boolean isAboveTheBottom = lineSegment.getHeight() >= xmin;
    boolean isBelowTheTop = lineSegment.getHeight() <= xmax;
    boolean isWithinLeftBound = (int) lineSegment.getLeftPoint().getX() >= ymin;
    boolean isWithinRightBound = (int) lineSegment.getRightPoint().getX() <= ymax;
    return !isAboveTheBottom || !isBelowTheTop || !isWithinLeftBound || !isWithinRightBound;
  }
}