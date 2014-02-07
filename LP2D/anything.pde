ArrayList<PVector> points = new ArrayList<PVector>();
Pfont font;

PVector cstrFromPoints(PVector p1, PVector p2, boolean is_lb_y)
{
    float x1 = p1.x;
    float y1 = p1.y;
    float x2 = p2.x;
    float y2 = p2.y;
    float ang_coeff = (y2 - y1) / (x2 - x1);

    PVector cstr;
    if (is_lb_y) {
        cstr = new PVector(-ang_coeff, 1, y1 - (ang_coeff * x1));
    }
    else {
        cstr = new PVector(ang_coeff, -1, - y1 + (ang_coeff * x1));
    }
    return cstr
}

ArrayList<PVector > constraints = new ArrayList<PVector >();
// the constraint a x + b y <= c is stored as the PVector (a, b, c)
constraints.add(new PVector(0, -1, 0)); // initial constraint : y >= 0
constraints.add(new PVector(-1, 0, 0)); // initial constraint : x >= 0


float eps = -0.001;
PVector optimum = new PVector(0, 0);
PVector obj = new PVector(eps, 1); // min (eps * x + y)

float objectiveValue(PVector obj, PVector p) {
    return obj.x * p.x + obj.y * p.y;
}

PVector mousePressedAt = null;

boolean testConstraint(PVector cstr, PVector p)
// Test if point p is valid w.r.t. constraint cstr
{
    return cstr.x * p.x + cstr.y * p.y <= cstr.z
}

PVector findOptimum(PVector oldOptimum, ArrayList<PVector> oldCstrs, PVector obj, PVector newCstr)
// Returns the new optimum w.r.t. obj and {oldCstrs U newCstr}
// oldOptimum is the optimum w.r.t. obj and oldCstrs only
{
    PVector newOptimum;
    if (testConstraint(newCstr, oldOptimum)) {
        newOptimum = oldOptimum;
    }
    else {
        newOptimum = linprog_1D(newCstr, obj, oldCstrs);
    }
    return newOptimum;
}

PVector intersect(PVector line1, PVector line2)
// return point x_P, y_P of intersection between
//    line1 (ax + by = c) and line2 (dx + ey = f)
// which is the solution to the system of equation
//    ax + by = c
//    dx + ey = f
// i.e.
// ax + by = c <=> y = (c - ax)/b
// dx + ey = f
// dx + e(c - ax)/b = f
// dx + ec/b - eax/b = f
// (d - ea/b) x = f - (ec/b)
// x = (f - (ec/b)) / (d - ea/b)
{
    float a = line1.x;
    float b = line1.y;
    float c = line1.z;
    float d = line2.x;
    float e = line2.y;
    float f = line2.z;
    float x_P = (f - e * (c / b)) / (d - e * (a / b));
    float y_P = (c - a * x_P) / b;
    // println("inter\t" + str(x_P) + "\t" + str(y_P));
    return new PVector(x_P, y_P);
}


PVector linprog_1D(PVector newCstr, PVector obj, ArrayList<PVector> oldCstrs)
{
    // println("newCstr:\t" + str(newCstr));
    float current_min_x = borderPoint(newCstr, 0);
    float current_max_x = borderPoint(newCstr, 800);
    // println("min/max:\t" + str(current_min_x) + "\t" + str(current_max_x));
    for (PVector cstr : oldCstrs) {
        // println("adding constraint:\t" + str(cstr));
        PVector interP = intersect(cstr, newCstr);
        // println("intersection:\t" + str(interP));
        if (!testConstraint(cstr, current_min_x) && !testConstraint(cstr, current_max_x)) {
            return null;
        }
        else if (!testConstraint(cstr, current_min_x)) {
            current_min_x = interP;
        }
        else if (!testConstraint(cstr, current_max_x)) {
            current_max_x = interP;
        }
        // println("min/max:\t" + str(current_min_x) + "\t" + str(current_max_x));
    }
    if (current_max_x < current_min_x) {return null;}
    float min_P = borderPoint(newCstr, current_min_x.x);
    float max_P = borderPoint(newCstr, current_max_x.x);
    float min_value = objectiveValue(obj, min_P);
    float max_value = objectiveValue(obj, max_P);
    // print("min/max values:\t" + str(min_value) + str(max_value));
    return min_value < max_value ? current_min_x : current_max_x;
}

