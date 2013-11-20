int nb_points = 20;
PVector points[] = new PVector[nb_points];
Pfont font;

boolean isLeftTurn(PVector v1, PVector v2)
// Return true if ABC (where A^B = v1 and B^C = v2) is a left turn
{
    crossProduct = v1.cross(v2);
    return crossProduct.z <= 0;
}


void setup()
{
    font = createFont("Arial", 16, true);
    textFont(font);
    size(800, 600);
    background(0);
    noStroke();

    for (int i = 0; i < nb_points; i++) {
        points[i] = new PVector;
        points[i].x = random(width / 8, 7 * width / 8);
        points[i].y = random(height / 8 , 7 * height / 8);
    }

    noLoop();
    // redraw();

}

void draw()
{
    background(0);

    fill(255);
    stroke(255);

    for (int i = 0; i < nb_points; i++) {
        p = points[i];
        ellipse(p.x, p.y, 5, 5);
    }

    fill(0, 255, 0);
    stroke(0, 255, 0);

    PVector ch[] = findCH(points);
    int s = ch.size();
    for (int i = 0; i < s; i++) {
        // println("ch: " + str(i) + "\t" + str(ch.get(i)));
        PVector p = ch.get(i);
        ellipse(p.x, p.y, 5, 5);
        PVector q = ch.get((i + 1) % s);
        line(p.x, p.y, q.x, q.y);
    }

    // special case : red point (movable by user)
    fill(255, 0, 0);
    stroke(255, 0, 0);
    lastP = points[nb_points - 1];
    ellipse(lastP.x, lastP.y, 5, 5);

    fill(255);
    stroke(255);
    text("Left-click anywhere to generate a new set of points.\nRight-click to move the red point to a new position", 10, height - 30)
}

void mousePressed()
{
    if (mouseButton == LEFT) {
        for (int i = 0; i < nb_points; i++) {
            points[i] = new PVector;
            points[i].x = random(width / 8, 7 * width / 8);
            points[i].y = random(height / 8 , 7 * height / 8);
        }
        redraw();
    }
    else if (mouseButton == RIGHT) {
        points[nb_points - 1].x = mouseX;
        points[nb_points - 1].y = mouseY;
        redraw();
    }
}

void orderPoints(PVector chPoints[])
// return chPoints in counter-clockwise order.
// Assume chPoints are points of a convex hull
{
    int firstP = findLeftMost(chPoints);

}

int findLeftMost(PVector points[])
{
    int firstP = 0;
    for (int i = 0; i < points.length; i++) {
        if (points[i].x < points[firstP].x) {
            firstP = i;
        }
    }
    return firstP;
}

void findCH(PVector points[])
{
    int l = points.length;
    // println("l: " + str(l));
    int firstP = findLeftMost(points);
    // Find the other points of CH iteratively
    // The next point nexP is the only one for which all other points are on the left of the segment [curP, nexP]
    ArrayList chPoints = new ArrayList();
    chPoints.add(points[firstP]);
    int curP = firstP;
    do {
        // println("curP: " + str(curP));
        int nexP = -1;
        // for every other point
        for (int i = 0; i < l; i++) {
            if (i == curP) {
                continue;
            }
            PVector p = points[i];
            // println("\t i: " + str(i) + "\tp: " + str(p));
            PVector v1 = new PVector(p.x - points[curP].x, p.y - points[curP].y);
            boolean foundRight = false;
            // check if all other points are on the left of [p,q]
            for (int j = 0; j < l; j++) {
                if (j == i || j == curP) {
                    continue;
                }
                PVector q = points[j];
                // println("\t\tj: " + str(j) + "q: " + str(q));
                PVector v2 = new PVector(q.x - p.x, q.y - p.y);
                if (!isLeftTurn(v1, v2)) {
                    // println("\t\tfound Right point: " + str(j))
                    foundRight = true;
                    break;
                }
            }

            if (!foundRight) {
                nexP = i;
                break;
            }
        }
        chPoints.add(points[nexP]);
        curP = nexP;
    } while (curP != -1 && curP != firstP);
    return chPoints;
}
