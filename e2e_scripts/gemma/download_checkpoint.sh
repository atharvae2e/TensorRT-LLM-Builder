#!/usr/bin/bash 
set -e
source /app/scripts/e2e_scripts/variables.sh

tir_logger "Installing Kaggle Package" 
pip install kaggle --break-system-packages
kaggle models instances versions download ${MODEL_PATH} --untar -p ${CHECKPOINT_DIR} 


