/**
 * Node has a pointer to children, and maintains the region, and maintains
 * line segments.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
public class Node {

  public java.util.List<Node> children = new ArrayList<Node>();
  private Rectangle region;
  public java.util.List<LineSegment> lineSegments = new ArrayList<LineSegment>();
  private SplitRegion splitRegion;
  private int height;
  public boolean reported = false;

  /**
   * Constructs a node that is defined by the region, where in the graph it is,
   * and it's height relative to the root.
   */
  public Node(Rectangle region, SplitRegion splitRegion, int height) {
    this.region = region;
    this.splitRegion = splitRegion;
    this.height = height;
  }

  /**
   * Returns the children of the node. The list will either be
   * of size (meaning the node is a leaf),
   * or four (meaning the node is an internal node).
   */
  public java.util.List<Node> getChildren() {
    return children;
  }

  /**
   * Mark the node as reported. Helper method for when in 'report' mode.
   */
  public void markReported() {
    reported = true;
  }

  /**
   * Mark the node as unreported. Helper method for when in 'report' mode.
   */
  public void unmarkReported() {
    reported = false;
  }

  /**
   * Get the number of segments the node contains.
   */
  public java.util.List<LineSegment> getLineSegments() {
    return lineSegments;
  }

  /**
   * add a line to the node's area.
   */
  public void addLineSegment(LineSegment lineSegment) {
    lineSegments.add(lineSegment);
  }

  /**
   * Get the region the node represents.
   */
  public Rectangle getRegion() {
    return region;
  }

  /**
   * Set the split region of the node.
   */
  public void setSplitRegion(SplitRegion splitRegion) {
    this.splitRegion = splitRegion;
  }

  /**
   * Get the split region.
   */
  public SplitRegion getSplitRegion() {
    return splitRegion;
  }

  /**
   * Get the height of the node with respect to the root.
   */
  public int getHeight() {
    return this.height;
  }

  /**
   * Set the height of the node.
   */
  public void setHeight(int height) {
    this.height = height;
  }

  /**
   * Determines if the node is a leaf.
   */
  public boolean isLeaf() {
    return children.size() == 0;
  }

  /**
   * Determines if the node should be split.
   */
  public boolean shouldSplit() {
    return lineSegments.size() > 3;
  }
}