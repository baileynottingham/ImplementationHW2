
/**
 * Maintains its region and is able to determine what lay and doesn't lay inside it's region.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
class Rectangle {

  private int xmin;
  private int xmax;
  private int ymin;
  private int ymax;
  private int width;
  private int height;

  /**
   * Constructs a rectangle with the given coordinates. 
   */
  Rectangle(int xmin, int xmax, int ymin, int ymax) {
    this.xmin = xmin;
    this.xmax = xmax;
    this.ymin = ymin;
    this.ymax = ymax;
    this.width = xmax - xmin;
    this.height = ymax - ymin;
  }

  /**
   * Get the minimum x value.
   */
  public int getXMin() {
    return xmin;
  }

  /**
   * Get the maximum x value. 
   */
  public int getXMax() {
    return xmax;
  }

  /**
   * Get the minimum y value.
   */
  public int getYMin() {
    return ymin;
  }

  /**
   * Get the maximum y value. 
   */
  public int getYMax() {
    return ymax;
  }

  /**
   * Get the height of this rectangle.
   */
  public int getHeight() {
    return height;
  }

  /**
   * Get the width of this rectangle.
   */
  public int getWidth() {
    return width;
  }

  /**
   * Determines if the line intersects with this region.
   */
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

  /**
   * Determines if the query disk is dijoint from this region.
   */
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

  /**
   * Determines if this region is completely inside the query region.
   */
  public boolean isFullyContained(Rectangle queryDisk) {
    boolean isInLeftBorder = queryDisk.getXMin() <= this.xmin;
    boolean isInRightBorder = queryDisk.getXMax() >= this.xmax;
    boolean isInTopBorder = queryDisk.getYMax() >= this.ymax;
    boolean isInBottomBorder = queryDisk.getYMin() <= this.ymin;
    return isInLeftBorder && isInRightBorder && isInTopBorder && isInBottomBorder;
  }

  /**
   * Determines if the query disk is inside the node's region.
   */
  public boolean containsRect(Rectangle queryDisk) {
    java.awt.Rectangle thisRectangle = new java.awt.Rectangle(
      this.xmin, 
      this.ymin, 
      this.width, 
      this.height);
    java.awt.Rectangle queryRectangle = new java.awt.Rectangle(
      queryDisk.getXMin(), 
      queryDisk.getYMin(), 
      queryDisk.getWidth(), 
      queryDisk.getHeight());
    return thisRectangle.contains(queryRectangle);
  }

  /**
   * Determines if the point is inside the node's region.
   */
  public boolean containsPoint(int x, int y) {
    java.awt.Rectangle thisRectangle = new java.awt.Rectangle(
      this.xmin, 
      this.ymin, 
      this.width, 
      this.height);
    java.awt.Point pt = new java.awt.Point(x, y);
    return thisRectangle.contains(pt);
  }

  /**
   * The string representation of the object.
   */
  @Override
    public String toString() {
    return "xmin: " + xmin + "\txmax:" + xmax + "\t" + "ymin:" + ymin + "\tymax:" + ymax;
  }
}