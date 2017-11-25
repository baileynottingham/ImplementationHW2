//<>// //<>//
//Buttons
Button readFileButton;
Button restartButton;
Button insertButton;
Button animationButton;
Button reportButton;
Button partyButton;
QuadTree quadTree = null;
java.util.List<LineSegment> lineSegments = new ArrayList<LineSegment>();

boolean quadTreeInitialized = false;
boolean animationOn = true;
boolean insertOn = false;
boolean reportOn = false;

int tempX = 0;
int tempY = 0;
int topLeftX = 0;
int topLeftY = 0;
int bottomRightX = 0;
int bottomRightY = 0;
int clicks = 0;
boolean justInserted = false;

double highlightTime=3000;
double startTime = 0;

private static final int FILE_ERROR = -1;

void setup() {
  size(512, 630);
  smooth();
  textSize(16);

  //Create Clickable Buttons
  restartButton = new Button("Restart", 10, 520, 80, 35);
  readFileButton = new Button("Read File", 110, 520, 80, 35);
  animationButton = new Button("Animation", 210, 520, 90, 35);
  insertButton = new Button("Insert", 320, 520, 80, 35);
  reportButton = new Button("Report", 420, 520, 80, 35);
} //END setup


void draw() {
  clear();
  smooth();
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(256, 256, 256);
  rect(0, 0, 512, 512);

  fill(102, 255, 178);
  rect(0, 512, 512, 188);
  fill(256, 256, 256);
  drawButtons();
  fill(256, 256, 256);
  textAlign(LEFT, TOP);
  text("Type Filename: " + "sample text goes here", 10, 410, width, height);
  displayBottomText();
  fill(250, 0, 0);

  double currentTime= millis();
  if (quadTreeInitialized && (currentTime-startTime) > highlightTime || animationOn == false) {
    quadTree.displayQuadTree(quadTree.getRoot());
  }
  if (quadTreeInitialized && animationOn && justInserted && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot());
    quadTree.animateInsert(tempX, tempY, quadTree.getRoot());
  }

  if (quadTreeInitialized && animationOn && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot());
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReport(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if (quadTreeInitialized && animationOn == false && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot());
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReportNoAnimation(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if ((currentTime-startTime) > highlightTime) {
    justInserted = false;
  }
  flush();
} //END draw

/*******************************************************************************
 * restart()
 *
 * Description: clears all global variables so that the user can restart the
 *              program without stopping the entire thing.
 *******************************************************************************/
void restart() {
} //END restart


/*******************************************************************************
 * mousePressed()
 *
 * Description: Handles logic for mouse presses.
 *              A single mouse click could be hitting any of the buttons.
 *******************************************************************************/
void mousePressed() {
  if (insertOn) {
    tempX = mouseX;
    tempY = mouseY;
    LineSegment pointToBeInserted = new LineSegment(tempX, tempX, tempY);
    for (LineSegment line : quadTree.getLineSegments()) {
      if (line.isPoint()) {
        if (tempX >= (line.getRightPoint().getX() - 2) &&
            tempX <= (line.getRightPoint().getX() + 2) &&
            tempY >= (line.getVerticalShift() - 2) &&
            tempY <= (line.getVerticalShift()+2)) {
          System.err.println("[ERR] two points are on each other.");
          return;
        }
      } else {
        if (pointToBeInserted.isIntersecting(line)) {
          System.err.println("[ERR] line: " + line + "\t" + "intersects with: " + pointToBeInserted + "(pointToBeInserted)");
          return;
        }
      }
    }
    quadTree.insert(pointToBeInserted);
    justInserted = true;
    startTime = millis();
  }

  if (reportOn && quadTreeInitialized) {
    if (clicks == 2) {
      clicks = 0;
    }
    if (clicks == 0) {
      topLeftX = mouseX;
      topLeftY = mouseY;
      if (quadTree.getRoot().getRegion().containsPoint(topLeftX, topLeftY)) {
        javax.swing.JOptionPane.showMessageDialog(null, "Top left corner selected. Click where you want the bottom right corner of the query region to be.");
      } else {
        clicks--;
      }
    }
    if (clicks == 1) {
      bottomRightX = mouseX;
      bottomRightY = mouseY;
      if (quadTree.getRoot().getRegion().containsPoint(bottomRightX, bottomRightY)) {
        startTime= millis();
      } else {
        clicks--;
      }
    }
    clicks++;
  }

  // user presses "Restart"
  if (restartButton.mouseOver()) {
    javax.swing.JOptionPane.showMessageDialog(null, "restart Button Pressed ");
    restart();
  }
  // user presses "Read File"
  else if (readFileButton.mouseOver()) {
    String fileName = javax.swing.JOptionPane.showInputDialog( null, "File Name", "" );
    processFile( fileName );
  }
  // user presses "Report"
  else if (reportButton.mouseOver()) {
    if (reportOn == false) {
      reportOn = true;
      insertOn = false;
      javax.swing.JOptionPane.showMessageDialog(null, "You are now in report mode. Click where you want the top left corner of query region to be.");
    } else {
      reportOn = false;
    }
  }
  // user presses "Animation"
  else if (animationButton.mouseOver() && quadTreeInitialized) {
    if (animationOn == false) {
      animationOn = true;
    } else {
      animationOn = false;
    }
  }
  // user presses "Insert"
  else if (insertButton.mouseOver() && quadTreeInitialized) {
    if (insertOn == false) {
      insertOn = true;
      reportOn = false;
    } else {
      insertOn = false;
    }
  }
} //END mousePressed

void processFile(String fileName) {
  if (fileName == null || fileName.isEmpty()) {
    return;
  }
  int height = parseFileForHeight(fileName);
  if (height == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    return;
  }
  quadTree = new QuadTree(height);
  int rtnCode = parseFileForLineSegments(fileName);
  if (rtnCode == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    return;
  }
  for (LineSegment lineSegment : lineSegments) {
    quadTree.insert(lineSegment);
  }
  quadTreeInitialized = true;
}

int parseFileForHeight(String filename) {
  BufferedReader reader = createReader(filename);
  try {
    int height = Integer.parseInt(reader.readLine());
    reader.close();
    return height;
  } 
  catch (Exception e) {
    return FILE_ERROR;
  }
}

int parseFileForLineSegments(String filename) {
  BufferedReader reader;
  String line = null;
  reader = createReader(filename);

  try {
    // read the first line, but dont do anything with it.
    Integer.parseInt(reader.readLine());
    // Since we don't know how many points we will have,
    // we just check if line is not null. Kinda like in C.
    while ((line = reader.readLine()) != null) {
      String[] ints = line.split(",");
      if (ints.length != 3) {
        System.err.println("Excpeted 3 integers.");
        continue;
      }
      int x1 = Integer.parseInt(ints[0].trim());
      int x2 = Integer.parseInt(ints[1].trim());
      int y = Integer.parseInt(ints[2].trim());
      lineSegments.add(new LineSegment(x1, x2, y));
    }
    reader.close();
  }
  catch (Exception e) {
    System.err.println("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
    return FILE_ERROR;
  }
  return 1;
}

/*******************************************************************************
 * drawButtons()
 *
 * Description: Draws all program buttons (defined as global variables)
 *******************************************************************************/
void drawButtons() {
  readFileButton.setText("Read File");
  restartButton.drawButton();
  readFileButton.drawButton();
  animationButton.drawButton();
  insertButton.drawButton();
  reportButton.drawButton();
}

void displayBottomText() {
  fill(0);
  text("Animation Mode = ", 10, 565, width, height);
  if (animationOn) {
    text("ON", 157, 565, width, height);
  } else {
    text("OFF", 157, 565, width, height);
  }
  text("Insert Mode = ", 10, 585, width, height);
  if (insertOn) {
    text("ON", 122, 585, width, height);
  } else {
    text("OFF", 122, 585, width, height);
  }
  text("Report Mode = ", 10, 605, width, height);
  if (reportOn) {
    text("ON", 128, 605, width, height);
  } else {
    text("OFF", 128, 605, width, height);
  }
  if (quadTreeInitialized) {
    text("Number of Nodes = " + quadTree.getNumberOfNodes(), 280, 585, width, height);
    text("Number of Segments = " + quadTree.getNumberOfSegments(), 280, 565, width, height);
  } else {
    text("Number of Nodes = 0", 280, 585, width, height);
    text("Number of Segments = 0", 280, 565, width, height);
  }
}