float borderPoint(PVector cstr, float x) {
    return new PVector(x, (cstr.z - cstr.x * x) / cstr.y);
}

boolean isLeftTurn(PVector v1, PVector v2)
// Return true if ABC (where A^B = v1 and B^C = v2) is a left turn
{
    crossProduct = v1.cross(v2);
    return crossProduct.z <= 0;
}

int width = 800;
int height = 600;

void setup()
{
    size(width, height);
    font = createFont("Arial", 16, true);
    textFont(font);
    // scale(0, -1); // y points upward
    background(0);
    noStroke();

    // noLoop();
    // redraw();
}

boolean is_lb_y(PVector cstr)
{
    return cstr.y < 0;
}

boolean is_lb_x(PVector cstr)
{
    return cstr.x < 0;
}

void printConstr(PVector cstr)
{
    println("y = " + str(-cstr.x/cstr.y) + " + " + str(cstr.z / cstr.y));
}

void drawCstr(PVector cstr)
{
    // cstr = {a,b,c} represents a x + b y <= c
    if (cstr.x == 0) {
        float lineHeight = cstr.z / cstr.y;
        line(0, - lineHeight, width, - lineHeight);
    }
    else if (cstr.y == 0) {
        float lineWidth = cstr.z / cstr.x;
        line(lineWidth, 0, lineWidth, height);
    }
    else {
        // we must darken the half-plane left or right of cstr
        // i.e. draw a triangle overlaping the frame, of which one vertex is on
        // a corner of the frame (up-right or bottom-left)
        PVector corner = new PVector(0, 0);
        PVector p1;
        PVector p2;

        if (is_lb_x(cstr)) {
            PVector leftBorder = new PVector(1, 0, 0);
            p1 = intersect(cstr, leftBorder);
            corner.x = 0;
        }
        else {
            PVector rightBorder = new PVector(1, 0, 800);
            p1 = intersect(cstr, rightBorder);
            corner.x = width;
        }

        if (is_lb_y(cstr)) {
            PVector bottomBorder = new PVector(0, 1, 0);
            p2 = intersect(cstr, bottomBorder);
            corner.y = 0;
        }
        else {
            PVector upBorder = new PVector(0, 1, 600);
            p2 = intersect(cstr, upBorder);
            corner.y = height;
        }

        stroke(255);
        fill(255,255,255);
        line(p1.x, -p1.y, p2.x, -p2.y);
        fill(255,255,255,50);
        triangle(corner.x, -corner.y, p1.x, -p1.y, p2.x, -p2.y);
        // print("Constraint:");
        // printConstr(cstr);
        // println("p1\t" + str(p1));
        // println("p2\t" + str(p2));
        // println("co\t" + str(corner));
        // println("--");

    }
}

void drawPoint(PVector p)
{
    fill(255);
    stroke(0);
    ellipse(p.x, -p.y, 10, 10)
}

void draw()
{
    translate(0, height); // origin at the bottom-left corner
    background(0);
    fill(0);
    stroke(0);

    if (mousePressedAt) {
        PVector mouseCstr = cstrFromPoints(mousePressedAt, new PVector(mouseX, height - mouseY), leftButtonPressed);
        drawCstr(mouseCstr);
    }

    for (PVector cstr : constraints) {
        drawCstr(cstr);
    }
    if (optimum) {
        drawPoint(optimum);
    }
    else {
        print("No solution!")
    }
}

PVector randomPoint()
{
    return new PVector(random(width), random(height));
}

void mousePressed()
{
    leftButtonPressed = mouseButton == LEFT
    mousePressedAt = new PVector(mouseX, height - mouseY);
}

void mouseReleased()
{
    PVector newCstr;
    if (mouseButton == LEFT) {
        newCstr = cstrFromPoints(mousePressedAt, new PVector(mouseX, height - mouseY), true);
    }
    else {
        newCstr = cstrFromPoints(mousePressedAt, new PVector(mouseX, height - mouseY), false);
    }
    // PVector newCstr = new PVector(-1, -1, -300);
    optimum = findOptimum(optimum, constraints, obj, newCstr);
    constraints.add(newCstr);
    // println("newCstr:\t" + str(newCstr));
    // if (optimum != null) {
    //     println("newOptimum:\t" + str(optimum));
    // }
    // redraw();
    mousePressedAt = null;
}
