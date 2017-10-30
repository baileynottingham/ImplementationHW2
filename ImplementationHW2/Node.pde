/**
 * @description pointer to children, and maintains the region, and maintains line segments.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
public class Node {

  private java.util.List<Node> children = new ArrayList<Node>();
  private Rectangle region = null;
  private java.util.List<LineSegment> lineSegments = new ArrayList<LineSegment>();

  public Node() {
  }

  public java.util.List<Node> getChildren() {
    return children;
  }

  public java.util.List<LineSegment> getLineSegments() {
    return lineSegments;
  }

  public Rectangle getRegion() {
    return region;
  }

  public void setRegion(Rectangle region) {
    this.region = region;
  }

}