import joblib
import numpy as np
import sys
import ast

model = joblib.load(sys.argv[2])
chosen_rows = np.array([ast.literal_eval(sys.argv[1])])
centroid = np.mean(chosen_rows, axis=0).reshape(1, -1)
predicted_cluster = model.predict(centroid)[0]

cluster_indices = np.where(model.labels_ == predicted_cluster)[0]
print(cluster_indices)
