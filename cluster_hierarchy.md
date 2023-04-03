
# Table of Contents



-**- mode: Org; fill-column: 85; -**-

<https://www.youtube.com/watch?v=Oeon9f-Xx78&list=PLYpF5d40XgQODkJztO4saO_k_1LTi2YMk&index=3>

    import pandas as pd
    import numpy as np
    from scipy.cluster.vq import whiten
    from scipy.spatial.distance import pdist
    from scipy.spatial.distance import squareform


    v1=list("0101010101010101") # 2
    v2=list("0202020202010101") # 3
    v3=list("0202020212121212") # 3

    df = pd.DataFrame({"v1":v1, "v2":v2, "v3":v3}).astype(int)

    numbers_prepared = whiten( obs = df ) # divided by standard deviation per feature

    dist= pdist(X=numbers_prepared, metric='euclidean')
    # dist= pdist(X=df, metric='euclidean')

    sq = squareform(dist)
    print("we have 16 observations, df.shape:", df.shape)
    print("column 1, row 0 is distance between and 0 and 1 or 1 and 0 observation")
    print("triangle is a one dimension comparision")
    print(np.triu(np.round(sq,0)))

    from scipy.cluster.hierarchy import linkage, dendrogram
    l = linkage(y=df, method='complete', metric='jaccard', optimal_ordering=False)
    [print(i+len(df), np.round(x,1)) for i, x in enumerate(l)]

    # --- Cophenetic correlation
    from scipy.cluster.hierarchy import cophenet
    a = cophenet(Z=l, Y=dist)
    print(a[0])
    # print(a[1])
    print(np.round(a[1],1))


    from matplotlib import pyplot as plt
    dendrogram(Z=l, p=1.1, truncate_mode='level', labels=df.index, count_sort=False, distance_sort=False, orientation='right', leaf_font_size=15)
    plt.savefig('1.png')
    plt.close()
