

class QuadTree {

  Point[] points;
  private int height;
  java.util.List<LineSegment> lineSegments;

  QuadTree(String filename) {
    setLineSegments(parseFile(filename));
    for (LineSegment ls : lineSegments) {
      System.out.println(ls);
    }
  }

  java.util.List<LineSegment> parseFile(String filename) {
    BufferedReader reader;
    String line = null;
    reader = createReader(filename);
    java.util.List<LineSegment> lineSegs = new ArrayList<LineSegment>();

    try {
      setHeight(Integer.parseInt(reader.readLine()));
      // Since we don't know how many points we will have,
      // we just check if line is not null. Kinda like in C.
      while ((line = reader.readLine()) != null) {
        String[] ints = line.split(",");
        if (ints.length != 3){
          throw new Exception("Excpeted 3 integers.");
        }
        lineSegs.add(new LineSegment(Integer.parseInt(ints[0]),
                                     Integer.parseInt(ints[1]),
                                     Integer.parseInt(ints[2])));
      }
      reader.close();
    }
    catch (Exception e) {
      System.err.println("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
    }

    return lineSegs;
  }

  public int getHeight() {
    return height;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  public java.util.List getLineSegments() {
    return lineSegments;
  }

  public void setLineSegments(java.util.List lineSegments) {
    this.lineSegments = lineSegments;
  }

}