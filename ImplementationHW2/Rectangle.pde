
class Rectangle {
   
  private int xmin;
  private int xmax;
  private int ymin;
  private int ymax;
  private int width;
  private int height;

  Rectangle(int xmin, int xmax, int ymin, int ymax) {
    this.xmin = xmin;
    this.xmax = xmax;
    this.ymin = ymin;
    this.ymax = ymax;
    this.width = xmax - xmin;
    this.height = ymax - ymin;
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

  public int getHeight() {
    return height;
  }

  public int getWidth() {
    return width;
  }

  /**
   * Checks that the line doesn't lay on this region.
   */
  public boolean isDisjoint(LineSegment lineSegment) {
    boolean isAboveTheBottom = lineSegment.getVerticalShift() >= ymin;
    boolean isBelowTheTop = lineSegment.getVerticalShift() <= ymax;
    boolean isWithinLeftBound = (int)lineSegment.getLeftPoint().getX() >= xmin;
    boolean isWithinRightBound = (int)lineSegment.getRightPoint().getX() <= xmax;
    // boolean leftHanging = isWithinRightBound && isAboveTheBottom && isBelowTheTop;
    // boolean righHanging = isWithinLeftBound && isAboveTheBottom && isBelowTheTop;
    // boolean fullyInRegion = isWithinLeftBound && isWithinRightBound && isAboveTheBottom && isBelowTheTop;
    // so line would be in the region if it is left hanging or right hanging or fully enclosed...
    // so negate that statement.
    return !isAboveTheBottom || !isBelowTheTop || !isWithinLeftBound || !isWithinRightBound;
  }

  @Override
  public String toString() {
    return "xmin: " + xmin + "\txmax:" + xmax + "\t" + "ymin:" + ymin + "\tymax:" + ymax;
  }
}