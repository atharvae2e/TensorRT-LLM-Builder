#!/usr/bin/bash 
set -e
source /app/scripts/e2e_scripts/variables.sh

tir_logger "Installing Huggingface cli" 
pip install -U "huggingface_hub[cli]" "huggingface_hub[hf_transfer]"
tir_logger "Authenticating Huggingface User: " 
huggingface-cli whoami

huggingface-cli download ${HF_MODEL_ID} \
        --local-dir ${CHECKPOINT_DIR} \
        --local-dir-use-symlinks False 

