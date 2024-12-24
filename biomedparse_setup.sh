#!/bin/bash

set -e  # exit immediately for non-zero termination status.
set -o pipefail  # allow pip as failing errors.

# source shell config (else it runs a different process)
source ~/.bashrc  # replace with ~/.zshrc (or other rc files) if using other shell files.

echo "================================================"
echo "Setting up BioMedParse"
echo "================================================"

# Run using a custom environment
CONDA_CMD=$1

echo "Using package manager: '$CONDA_CMD'"

# Ensure the script is being run in an activated environment
if [ -z "$CONDA_PREFIX" ]; then
    echo "Error: Please activate a conda environment before running this script."
    exit 1
fi

echo "Using environment: $CONDA_PREFIX"

echo "------------------------------------------------"
echo "Step 1: Installing PyTorch and CUDA dependencies"
echo "------------------------------------------------"
$CONDA_CMD install -y -q pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia

echo "------------------------------------------------"
echo "Step 2: Installing GCC and MPI dependencies"
echo "------------------------------------------------"
$CONDA_CMD install -y -q gxx_linux-64=12 mpi4py openmpi -c conda-forge

echo "------------------------------------------------"
echo "Step 3: Setting up compilers"
echo "------------------------------------------------"
export CC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-cc"
export CXX="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-c++"

echo "CC set to: $CC"
echo "CXX set to: $CXX"

echo "------------------------------------------------"
echo "Step 4: Installing Python requirements"
echo "------------------------------------------------"
pip install --quiet -r assets/requirements/requirements.txt

echo "------------------------------------------------"
echo "Step 5: Installing torch_em"
echo "------------------------------------------------"
$CONDA_CMD install -y -q torch_em -c conda-forge

echo "------------------------------------------------"
echo "Step 6: Upgrading tifffile"
echo "------------------------------------------------"
pip install --quiet --upgrade tifffile

echo "------------------------------------------------"
echo "Step 7: Install BioMedParse"
echo "------------------------------------------------"
pip install --quiet -e .

echo "================================================"
echo "BioMedParse setup completed successfully!"
echo "================================================"
