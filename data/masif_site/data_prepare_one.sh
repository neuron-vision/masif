#!/bin/bash
masif_root=/masif
masif_source=$masif_root/source/
masif_matlab=$masif_root/source/matlab_libs/
export PYTHONPATH=$PYTHONPATH:$masif_source
export masif_matlab

output_folder="/masif/data/masif_site/data_preparation/04a-precomputation_9A/precomputation/"
filename="$1"

full_path="${output_folder}${filename}"
echo "Full path:" $full_path

if [ -d $full_path ]; then
    echo "File ${filename} already exists in ${output_folder}. Skipping."
else
	if [ "$1" == "--file" ]
	then
		echo "Running masif site on $2"
		PPI_PAIR_ID=$3
		PDB_ID=$(echo $PPI_PAIR_ID| cut -d"_" -f1)
		CHAIN1=$(echo $PPI_PAIR_ID| cut -d"_" -f2)
		CHAIN2=$(echo $PPI_PAIR_ID| cut -d"_" -f3)
		FILENAME=$2
		mkdir -p data_preparation/00-raw_pdbs/
		cp $FILENAME data_preparation/00-raw_pdbs/$PDB_ID\.pdb
	else
		PPI_PAIR_ID=$1
		PDB_ID=$(echo $PPI_PAIR_ID| cut -d"_" -f1)
		CHAIN1=$(echo $PPI_PAIR_ID| cut -d"_" -f2)
		CHAIN2=$(echo $PPI_PAIR_ID| cut -d"_" -f3)
		echo $PPI_PAIR_ID
		python -W ignore $masif_source/data_preparation/00-pdb_download.py $PPI_PAIR_ID
	fi

	if [ -z $CHAIN2 ]
	then
		echo "Empty"
		python -W ignore $masif_source/data_preparation/01-pdb_extract_and_triangulate.py $PDB_ID\_$CHAIN1
	else
		python -W ignore $masif_source/data_preparation/01-pdb_extract_and_triangulate.py $PDB_ID\_$CHAIN1
		python -W ignore $masif_source/data_preparation/01-pdb_extract_and_triangulate.py $PDB_ID\_$CHAIN2
	fi
	python $masif_source/data_preparation/04-masif_precompute.py masif_site $PPI_PAIR_ID
fi