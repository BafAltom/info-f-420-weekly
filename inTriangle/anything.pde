int xC = width / 2;
int yC = height / 2;
int radius = 200;
PVector[] points = new PVector[3];
PFont font, bigFont;

void setup()
{
    font = createFont("Arial", 16, true);
    bigFont = createFont("Arial", 72, true);

    size(800, 600);
    xC = width / 2;
    yC = height / 2;
    background(0);
    noStroke();

    points[0] = new PVector;
    // points[0].x = xC + radius * cos(0);
    // points[0].y = yC + radius * sin(0);
    points[0].x = random(width);
    points[0].y = random(height);

    points[1] = new PVector;
    // points[1].x = xC + radius * cos(TWO_PI / 3);
    // points[1].y = yC - radius * sin(TWO_PI / 3);
    points[1].x = random(width);
    points[1].y = random(height);

    points[2] = new PVector;
    // points[2].x = xC + radius * cos(2 * TWO_PI / 3);
    // points[2].y = yC - radius * sin(2 * TWO_PI / 3);
    points[2].x = random(width);
    points[2].y = random(height);

    mouseV = new PVector(mouseX, mouseY)
}

void draw()
{
    textFont(font);
    background(0);

    fill(0);
    stroke(255);
    triangle(
        points[0].x,
        points[0].y,
        points[1].x,
        points[1].y,
        points[2].x,
        points[2].y
        );
    ellipse(points[0].x, points[0].y, 5, 5)
    ellipse(points[1].x, points[1].y, 5, 5)
    ellipse(points[2].x, points[2].y, 5, 5)

    fill(0);
    int mX = mouseX;
    int mY = mouseY;
    mouseV.x = mX;
    mouseV.y = mY;
    textFont(bigFont);
    if (isInTriangle(points, mouseV))
    {
        stroke(0, 255, 0);
        fill(0, 255, 0)
        text("IN", mouseX + 10, mouseY - 10);
    }
    else
    {
        stroke(255, 0, 0);
        fill(255, 0, 0)
        text("OUT", mouseX + 10, mouseY - 10);
    }
    ellipse(mouseX, mouseY, 10, 10);

    fill(255);
    textFont(font);
    text("Move the point in and out of the triangle.\nClick to generate a new triangle.", 10, height - 30);
}

void mousePressed()
{
    points[0].x = random(width);
    points[0].y = random(height);

    points[1].x = random(width);
    points[1].y = random(height);

    points[2].x = random(width);
    points[2].y = random(height);}


float mag(PVector v)
{
    return sqrt(v.x * v.x + v.y * v.y);
}

float crossProduct(PVector v1, PVector v2)
{
    return v1.mag() * v2.mag() * sin(PVector.angleBetween(v1, v2));
}

boolean isLeftTurn(PVector v1, PVector v2)
// Return true if ABC (where A^B = v1 and B^C = v2) is a left turn
{
    crossProduct = v1.cross(v2);
    return crossProduct.z < 0;
}

boolean isInTriangle(PVector[] triPoints, Pvector p)
// Return true if point p is inside the triangle defined by triPoints
// The points in triPoints must be in counterclockwise order
{
    for (int i = 0; i < 3; i++) {
        float curP = triPoints[i];
        float nexP = triPoints[(i + 1) % 3];
        float nexnexP = triPoints[(i + 2) % 3];
        // p must be on the same side of [curP, nexP] as nexnexP
        PVector vFixed = new PVector(nexP.x - curP.x, nexP.y - curP.y);
        PVector vNexNex = new PVector(nexnexP.x - nexP.x, nexnexP.y - nexP.y);
        PVector vP = new PVector(p.x - nexP.x, p.y - nexP.y);

        if (isLeftTurn(vFixed, vNexNex) != isLeftTurn(vFixed, vP))
        {
            return false;
        }
    }
    return true;
}
