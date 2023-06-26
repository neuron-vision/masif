#!/bin/bash -l
masif_root=/masif
masif_source=$masif_root/source/
masif_matlab=$masif_root/source/matlab_libs/
export PYTHONPATH=$PYTHONPATH:$masif_source

python -u $masif_source/masif_ligand/masif_ligand_evaluate_test.py
