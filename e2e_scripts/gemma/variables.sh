#!/usr/bin/bash 
set -e

tir_logger() {
    echo "[$(date +'%m/%d/%Y-%H:%M:%S')] [TIR Builder] $1"
}

if [[ -z "$MODEL_PATH" ]]; then

    echo "Error: MODEL_PATH is not set. " >&2 
    exit 1  
fi

if [[ -z "$WORLD_SIZE" ]]; then
    WORLD_SIZE=1
fi
if [[ -z "$ACTIVATION_DTYPE" ]]; then
    ACTIVATION_DTYPE=bfloat16
fi
if [[ -z "$MAX_BATCH_SIZE" ]]; then
    MAX_BATCH_SIZE=8
fi
if [[ -z "$MAX_INPUT_LEN" ]]; then
    MAX_INPUT_LEN=3000
fi
if [[ -z "$MAX_OUTPUT_LEN" ]]; then
    MAX_OUTPUT_LEN=100
fi




MODEL_NAME=$(echo ${MODEL_PATH} | awk -F'/' '{print $2}')
VARIATION_NAME=$(echo ${MODEL_PATH} | awk -F'/' '{print $4}')
FRAMEWORK=$(echo ${MODEL_PATH} | awk -F'/' '{print $3}')

if [ "${FRAMEWORK}" = "pyTorch" ]; then
    FRAMEWORK="torch"
else
    echo "Error: Unsupported framework in MODEL_PATH. Only pyTorch frameworks checkpoints on kaggle are supported." >&2 
    exit 1  
fi

CHECKPOINT_DIR=/mnt/models/checkpoint/${MODEL_NAME}_${VARIATION_NAME}_${FRAMEWORK}_${ACTIVATION_DTYPE}
UNIFIED_CHECKPOINT_DIR=/mnt/models/unified/${MODEL_NAME}_${VARIATION_NAME}_${FRAMEWORK}_${ACTIVATION_DTYPE}
ENGINE_DIR=/mnt/models/engine/${MODEL_NAME}_${VARIATION_NAME}_${FRAMEWORK}_${ACTIVATION_DTYPE}
TOKENIZER_DIR=/mnt/models/tokenizer/${MODEL_NAME}_${VARIATION_NAME}_${FRAMEWORK}_${ACTIVATION_DTYPE}
VOCAB_FILE_PATH=${TOKENIZER_DIR}/tokenizer.model
MODEL_SCRIPTS_DIR=/app/tensorrt_llm/examples/gemma
INFLIGHT_BATCHER_MODELS_DIR=/app/inflight_batcher_llm_models
TRITON_MODEL_REPO=/mnt/models/triton/${MODEL_NAME}_${VARIATION_NAME}_${FRAMEWORK}_${ACTIVATION_DTYPE}/model_repository
TOOLS_DIR=/app/tools