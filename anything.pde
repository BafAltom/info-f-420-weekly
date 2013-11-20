PFont font;

void setup()
{
    size(800, 600);
    background(0);
    font = createFont("Arial", 16, true);
    bigFont = createFont("Arial", 72, true);

    A = new PVector;
    A.x = width / 2;
    A.y = height - 10;

    B = new PVector;
    B.x = width / 2;
    B.y = height / 2;

    C = new PVector;
    C.x = mouseX;
    C.y = mouseY;

    mouseV = new PVector(mouseX, mouseY)
}

void draw()
{
    background(0);
    textFont(font);
    fill(255);
    stroke(255);

    C.x = mouseX;
    C.y = mouseY;

    line(A.x, A.y, B.x, B.y)

    ellipse(A.x, A.y, 10, 10);
    text("A", A.x + 10, A.y - 10);

    line(B.x, B.y, C.x, C.y)

    ellipse(B.x, B.y, 10, 10);
    text("B", B.x + 10, B.y - 10);

    ellipse(C.x, C.y, 10, 10);
    text("C", C.x + 10, C.y - 10);

    v1 = new PVector(B.x - A.x, B.y - A.y);
    v2 = new PVector(C.x - B.x, C.y - B.y);

    textFont(bigFont);
    if (isLeftTurn(v1, v2))
    {
        text("LEFT", width/8, height/8);
    }
    else
    {
        text("RIGHT", 2.5*width/4, height/8);
    }

}

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

