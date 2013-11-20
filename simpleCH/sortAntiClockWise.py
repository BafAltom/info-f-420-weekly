import numpy as np
import math
import random
import pylab


def orderPoints(points):
    """
        Points is a list of np.array([x,y]) describing the vertices of a convex
        polygon in a random order.
        This function returns the same vertices in anticlockwise order
    """
    leftMost = points[0]
    for p in points:
        if p[0] < leftMost[0]:
            leftMost = p

    def sortFunction(vertex):
        v = np.array([vertex[0] - leftMost[0], vertex[1] - leftMost[1]])
        v = v / np.linalg.norm(v)
        return np.cross(np.array([1, 0]), v)

    return sorted(points, key=sortFunction)


points = []
for i in range(2 * math.floor(math.pi * 10)):
    points.append(np.array([math.cos(i / 10), math.sin(i / 10)]))
random.shuffle(points)
X = []
Y = []
for p in orderPoints(points):
    X.append(p[0])
    Y.append(p[1])

pylab.plot(X, Y)
pylab.show()
