# source:
#   https://github.com/Darkprogrammerpb/DeepLearningProjects/blob/master/Project38/Affinity%20Propagation/affinityprop.ipynb
#   https://towardsdatascience.com/unsupervised-machine-learning-affinity-propagation-algorithm-explained-d1fef85f22c8
import numpy as np
import logging

L = logging.getLogger(__name__)

# for windows user,
# install this first: https://aka.ms/vs/16/release/vs_buildtools.exe (~96 Mb)
# import matplotlib.pyplot as plt


class APC(object):
	def __init__(self, n_iters=5, similarity_matrix=None):
		# Set default values
		self.n_iters = n_iters
		self.damping = 0.5  # damping factor, default 0.5
		# self.damping = 0.8
		self._cluster_labels = []

		if similarity_matrix is None:
			self.similarity_matrix = self.dummy_similarity_matrix()
		else:
			self.similarity_matrix = np.asarray(similarity_matrix)

		# calculate total number of object to be compared with
		# i.e. Total number of UAVs
		self._obj_num = self.similarity_matrix.shape[0]

	def dummy_similarity_matrix(self):
		_dummy_data = np.array([
			[3, 4, 3, 2, 1],
			[4, 3, 5, 1, 1],
			[3, 5, 3, 3, 3],
			[2, 1, 3, 3, 2],
			[1, 1, 3, 2, 3]
		])
		_similarity_matrix = np.zeros((_dummy_data.shape[0], _dummy_data.shape[0]))
		for i in range(_dummy_data.shape[0]):
			for j in range(_dummy_data.shape[0]):
				_similarity_matrix[i, j] = -1 * (_dummy_data[i] - _dummy_data[j]).T.dot(_dummy_data[i] - _dummy_data[j])
		digval = _similarity_matrix.min()
		return np.array(
			[
				[digval if i == j else _similarity_matrix[i, j] for j in range(_dummy_data.shape[0])]
				for i in range(_dummy_data.shape[0])
			]
		)

	def run(self):
		aff_matrix = np.zeros((self._obj_num, self._obj_num))
		resp_matrix = np.zeros((self._obj_num, self._obj_num))
		sim_matrix = self.similarity_matrix

		for n in range(self.n_iters):
			old_resp_matrix = resp_matrix.copy()
			old_aff_matrix = aff_matrix.copy()
			resp_matrix = self.update_resp_matrix(aff_matrix, sim_matrix, resp_matrix)
			aff_matrix = self.update_aff_matrix(resp_matrix, aff_matrix)
			if n != 0:
				resp_matrix, aff_matrix = self.update_lambda_a_r(resp_matrix, aff_matrix, old_resp_matrix, old_aff_matrix)
		decision_mat = aff_matrix + resp_matrix

		self._cluster_labels = [np.argmax(decision_mat[i]) for i in range(decision_mat.shape[0])]

	def get_cluster_head(self, to_list=True):
		L.warning("[Cluster Labels]={}".format(self._cluster_labels))
		if to_list:
			return (np.unique(self._cluster_labels)).tolist()
		else:
			return np.unique(self._cluster_labels)

	def calculate_resp_matrix_ik(self, a, s, k):
		"""
			Calculate Responsibility Matrix between object[i]'s similarity matrix and object[k]'s similarity matrix
			:param a: Affinity Matrix
			:param s: Similarity Matrix
			:param k: Index of object[k]'s similarity matrix

			:return: Responsibility Matrix between Object[i] and Object[k]
		"""
		s = list(s)
		a = list(a)
		sik = s[k]
		s_needed = np.array(s[:k] + s[k + 1:])
		a_needed = np.array(a[:k] + a[k + 1:])
		return sik - max(s_needed + a_needed)

	def calculate_aff_matrix_ik(self, r, k, i):
		rkk = r[k]
		r = list(r)
		vec = []
		r = np.array(r[:i] + r[i + 1:])
		for n in range(len(r)):
			vec.append(max(0, r[n]))
		if k == i:
			return sum(vec)
		else:
			return min(0, rkk + sum(vec))

	def update_resp_matrix(self, A, S, R):
		for i in range(self._obj_num):
			a = A[i, :]
			s = S[i, :]
			for k in range(self._obj_num):
				R[i, k] = self.calculate_resp_matrix_ik(a, s, k)
		return R

	def update_aff_matrix(self, R, A):
		for i in range(self._obj_num):
			for k in range(self._obj_num):
				r = R[:, k]
				A[i, k] = self.calculate_aff_matrix_ik(r, k, i)
		return A

	def update_lambda_a_r(self, R, A, R_old, A_old):
		R = self.damping * R_old + (1 - self.damping) * R
		A = self.damping * A_old + (1 - self.damping) * A
		return R, A


# # Example
# apc = APC()  # by sending an empty similarity matrix, it invokes a default dummy data
# apc.run()
# L.warning(">>>> Cluster Head: {}".format(apc.get_cluster_head()))
