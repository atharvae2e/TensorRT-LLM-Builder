#!/usr/bin/bash 
set -e

tir_logger() {
    echo "[$(date +'%m/%d/%Y-%H:%M:%S')] [TIR Builder] $1"
}

if [[ "$DOWNLOAD_SOURCE" == "HUGGINGFACE" && -z "$HF_MODEL_ID" ]]; then

    echo "Error: HF_MODEL_ID is not set. " >&2 
    exit 1  
fi

DEFAULT_WORKERS=1
DEFAULT_WORLD_SIZE=1
DEFAULT_ACTIVATION_TYPE=float16
DEFAULT_MAX_BATCH_SIZE=1
DEFAULT_MAX_INPUT_LEN=1024
DEFAULT_MAX_OUTPUT_LEN=1024
DEFAULT_MAX_BEAM_WIDTH=1
DEFAULT_MAX_NUM_TOKENS=1024
DEFAULT_OPT_NUM_TOKENS=1
DEFAULT_PP_SIZE=1
DEFAULT_TP_SIZE=1
DEFAULT_HTTP_PORT=8080
DEFAULT_GRPC_PORT=9000
DEFAULT_METRIC_PORT=8082


WORKERS=${WORKERS:-${DEFAULT_WORKERS}}
ACTIVATION_DTYPE=${ACTIVATION_DTYPE:-${DEFAULT_ACTIVATION_TYPE}}
MAX_BATCH_SIZE=${MAX_BATCH_SIZE:-${DEFAULT_MAX_BATCH_SIZE}} 
MAX_INPUT_LEN=${MAX_INPUT_LEN:-${DEFAULT_MAX_INPUT_LEN}}
MAX_OUTPUT_LEN=${MAX_OUTPUT_LEN:-${DEFAULT_MAX_OUTPUT_LEN}}
MAX_BEAM_WIDTH=${MAX_BEAM_WIDTH:-${DEFAULT_MAX_BEAM_WIDTH}}
MAX_NUM_TOKENS=${MAX_NUM_TOKENS:-${DEFAULT_MAX_NUM_TOKENS}}
OPT_NUM_TOKENS=${OPT_NUM_TOKENS:-${DEFAULT_OPT_NUM_TOKENS}}
PP_SIZE=${PP_SIZE:-${DEFAULT_PP_SIZE}}
TP_SIZE=${TP_SIZE:-${DEFAULT_TP_SIZE}}
WORLD_SIZE=${WORLD_SIZE:-${DEFAULT_WORLD_SIZE}}
HTTP_PORT=${HTTP_PORT:-${DEFAULT_HTTP_PORT}}
GRPC_PORT=${GRPC_PORT:-${DEFAULT_GRPC_PORT}}
METRIC_PORT=${METRIC_PORT:-${DEFAULT_METRIC_PORT}}

if [[ -z "$BUILDER_DIR" ]]; then
    BUILDER_DIR=/mnt/models/builder
fi

if [[ -z "$MODEL_FILES_PATH" ]]; then
    MODEL_FILES_PATH=/mnt/models/bucket_files
fi

HUGGINGFACE_CACHE_DIR=${HF_HUB_CACHE:-/mnt/models/.cache}

if [[ "$DOWNLOAD_SOURCE" == "HUGGINGFACE" ]]; then
    CHECKPOINT_DIR=${BUILDER_DIR}/checkpoint/${WORLD_SIZE}_gpu_${ACTIVATION_DTYPE}
else 
    CHECKPOINT_DIR=${MODEL_FILES_PATH}
fi



UNIFIED_CHECKPOINT_DIR=${BUILDER_DIR}/unified/${WORLD_SIZE}_gpu_${ACTIVATION_DTYPE}

if [[ "$MODEL_FILE_FORMAT" == "ENGINE" ]]; then
    ENGINE_DIR=${MODEL_FILES_PATH}
    TOKENIZER_DIR=${MODEL_FILES_PATH}
else 
    ENGINE_DIR=${BUILDER_DIR}/engine/${WORLD_SIZE}_gpu_${ACTIVATION_DTYPE}
    TOKENIZER_DIR=${BUILDER_DIR}/tokenizer/${WORLD_SIZE}_gpu_${ACTIVATION_DTYPE}
fi
VOCAB_FILE_PATH=${TOKENIZER_DIR}/tokenizer.model
TRITON_MODEL_REPO=${MODEL_REPO_PATH}
MODEL_SCRIPTS_DIR=/app/tensorrt_llm/examples/llama
INFLIGHT_BATCHER_MODELS_DIR=/app/inflight_batcher_llm_models
TOOLS_DIR=/app/tools
