

public class Node {
  private java.util.List<Node> children = new ArrayList<Node>();
  private Rectangle region = null;
  private java.util.List<LineSegment> lineSegments = new ArrayList<LineSegment>();
  public Node() {
  }

  public java.util.List<Node> getChildren() {
    return children;
  }

  public java.util.List<LineSegment> getSegments() {
    return lineSegments;
  }

  public Rectangle getRegion() {
    return region;
  }

}