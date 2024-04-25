#!/usr/bin/bash
set -e

source /app/scripts/e2e_scripts/variables.sh

tir_logger "Model Information" 
tir_logger "MODEL_PATH: $MODEL_PATH" 
tir_logger "WORLD_SIZE: $WORLD_SIZE" 
tir_logger "ACTIVATION_DTYPE: $ACTIVATION_DTYPE" 
tir_logger "MAX_BATCH_SIZE: $MAX_BATCH_SIZE" 
tir_logger "MAX_INPUT_LEN: $MAX_INPUT_LEN" 
tir_logger "MAX_OUTPUT_LEN: $MAX_OUTPUT_LEN" 
tir_logger "MODEL_NAME: $MODEL_NAME" 
tir_logger "VARIATION_NAME: $VARIATION_NAME" 
tir_logger "FRAMEWORK: $FRAMEWORK" 
tir_logger "CHECKPOINT_DIR: $CHECKPOINT_DIR" 
tir_logger "UNIFIED_CHECKPOINT_DIR: $UNIFIED_CHECKPOINT_DIR" 
tir_logger "ENGINE_DIR: $ENGINE_DIR" 
tir_logger "TOKENIZER_DIR: $TOKENIZER_DIR" 
tir_logger "MODEL_SCRIPTS_DIR: $MODEL_SCRIPTS_DIR" 
tir_logger "INFLIGHT_BATCHER_MODELS_DIR: $INFLIGHT_BATCHER_MODELS_DIR"
tir_logger "VOCAB_FILE_PATH: $VOCAB_FILE_PATH"

tir_logger "Creating Directories"
mkdir -p ${CHECKPOINT_DIR}
mkdir -p ${TOKENIZER_DIR}
mkdir -p ${UNIFIED_CHECKPOINT_DIR}
mkdir -p ${ENGINE_DIR}
tir_logger "Directory Creation Completed"

tir_logger "Removing Old model files from the PVC"
rm -rf ${CHECKPOINT_DIR}/*
rm -rf ${TOKENIZER_DIR}/*
rm -rf ${UNIFIED_CHECKPOINT_DIR}/*
rm -rf ${ENGINE_DIR}/*
tir_logger "Old model files removed from the PVC"

tir_logger "Model Checkpoint Download Started"
/app/scripts/e2e_scripts/download_checkpoint.sh
tir_logger "Model Checkpoint Download Completed"

tir_logger "Engine Creation Process Started" 
/app/scripts/e2e_scripts/create_engine.sh
tir_logger "Engine Creation Process Completed" 


if [ "$RUN_TEST" = "true" ]; then
    tir_logger "Running Test Inference on Build Engine"
    /app/scripts/e2e_scripts/test_inference.sh
else
    tir_logger "Skipping Testing of Build Engine. To test Build Engine set environment variable RUN_TEST=true"
fi


/app/scripts/e2e_scripts/build_run_server.sh

