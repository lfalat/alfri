import joblib
import numpy as np
import sys
import ast
import warnings
from sklearn.exceptions import InconsistentVersionWarning

with warnings.catch_warnings():
    warnings.simplefilter("ignore", InconsistentVersionWarning)

    model = joblib.load(sys.argv[2])
    chosen_rows = np.array(ast.literal_eval(sys.argv[1]))
    centroid = np.mean(chosen_rows, axis=0).reshape(1, -1)
    predicted_cluster = model.predict(centroid)[0]

    cluster_indices = np.where(model.labels_ == predicted_cluster)[0]
    print(cluster_indices)

# ak chceme robit pre kazdy predmet predikciu zvlast a vysledky spojit
# import joblib
# import numpy as np
# import sys
# import ast
#
# # Load the pre-trained KMeans model
# model = joblib.load(sys.argv[2])
#
# # Parse the input chosen_rows from command-line argument and convert to numpy arrays
# chosen_rows_list = ast.literal_eval(sys.argv[1])
# chosen_rows = np.array(chosen_rows_list)
#
# # Initialize an empty list to store all predicted cluster indices
# all_cluster_indices = []
#
# # Iterate over each set of chosen_rows
# for chosen_rows in chosen_rows_list:
#     # Convert chosen_rows to numpy array and reshape if necessary
#     chosen_rows = np.array(chosen_rows)
#     if chosen_rows.ndim == 1:
#         chosen_rows = chosen_rows.reshape(1, -1)
#
#     # Calculate the centroid of chosen_rows
#     centroid = np.mean(chosen_rows, axis=0).reshape(1, -1)
#
#     # Predict the cluster for the centroid
#     predicted_cluster = model.predict(centroid)[0]
#
#     # Find indices of subjects belonging to the predicted cluster
#     cluster_indices = np.where(model.labels_ == predicted_cluster)[0]
#
#     # Append the indices to all_cluster_indices
#     all_cluster_indices.extend(cluster_indices)
#
# # Convert to numpy array to ensure uniqueness and then get distinct values
# distinct_cluster_indices = np.unique(all_cluster_indices)
# print(distinct_cluster_indices)
