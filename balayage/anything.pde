import java.util.TreeSet
PFont font, bigFont;
rectMode(CORNER);
nb_rectangle = 10;
ArrayList<ArrayList<int> > rectangles = new ArrayList<ArrayList<int> >(); // 1 rectangle: {xTopLeft, yTopLeft, width, height}
PVector mouseP = null;

void setup()
{
    size(800, 600);
    font = createFont("Arial", 16, true);
    bigFont = createFont("Arial", 72, true);
    for (int i = 0; i < nb_rectangle; i++)
    {
        int x = random(width / 8, 7 * width / 8);
        int y = random(height / 8, 7 * height / 8);
        int w = random(10, width - x);
        int h = random(10, height - y);
        ArrayList<int> rec = new ArrayList<int>();
        rec.add(x);
        rec.add(y);
        rec.add(w);
        rec.add(h);
        rectangles.add(rec);
    }

}

void draw()
{
    textFont(font);
    background(0);

    stroke(255);
    fill(255,255,255,50);
    for (ArrayList<int> rec : rectangles) {
        rect(rec.get(0), rec.get(1), rec.get(2), rec.get(3));
    }
}

void mousePressed()
{

}


