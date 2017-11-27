/**
 * Helpful for debugging.
 * @author Bailey Nottingham
 * @author Mario Hernandez
 */
enum SplitRegion {
  /**
   * The north west region of the parent' node's region.
   */
  NORTH_WEST,
  /**
   * The north east region of the parent' node's region.
   */
  NORTH_EAST,
  /**
   * The south west region of the parent' node's region.
   */
  SOUTH_WEST,
  /**
   * The south east region of the parent' node's region.
   */
  SOUTH_EAST,
  /**
   * The whole graph. Only the root will contain this.
   */
  WHOLE_GRAPH
}