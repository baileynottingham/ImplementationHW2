
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
    java.awt.Rectangle rect = new java.awt.Rectangle(xmin, ymin, width, height);
    java.awt.geom.Line2D line = new java.awt.geom.Line2D.Double(
                                                                (double)lineSegment.getLeftPoint().getX(),
                                                                (double)lineSegment.getVerticalShift(),
                                                                (double)lineSegment.getRightPoint().getX(),
                                                                (double)lineSegment.getVerticalShift());
    return !line.intersects(rect);
  }

  @Override
  public String toString() {
    return "xmin: " + xmin + "\txmax:" + xmax + "\t" + "ymin:" + ymin + "\tymax:" + ymax;
  }
}