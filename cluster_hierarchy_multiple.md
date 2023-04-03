
# Table of Contents



-**- mode: Org; fill-column: 85; -**-
<https://www.youtube.com/watch?v=Oeon9f-Xx78&list=PLYpF5d40XgQODkJztO4saO_k_1LTi2YMk&index=3>

    :results file graphics :file 1.png

    import numpy as np
    import pandas as pd
    from scipy.spatial.distance import pdist
    from scipy.cluster.vq import whiten
    from scipy.spatial.distance import squareform
    from scipy.cluster.hierarchy import linkage, dendrogram
    from scipy.cluster.hierarchy import cophenet
    from scipy.cluster.hierarchy import cut_tree
    # ------------ dataset -----------------------
    v1=list("0101010101010101") # 2
    v2=list("0202020202010101") # 3
    v3=list("0202020212121212") # 3
    df = pd.DataFrame({"v1":v1, "v2":v2, "v3":v3}).astype(int)

    # ----------- scale  -----------
    numbers_prepared = whiten( obs = df )

    # ----------- metric, method -------------------
    list_metric = ['braycurtis', 'canberra', 'chebyshev', 'cityblock',
            'correlation', 'cosine', 'dice', 'euclidean', 'hamming',
            'jaccard', 'jensenshannon', 'kulczynski1',
            'mahalanobis', 'matching', 'minkowski', 'rogerstanimoto',
            'russellrao', 'seuclidean', 'sokalmichener', 'sokalsneath',
            'sqeuclidean', 'yule']

    list_method = [ 'single', 'complete', 'average', 'weighted', 'centroid', 'median', 'ward' ]

    # ---------- Calc all distances
    dict_pdist = {}
    for r in list_metric:
        dict_pdist[r] = pdist(
            X = numbers_prepared,
            metric = r
        )

    # ---------- Calc all linkages
    dict_linkage = {}
    for r in list_metric:
        dict_linkage[r] = {}
        for h in list_method:
            d = np.where(np.isinf(dict_pdist[r]), 9999, dict_pdist[r])
            d =np.where(np.isnan(d), 0, d)
            dict_linkage[r][h] = linkage(
                y = d,
                method = h,
                metric = r,
                optimal_ordering = True
            )

    # ---------- Calc cophentic correlation
    dict_cophenet = {}
    for metric in dict_linkage.keys():
        for method in dict_linkage[metric].keys():
            l = np.where(np.isinf(dict_linkage[metric][method]), 9999, dict_linkage[metric][method])
            l =np.where(np.isnan(l), 0, l)
            c = cophenet(
                Z = l,
                Y = dict_pdist[metric]
            )[0]
            dict_cophenet[metric + '_' + method] = {
                'metric': metric,
                'method': method,
                'cophentic_correlation_distance': c
            }

    df_cophenet: pd.DataFrame = pd.DataFrame(dict_cophenet).T
    df_cophenet = df_cophenet.sort_values( by = 'cophentic_correlation_distance' , ascending=False)
    # - filter metric=braycurtis, dice, correlation, jensenshannon, cosine, etc.
    df_cophenet = df_cophenet.dropna(subset = ['cophentic_correlation_distance'])
    print(df_cophenet.to_string())
    print()

    # --- dendrogram
    from matplotlib import pyplot as plt
    metric, method = 'hamming', 'average'
    v = dendrogram(Z=dict_linkage[metric][method], p=1.1, truncate_mode='level', labels=df.index, count_sort=False, distance_sort=False, orientation='right', leaf_font_size=15)
    plt.savefig('1.png')

    # --- get cluster labels at level
    metric, method = 'hamming', 'average'
    h = 0.6
    labels = cut_tree(
        Z = dict_linkage[metric][method],
        height=h
    )
    print("Cluster labels at:", h)
    print(labels.T)

    # --- compare two cluster labels

![img](/home/u/proj_python/1.png "output image for source block above")
