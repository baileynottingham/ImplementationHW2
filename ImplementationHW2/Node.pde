

public class Node {
  private java.util.List<Node> children;
  private Rectangle region;
  private java.util.List<LineSegment> lineSegments;
  public Node() {
    children = new ArrayList<Node>();
    lineSegments = new ArrayList<LineSegment>();
  }

}