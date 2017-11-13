/**
 * Node has a pointer to children, and maintains the region, and maintains
 * line segments.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
public class Node {

  private java.util.List<Node> children;
  private Rectangle region;
  private java.util.List<LineSegment> lineSegments;

  public Node() {
    region = null;
    children = new ArrayList<Node>();
    lineSegments = new ArrayList<LineSegment>();
  }

  public Node(int xmin, int ymin, int xmax, int ymax) {
    this();
    region = new Rectangle(xmin, xmax, ymin, ymax);
  }

  public java.util.List<Node> getChildren() {
    return children;
  }

  public java.util.List<LineSegment> getLineSegments() {
    return lineSegments;
  }

  public void addLineSegment(LineSegment lineSegment) {
    println("Node[ addLineSegment ] (size): "+ lineSegments.size());
    lineSegments.add(lineSegment);
  }

  public Rectangle getRegion() {
    return region;
  }

  public void setRegion(Rectangle region) {
    this.region = region;
  }

  public boolean isLeaf() {
    return children.size() == 0;
  }

  public boolean shouldSplit() {
    return lineSegments.size() > 3;
  }
}
