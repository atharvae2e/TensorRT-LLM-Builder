#!/usr/bin/bash
set -e

source /app/scripts/e2e_scripts/variables.sh

tir_logger "Model Information" 
tir_logger "DOWNLOAD_SOURCE: $DOWNLOAD_SOURCE" 
tir_logger "MODEL_REPO_PATH: $MODEL_REPO_PATH" 
tir_logger "MODEL_FILE_FORMAT: $MODEL_FILE_FORMAT" 
tir_logger "BUILDER_DIR: $BUILDER_DIR" 
tir_logger "MODEL_FILES_PATH: $MODEL_FILES_PATH" 
tir_logger "HUGGINGFACE_CACHE_DIR: $HUGGINGFACE_CACHE_DIR" 
tir_logger "MODEL_REPO_PATH: $MODEL_REPO_PATH" 
tir_logger "CHECKPOINT_DIR: $CHECKPOINT_DIR" 
tir_logger "UNIFIED_CHECKPOINT_DIR: $UNIFIED_CHECKPOINT_DIR" 
tir_logger "ENGINE_DIR: $ENGINE_DIR" 
tir_logger "TOKENIZER_DIR: $TOKENIZER_DIR" 
tir_logger "MODEL_SCRIPTS_DIR: $MODEL_SCRIPTS_DIR" 
tir_logger "INFLIGHT_BATCHER_MODELS_DIR: $INFLIGHT_BATCHER_MODELS_DIR"
tir_logger "VOCAB_FILE_PATH: $VOCAB_FILE_PATH"

tir_logger "Advanced Parameters" 
tir_logger "WORKERS: $WORKERS" 
tir_logger "WORLD_SIZE: $WORLD_SIZE" 
tir_logger "ACTIVATION_DTYPE: $ACTIVATION_DTYPE" 
tir_logger "MAX_BATCH_SIZE: $MAX_BATCH_SIZE" 
tir_logger "MAX_INPUT_LEN: $MAX_INPUT_LEN" 
tir_logger "MAX_OUTPUT_LEN: $MAX_OUTPUT_LEN" 
tir_logger "MAX_BEAM_WIDTH: $MAX_BEAM_WIDTH" 
tir_logger "MAX_NUM_TOKENS: $MAX_NUM_TOKENS" 
tir_logger "OPT_NUM_TOKENS: $OPT_NUM_TOKENS" 
tir_logger "PP_SIZE: $PP_SIZE" 
tir_logger "TP_SIZE: $TP_SIZE" 

tir_logger "Removing Old model files from the PVC"
rm -rf ${BUILDER_DIR}
rm -rf ${TRITON_MODEL_REPO}
tir_logger "Old model files removed from the PVC"


tir_logger "Creating Directories"
mkdir -p ${BUILDER_DIR}
mkdir -p ${CHECKPOINT_DIR}
mkdir -p ${TOKENIZER_DIR}
mkdir -p ${UNIFIED_CHECKPOINT_DIR}
mkdir -p ${ENGINE_DIR}
mkdir -p ${TRITON_MODEL_REPO}
mkdir -p ${HUGGINGFACE_CACHE_DIR}
tir_logger "Directory Creation Completed"

if [[ "$DOWNLOAD_SOURCE" == "HUGGINGFACE" ]]; then
    tir_logger "Model Checkpoint Download Started"
    /app/scripts/e2e_scripts/download_checkpoint.sh
    tir_logger "Model Checkpoint Download Completed"
fi

tir_logger "Copy Tokenizer.model to TOKENIZER_DIR" 
cp ${CHECKPOINT_DIR}/tokenizer.model ${TOKENIZER_DIR} 
cp ${CHECKPOINT_DIR}/tokenizer.json ${TOKENIZER_DIR} 
cp ${CHECKPOINT_DIR}/tokenizer_config.json ${TOKENIZER_DIR} 
tir_logger "Copied! Tokenizer.model to TOKENIZER_DIR"

if [[ "$MODEL_FILE_FORMAT" == "CHECKPOINT" ]]; then
    tir_logger "Engine Creation Process Started" 
    /app/scripts/e2e_scripts/create_engine.sh
    tir_logger "Engine Creation Process Completed" 
fi


if [ "$RUN_TEST" = "true" ]; then
    tir_logger "Running Test Inference on Build Engine"
    /app/scripts/e2e_scripts/test_inference.sh
else
    tir_logger "Skipping Testing of Build Engine. To test Build Engine set environment variable RUN_TEST=true"
fi

/app/scripts/e2e_scripts/build_model_repo.sh

exit 0
