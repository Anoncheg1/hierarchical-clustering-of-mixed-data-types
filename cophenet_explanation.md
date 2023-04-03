
# Table of Contents



-**- mode: Org; fill-column: 85; -**-

:results file graphics :file 1.png

    from scipy.spatial.distance import pdist
    from scipy.spatial.distance import squareform
    import numpy as np
    from scipy.cluster.hierarchy import single, cophenet
    X = [[0, 0], [0, 1], [1, 0],
    [0, 4], [0, 3], [1, 4],
    [4, 0], [3, 0], [4, 1],
    [4, 4], [3, 4], [4, 3]]
    # shape of X:
    # x x x x
    # x     x
    # x     x
    # x x x x
    print(X)

    Z = pdist(X)
    Z2 = squareform(Z)
    print("Distances:")
    print(np.round(Z2,0))
    print()

    C = cophenet(single(Z), Z)
    print("Cophenet coefficient:", C[0])
    print()
    print("Cophenet matrix:")
    C2 = squareform(C[1])
    C3 = np.triu(C2)
    print(C3)
