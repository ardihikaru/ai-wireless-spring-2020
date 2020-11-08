#!/usr/bin/env python
from flask import Flask, request, abort, jsonify
import logging
from apc.original.apc import APC

L = logging.getLogger(__name__)

app = Flask(__name__)


@app.route('/algorithm/apc/original', methods=['POST'])
def apc_original():
    if not request.json:
        abort(400)
    
    req_json = request.json

    # L.warning(req_json)
    L.warning(req_json["similarity_matrix"])

    algorithm = "apc" if "algorithm" not in req_json else req_json["algorithm"]
    similarity_matrix = None if "similarity_matrix" not in req_json else req_json["similarity_matrix"]
    n_iters = 5 if "n_iters" not in req_json else req_json["n_iters"]

    L.warning("[n_iters]={}".format(n_iters))

    if algorithm == "apc":
        # using Original APC Algorithm
        apc = APC(
            n_iters=n_iters,
            similarity_matrix=similarity_matrix
        )
        apc.run()
        cluster_head = apc.get_cluster_head()
    else:
        # default: it is using Original APC Algorithm
        apc = APC(
            n_iters=n_iters,
            similarity_matrix=similarity_matrix
        )
        apc.run()
        cluster_head = apc.get_cluster_head()

    return jsonify(
        {
            'status': 'ok',
            'data': cluster_head
        }
    ), 200


if __name__ == '__main__':
    L.warning("APC Web Service is running (Author: M. Febrian Ardiansyah / 0880814)")
    app.run(debug=True, host='0.0.0.0', port=8085)
