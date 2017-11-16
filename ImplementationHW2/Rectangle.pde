
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

  public boolean doesIntersectWith(LineSegment lineSegment) {
    java.awt.Rectangle rect = new java.awt.Rectangle(xmin, ymin, width, height);
    java.awt.geom.Line2D line = new java.awt.geom.Line2D.Double(
                                                                (double)lineSegment.getLeftPoint().getX(),
                                                                (double)lineSegment.getVerticalShift(),
                                                                (double)lineSegment.getRightPoint().getX(),
                                                                (double)lineSegment.getVerticalShift());
    return line.intersects(rect);
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

  public boolean isDisjoint(Rectangle queryDisk) {
    java.awt.Rectangle queryRectangle = new java.awt.Rectangle(
                                                                queryDisk.getXMin(),
                                                                queryDisk.getYMin(),
                                                                queryDisk.getWidth(),
                                                                queryDisk.getHeight());
    java.awt.Rectangle thisRectangle = new java.awt.Rectangle(
                                                              this.xmin,
                                                              this.ymin,
                                                              this.width,
                                                              this.height);
    return !thisRectangle.intersects(queryRectangle);
  }

  public boolean isFullyContained(Rectangle queryDisk) {
    boolean isInLeftBorder = queryDisk.getXMin() <= this.xmin;
    boolean isInRightBorder = queryDisk.getXMax() >= this.xmax;
    boolean isInTopBorder = queryDisk.getYMax() >= this.ymax;
    boolean isInBottomBorder = queryDisk.getYMin() <= this.ymin;
    return isInLeftBorder && isInRightBorder && isInTopBorder && isInBottomBorder;
  }

  @Override
  public String toString() {
    return "xmin: " + xmin + "\txmax:" + xmax + "\t" + "ymin:" + ymin + "\tymax:" + ymax;
  }
}