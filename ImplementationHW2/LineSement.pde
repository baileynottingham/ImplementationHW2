
class LineSegment {
  private Point leftPoint;
  private Point rightPoint;
  private int verticalShift;
  
  LineSegment(int x1, int x2, int y) {
    leftPoint = new Point(Math.min(x1, x2), y);
    rightPoint = new Point(Math.max(x1, x2), y);
    verticalShift = y;
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

  @Override
  public String toString() {
    return getLeftPoint().toString() + " " + getRightPoint();
  }

}