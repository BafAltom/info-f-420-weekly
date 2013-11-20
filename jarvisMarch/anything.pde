int nb_points = 100;
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

    // noLoop();
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

    // special case : red point (movable by user)
    lastP = points[nb_points - 1];
    lastP.x = mouseX;
    lastP.y = mouseY;

    PVector ch[] = findCH(points);
    int s = ch.size();
    for (int i = 0; i < s; i++) {
        // println("ch: " + str(i) + "\t" + str(ch.get(i)));
        PVector p = ch.get(i);
        ellipse(p.x, p.y, 5, 5);
        PVector q = ch.get((i + 1) % s);
        line(p.x, p.y, q.x, q.y);
    }

    fill(255, 0, 0);
    stroke(255, 0, 0);
    lastP = points[nb_points - 1];
    ellipse(lastP.x, lastP.y, 5, 5);

    fill(255);
    stroke(255);
    text("Left-click anywhere to generate a new set of points.\nMove the mouse around to move the red point", 10, height - 30)
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
    // else if (mouseButton == RIGHT) {
    //     points[nb_points - 1].x = mouseX;
    //     points[nb_points - 1].y = mouseY;
    //     redraw();
    // }
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
    int firstPindex = findLeftMost(points);
    // Find the other points of CH iteratively
    // The next point nexP is the only one for which all other points are on the left of the segment [curP, nexP]
    ArrayList chPoints = new ArrayList();
    chPoints.add(points[firstPindex]);
    int curPindex = firstPindex;
    // iteratively find points of the convex hull until we come back to firstP
    do {
        nexPindex = null;
        for (int endPindex = 0; endPindex < l; endPindex++)
        {
            if (endPindex == curPindex) {
                continue;
            }
            if (nexPindex == null) {
                nexPindex = endPindex;
                continue;
            }
            // if curP nexP endP form a right turn, replace nexP by endP
            PVector curP = points[curPindex];
            PVector nexP = points[nexPindex];
            PVector endP = points[endPindex];
            PVector v1 = new PVector(nexP.x - curP.x, nexP.y - curP.y);
            PVector v2 = new PVector(endP.x - nexP.x, endP.y - nexP.y);
            if (!isLeftTurn(v1, v2)) {
                nexPindex = endPindex;
            }
        }
        chPoints.add(points[nexPindex]);
        curPindex = nexPindex;
    } while (curPindex != firstPindex && curPindex != null);
    return chPoints;
}
