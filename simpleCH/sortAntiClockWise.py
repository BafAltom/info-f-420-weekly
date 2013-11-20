import numpy as np
a = np.array([1, 0])
b = np.array([0, 1])
print(np.cross(a, b))


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
        v = np.array([vertex[0] - leftMost[0], [vertex[1] - leftMost[1]]])
        return np.cross(np.array([1, 0], v))

    return sorted(points, sortFunction)
