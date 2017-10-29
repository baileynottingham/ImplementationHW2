

class QuadTree {

  Point[] points;

  QuadTree(String filename) {
    parseAndBuildQuadTree(filename);
  }

  void parseAndBuildQuadTree( String filename ) {
    BufferedReader reader;
    reader = createReader( filename );
    try {
      points = new Point[ Integer.parseInt( reader.readLine() ) ];
      for (int i = 0; i < points.length; i++) {
        String[] ints = reader.readLine().split(",");
        println(ints[0] + " " + ints[1] + " " + ints[2]);
      }
      reader.close();
    }
    catch ( Exception e) {
      System.err.println( "Error occured when parsing " + filename + ". Error msg: " + e.getMessage() );
    }
  }
}