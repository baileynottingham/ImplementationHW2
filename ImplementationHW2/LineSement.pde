
class LineSegment {
  private Point leftPoint;
  private Point rightPoint;
  private int height;
  
  LineSegment(int x1, int x2, int y) {
    leftPoint = new Point(Math.min(x1, x2), y);
    rightPoint = new Point(Math.max(x1, x2), y);
    height = y;
  }

  public Point getLeftPoint() {
    return leftPoint;
  }

  public Point getRightPoint() {
    return rightPoint;
  }
  public int getHeight() {
    return height;
  }

  @Override
  public String toString() {
    return getLeftPoint().toString() + " " + getRightPoint();
  }

}