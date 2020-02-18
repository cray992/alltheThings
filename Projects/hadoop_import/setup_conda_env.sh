#!/bin/bash
echo export PYTHONPATH=.
export PYTHONPATH=.

condaDir=$HOME/miniconda
condaBinDir=$condaDir/bin

echo $condaBinDir/conda env update --name hadoop-import # This creates the env if it does not exists
$condaBinDir/conda env update --name hadoop-import

echo source $condaBinDir/activate hadoop-import
source $condaBinDir/activate hadoop-import
