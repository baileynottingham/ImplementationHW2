//<>// //<>// //<>//
//Buttons
Button readFileButton;
Button partyButton;
Button insertButton;
Button animationButton;
Button reportButton;

QuadTree quadTree = null;
java.util.List<LineSegment> lineSegments = new java.util.ArrayList<LineSegment>();
java.util.List<String> errorMessages = new java.util.ArrayList<String>();
private String fileName;

boolean quadTreeInitialized = false;
boolean animationOn = true;
boolean insertOn = false;
boolean reportOn = false;
boolean partyMode = false;

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
double startTimeParty = 0;

Firework[] fs = new Firework[10];
boolean once;

private static final int FILE_ERROR = -1;

void setup() {
  size(512, 630);
  smooth();
  textSize(16);

  //Create Clickable Buttons
  partyButton = new Button("Party", 10, 520, 80, 35);
  readFileButton = new Button("Read File", 110, 520, 80, 35);
  animationButton = new Button("Animation", 210, 520, 90, 35);
  insertButton = new Button("Insert", 320, 520, 80, 35);
  reportButton = new Button("Report", 420, 520, 80, 35);
  //  partyButton = new Button("Party", 520, 520, 80, 35);
  prepareExitHandler();

  smooth();
  for (int i = 0; i < fs.length; i++) {
    fs[i] = new Firework();
  }
} //END setup

