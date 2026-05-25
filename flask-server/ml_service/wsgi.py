"""WSGI entrypoint for production servers"""
import os

# Set TensorFlow environment variables before any imports
os.environ.setdefault('TF_CPP_MIN_LOG_LEVEL', '2')
os.environ.setdefault('TF_ENABLE_ONEDNN_OPTS', '0')
os.environ.setdefault('CUDA_VISIBLE_DEVICES', '-1')

from . import create_app

app = create_app()

