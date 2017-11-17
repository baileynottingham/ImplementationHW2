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
  private SplitRegion splitRegion;
  private int height;

  public Node() {
    region = null;
    children = new ArrayList<Node>();
    lineSegments = new ArrayList<LineSegment>();
  }

  public Node(Rectangle region, SplitRegion splitRegion, int height) {
    this();
    this.region = region;
    this.splitRegion = splitRegion;
    this.height = height;
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

  public void setSplitRegion(SplitRegion splitRegion) {
    this.splitRegion = splitRegion;
  }

  public SplitRegion getSplitRegion() {
    return splitRegion;
  }

  public int getHeight() {
    return this.height;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  public boolean isLeaf() {
    return children.size() == 0;
  }

  public boolean shouldSplit() {
    return lineSegments.size() > 3;
  }
}
