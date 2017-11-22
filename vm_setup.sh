#!/bin/sh
cd ~
git clone https://github.com/tensorflow/benchmarks.git
cd benchmarks/scripts/tf_cnn_benchmarks
# the following is necessary to avoid an import error in TensorFlow 1.4, and
# means we can only look at synthetic data
sed -i -e "s/\(from tensorflow.contrib.data.python.ops import interleave_ops\)/#\1/" preprocessing.py

