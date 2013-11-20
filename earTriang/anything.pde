ArrayList<PVector> points = new ArrayList<PVector>();
Pfont font;

boolean isLeftTurn(PVector v1, PVector v2)
// Return true if ABC (where A^B = v1 and B^C = v2) is a left turn
{
    crossProduct = v1.cross(v2);
    return crossProduct.z <= 0;
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

void initPolygon()
{
    points.clear();
    points.add(new PVector(width / 8, 7 * height / 8));
}

void setup()
{
    font = createFont("Arial", 16, true);
    textFont(font);
    size(800, 600);
    background(0);
    noStroke();

    initPolygon();
    noLoop();
    // redraw();

}

void draw()
{
    background(0);

    // draw triangulation
    fill(100);
    stroke(100);
    ArrayList<ArrayList<PVector> > triangles = earTriangulate(points);
    for (ArrayList<PVector> triang : triangles) {
       p1 = triang.get(0);
       p2 = triang.get(1);
       p3 = triang.get(2);
       line(p1.x, p1.y, p2.x, p2.y);
       line(p2.x, p2.y, p3.x, p3.y);
       line(p3.x, p3.y, p1.x, p1.y);
    }

    // draw points
    fill(255);
    stroke(255);
    for (int i = 0; i < points.size(); i++) {
        p = points.get(i);
        text(str(i)/* + "(" + p.x + ", " + p.y + ")"*/, p.x + 10, p.y - 10);
        ellipse(p.x, p.y, 5, 5);
        p2 = points.get((i+1) % points.size());
        line(p.x, p.y, p2.x, p2.y);
    }

    // last point in green
    fill(0, 255, 0);
    stroke(0, 255, 0);
    lastP = points.get(points.size() - 1);
    ellipse(lastP.x, lastP.y, 5, 5);

    fill(255);
    stroke(255);
    text("Left-click to draw a simple polygon in counter-clockwise order.\nRight-click to erase the polygon.", 10, height - 30)
}

void mousePressed()
{
    if (mouseButton == LEFT) {
        points.add(new PVector(mouseX, mouseY));
        redraw();
    }
    else if (mouseButton == RIGHT) {
        initPolygon();
        redraw();
    }
}

ArrayList<ArrayList<PVector> > earTriangulate(ArrayList<PVector> points)
/*
    points: a description of a simple polygon.
        i.e. the list of its vertices in counter-clockwise order
*/
{
    ArrayList<PVector> pointsCopy = points.clone();
    ArrayList<ArrayList<PVector> > triangles = new ArrayList<ArrayList<PVector> >();
    while(pointsCopy.size() > 3) {
        int earIndex = findEar(pointsCopy);
        if (earIndex == -1) {  // not a valid polygon (no ears)
            println("not a valid polygon");
            for (PVector p : pointsCopy) {
                println(str(p));
            }
            println("====");
            return triangles;
        }
        // add the ear to the list of triangles
        ArrayList<PVector> triang = new ArrayList<PVector>();
        triang.add(pointsCopy.get(modulo((earIndex + 1), pointsCopy.size())));
        triang.add(pointsCopy.get(modulo((earIndex - 1), pointsCopy.size())));
        triang.add(pointsCopy.get(earIndex));
        triangles.add(triang);
        // cut the ear
        pointsCopy.remove(earIndex);
    }
    return triangles;
}

int modulo(int n, m)
/*
    Return the true value of n % m (which is not always positive with standard JAVA behavior)
*/
{
    return (n < 0) ? (m - (abs(n) % m) ) %m : (n % m);
}

int findEar(ArrayList<PVector> points)
{
    for (int i = 0; i < points.size(); i++) {
        // println("i:\t" + str(i));
        pre_i = modulo((i - 1), points.size());
        nex_i = modulo((i + 1), points.size());
        PVector p = points.get(i);
        PVector preP = points.get(pre_i);
        PVector nexP = points.get(nex_i);
        // check that [p preP nexP] is a left turn (convex vertex)
        PVector vPre = new PVector(p.x - preP.x, p.y - preP.y);
        PVector vNex = new PVector(nexP.x - p.x, nexP.y - p.y);
        if (!isLeftTurn(vPre, vNex)) {
            // println("\tNot a left turn");
            continue;
        }
        // check that [preP nexP] does not cross the polygon (all other vertices are not in the triangle)
        foundCrossPoint = false;
        for (int j = 0; j < points.size(); j++) {
            if (j == i || j == pre_i || j == nex_i) {
                continue;
            }
            PVector q = points.get(j);
            if (isInTriangle([preP, p, nexP], q)) {
                // println("\tFound cross point : " + str(j));
                foundCrossPoint = true;
                break;
            }
        }
        if (!foundCrossPoint) {
            return i;
        }
    }
    return -1;
}
