size(800, 500);
ArrayList<PVector> primPoint = new ArrayList<PVector>();
ArrayList<PVector> primLines = new ArrayList<PVector>();
ArrayList<PVector> dualPoint = new ArrayList<PVector>();
ArrayList<PVector> dualLines = new ArrayList<PVector>();
float transX = width / 4;
float transY = height / 2;
float xScale = 50;
float yScale = -50;
float pointSize = 10;
float rightMouseX = 0;
float rightMouseY = 0;
font = createFont("Arial", 16, true);
bigFont = createFont("Arial", 72, true);
miniFont = createFont("Arial", 10, true);

void setup()
{
}

void draw()
{
    textFont(font);
    background(255);
    // draw primal
    fill(200,255,200);
    stroke(255);
    rect(0, 0, width/2, height);
    fill(0,255,0);
    stroke(0);
    textFont(bigFont);
    text("PRIMAL", 0, 60);
    translate(transX, transY);
    drawGrid();
    fill(0);
    stroke(0);

    for (PVector l : primLines) {
        drawLine(l);
    }

    for (PVector p : primPoint) {
        drawPoint(p);
    }

    // separation line
    resetMatrix();
    fill(200,200,255);
    stroke(255);
    rect(width/2, 0, width/2, height);
    fill(0,0,255);
    stroke(0);
    textFont(bigFont);
    text("DUAL", width / 2 , 60);
    fill(255,0,0);
    stroke(255,0,0);
    line(width/2, 0, width/2, height);

    // draw dual
    translate(transX + width / 2, transY); // place origin at the center of the subwindow
    drawGrid();
    fill(0);
    stroke(0);

    for (PVector l : dualLines) {
        drawLine(l);
    }

    for (PVector p : dualPoint) {
        drawPoint(p);
    }

}

void mousePressed()
{
    boolean inPrimal = mouseX < width / 2;
    if (mouseButton == LEFT) {
        if (inPrimal) {
            PVector point = new PVector((mouseX - transX) / xScale, (mouseY -transY) / yScale);
            PVector l = new PVector(point.x, point.y);
            primPoint.add(point);
            dualLines.add(l);
        }
    }
    else if (mouseButton == RIGHT) {
        if (inPrimal) {
            rightMouseX = mouseX;
            rightMouseY = mouseY;
        }
    }
}

void mouseReleased()
{
    boolean inPrimal = mouseX < width / 2;
    if (mouseButton == RIGHT) {
        if (inPrimal) {
            float p1X = (rightMouseX - transX) / xScale;
            float p1Y = (rightMouseY - transY) / yScale;
            float p2X = (mouseX - transX) / xScale;
            float p2Y = (mouseY - transY) / yScale;
            // line passing between (p1X, p1Y) and (p2X, p2Y) of equation y = a x + b
            float a = (p2Y - p1Y) / (p2X - p1X);
            float b = p2Y - a * p2X;
            PVector l = new PVector(a, b);
            PVector p = new PVector(-a ,b);
            primLines.add(l);
            dualPoint.add(p);
        }
        rightMouseX = 0;
        rightMouseY = 0;
    }
}

void drawGrid()
{
    fill(100);
    stroke(100);
    textFont(font);
    for (int i = -10; i <= 10; i++) {
        // vertical line
        line(-width, i * yScale, 2 * width, i * yScale);
        // horizontal line
        line(i * xScale, - height, i * xScale, 2 * height);
    }
    drawPoint(new PVector(0,0));
    drawPoint(new PVector(1,0));
    drawPoint(new PVector(0,1));
    fill(100);
    stroke(100);
    textFont(miniFont);
    text("(0, 0)", 0, 15);
    text("(1, 0)", 1 * xScale, 15);
    text("(0, 1)", 0, 1 * yScale + 15);
}

void drawLine(PVector l)
{
    // line y = ax + b
    float a = l.x;
    float b = l.y;
    float leftX = (- width / 4) / xScale;
    float rightX = (width / 4) / xScale;
    PVector pointLeft = new PVector(leftX, a * leftX + b);
    PVector pointRight = new PVector(rightX, a * rightX + b);
    line(pointLeft.x * xScale, pointLeft.y * yScale, pointRight.x * xScale, pointRight.y * yScale);
}

void drawPoint(PVector point)
{
    fill(255);
    stroke(0);
    ellipse(xScale * point.x, yScale * point.y, pointSize, pointSize);
}