private void prepareExitHandler() {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      if (fileName == null) {
        return;
      }
      String fileNames[] = fileName.split( ".in" );
      String outputFile = fileNames[ 0 ] + ".out";
      PrintWriter output = createWriter( outputFile );
      output.println("======================================= Line Segments Report =======================================");
      for (LineSegment line : quadTree.getLineSegments()) {
        output.println(line);
      }
      output.println("======================================= Line Segments Report =======================================");
      output.println("=========================================== Error Report ===========================================");
      for (String errMsg : errorMessages) {
        output.println(errMsg);
      }
      output.println("=========================================== Error Report ===========================================");
      output.flush();
      output.close();
    }
  }
  ));
}
void draw() {
  clear();
  smooth();
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(256, 256, 256);
  rect(0, 0, 620, 512);

  fill(102, 255, 178);
  rect(0, 512, 620, 188);
  fill(256, 256, 256);
  drawButtons();
  fill(256, 256, 256);
  textAlign(LEFT, TOP);
  text("Type Filename: " + "sample text goes here", 10, 410, width, height);
  displayBottomText();
  fill(250, 0, 0);

  double currentTime= millis();
  if (quadTreeInitialized && (currentTime-startTime) > highlightTime || animationOn == false) {
    quadTree.displayQuadTree(quadTree.getRoot(), partyMode);
  }

  if (quadTreeInitialized && animationOn && justInserted && (currentTime-startTime) <= highlightTime) {
    quadTree.displayQuadTree(quadTree.getRoot(), partyMode);
    quadTree.animateInsert(tempX, tempY, quadTree.getRoot());
  }

  if (quadTreeInitialized && animationOn && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime && !partyMode) {
    quadTree.displayQuadTree(quadTree.getRoot(), partyMode);
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReport(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if (quadTreeInitialized && animationOn == false && reportOn && clicks == 2 && (currentTime-startTime) <= highlightTime && !partyMode) {
    quadTree.displayQuadTree(quadTree.getRoot(), partyMode);
    Rectangle rectReport = new Rectangle(topLeftX, bottomRightX, topLeftY, bottomRightY);
    quadTree.report(rectReport);
    quadTree.animateReportNoAnimation(quadTree.getRoot());
    quadTree.drawSplitRegionReport(rectReport);
  }

  if ((currentTime-startTime) > highlightTime) {
    justInserted = false;
  }

  if (quadTreeInitialized && partyMode) {
    java.util.Random random_color = new java.util.Random();
    int r = random_color.nextInt(256);
    int g = random_color.nextInt(256);
    int b = random_color.nextInt(256);
    // If you uncomment this it may cause seizures....
    //fill(r, g, b);
    //rect(0, 0, 512, 512);

    quadTree.party(quadTree.getRoot());
    r = random_color.nextInt(256);
    g = random_color.nextInt(256);
    b = random_color.nextInt(256);
    fill(r, g, b);
    rect(0, 512, 620, 188);
    displayBottomText();
    drawButtonsParty();

    stroke(10);
    fill(50, 0, 40, 20);
    rect(0, 0, width, height);
    for (int i = 0; i < fs.length; i++) {
      fs[i].draw();
    }
    flush();
  }
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
  if (insertOn && partyMode == false) {
    tempX = mouseX;
    tempY = mouseY;
    LineSegment pointToBeInserted = new LineSegment(tempX, tempX, tempY);
    for (LineSegment line : quadTree.getLineSegments()) {
      if (line.isPoint()) {
        if (tempX >= (line.getRightPoint().getX() - 2) &&
          tempX <= (line.getRightPoint().getX() + 2) &&
          tempY >= (line.getVerticalShift() - 2) &&
          tempY <= (line.getVerticalShift() + 2)) {
          System.err.println("[ERR] two points are on each other.");
          errorMessages.add("[ERR] two points are on each other.");
          return;
        }
      } else {
        if (pointToBeInserted.isIntersecting(line)) {
          System.err.println("[ERR] line: " + line + "\t" + "intersects with: " + pointToBeInserted + "(pointToBeInserted)");
          errorMessages.add("[ERR] line: " + line + "\t" + "intersects with: " + pointToBeInserted + "(pointToBeInserted)");
          return;
        }
      }
    }

    quadTree.insert(pointToBeInserted);
    justInserted = true;
    startTime = millis();
  }

  if (reportOn && quadTreeInitialized && !partyMode) {
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
  if (partyButton.mouseOver()) {
    partyMode = !partyMode;
    insertOn = false;
    reportOn = false;
  } else if (readFileButton.mouseOver() && !partyMode) { // user presses "Read File"
    String fileName = javax.swing.JOptionPane.showInputDialog( null, "File Name", "" );
    processFile( fileName );
  } else if (reportButton.mouseOver() && !partyMode) { // user presses "Report"
    if (reportOn == false) {
      reportOn = true;
      insertOn = false;
      javax.swing.JOptionPane.showMessageDialog(null, "You are now in report mode. Click where you want the top left corner of query region to be.");
    } else {
      reportOn = false;
    }
  } else if (animationButton.mouseOver() && quadTreeInitialized && !partyMode) { // user presses "Animation"
    if (animationOn == false) {
      animationOn = true;
    } else {
      animationOn = false;
    }
  } else if (insertButton.mouseOver() && quadTreeInitialized && !partyMode) { // user presses "Insert"
    if (insertOn == false) {
      insertOn = true;
      reportOn = false;
    } else {
      insertOn = false;
    }
  }
} //END mousePressed

void mouseReleased() {
  if (partyMode) {
    once = false;
    for (int i = 0; i < fs.length; i++) {
      if ((fs[i].hidden)&&(!once)) {
        fs[i].launch();
        once = true;
      }
    }
  }
}

void processFile(String fileName) {
  if (fileName == null || fileName.isEmpty()) {
    return;
  }
  this.fileName = fileName;
  int height = parseFileForHeight(this.fileName);

  if (height == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    errorMessages.add("[ERR] error reading file.");
    return;
  }

  quadTree = new QuadTree(height);
  int rtnCode = parseFileForLineSegments(this.fileName);
  if (rtnCode == FILE_ERROR) {
    System.err.println("[ERR] error reading file.");
    errorMessages.add("[ERR] error reading file.");
    return;
  }
  for (LineSegment lineSegment : lineSegments) {
    quadTree.insert(lineSegment);
  }
  quadTreeInitialized = true;
  quadTree.setErrorMessages(errorMessages);
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
        errorMessages.add("Excpeted 3 integers.");
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
    errorMessages.add("Error occured when parsing " + filename + ". Error msg: " + e.getMessage());
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
  partyButton.drawButton();
  readFileButton.drawButton();
  animationButton.drawButton();
  insertButton.drawButton();
  reportButton.drawButton();
  //  partyButton.drawButton();
}

void drawButtonsParty() {
  readFileButton.setText("Read File");
  partyButton.drawButtonParty();
  readFileButton.drawButtonParty();
  animationButton.drawButtonParty();
  insertButton.drawButtonParty();
  reportButton.drawButtonParty();
  // partyButton.drawButtonParty();
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
  String party = (partyMode) ? "ON" : "OFF";
  text("Party Mode = " + party, 280, 605);
}

// https://www.openprocessing.org/sketch/17259
class Firework {
  float x, y, oldX, oldY, ySpeed, targetX, targetY, explodeTimer, flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched, exploded, hidden;
  color flare;
  Firework() {
    launched = false;
    exploded = false;
    hidden = true;
  }
  void draw() {
    if ((launched)&&(!exploded)&&(!hidden)) {
      launchMaths();
      strokeWeight(5);
      stroke(255);
      line(x, y, oldX, oldY);
    }
    if ((!launched)&&(exploded)&&(!hidden)) {
      explodeMaths();
      noStroke();
      strokeWeight(flareWeight);
      stroke(flare);
      for (int i = 0; i < flareAmount + 1; i++) {
        pushMatrix();
        translate(x, y);
        point(sin(radians(i*flareAngle))*explodeTimer, cos(radians(i*flareAngle))*explodeTimer);
        popMatrix();
      }
    }
    if ((!launched)&&(!exploded)&&(hidden)) {
      //do nothing
    }
  }
  void launch() {
    x = oldX = mouseX + ((random(5)*10) - 25);
    y = oldY = height;
    targetX = mouseX;
    targetY = mouseY;
    ySpeed = random(3) + 2;
    flare = color(random(3)*50 + 105, random(3)*50 + 105, random(3)*50 + 105);
    flareAmount = ceil(random(30)) + 20;
    flareWeight = ceil(random(10));
    duration = ceil(random(4))*20 + 30;
    flareAngle = 360/flareAmount;
    launched = true;
    exploded = false;
    hidden = false;
  }
  void launchMaths() {
    oldX = x;
    oldY = y;
    if (dist(x, y, targetX, targetY) > 6) {
      x += (targetX - x)/2;
      y += -ySpeed;
    } else {
      explode();
    }
  }
  void explode() {
    explodeTimer = 0;
    launched = false;
    exploded = true;
    hidden = false;
  }
  void explodeMaths() {
    if (explodeTimer < duration) {
      explodeTimer+= 0.4;
    } else {
      hide();
    }
  }
  void hide() {
    launched = false;
    exploded = false;
    hidden = true;
  }
}