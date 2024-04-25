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

tir_logger "TEST 1: Inference request request with default parameters"
mpirun -n ${WORLD_SIZE} --allow-run-as-root  \
        python3 ${MODEL_SCRIPTS_DIR}/../run.py  \
            --engine_dir  ${ENGINE_DIR} \
            --tokenizer_dir ${TOKENIZER_DIR} \
            --max_output_len ${MAX_OUTPUT_LEN} \
            --input_text "In python, write a function for binary searching an element in an integer array."

tir_logger "TEST 2: Runs summarization on cnn_dailymail dataset and evaluate the model by ROUGE scores and use the ROUGE-1 score to validate the implementation."
mpirun -n  ${WORLD_SIZE} --allow-run-as-root \
        python3 ${MODEL_SCRIPTS_DIR}/../summarize.py --test_trt_llm \
            --hf_model_dir ${TOKENIZER_DIR} \
            --data_type fp16 \
            --engine_dir  ${ENGINE_DIR}
