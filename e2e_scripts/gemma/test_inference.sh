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

tir_logger "TEST 1: Runs summarization on cnn_dailymail dataset and evaluate the model by ROUGE scores and use the ROUGE-1 score to validate the implementation."
python3 ${MODEL_SCRIPTS_DIR}/../summarize.py --test_trt_llm \
                        --engine_dir ${ENGINE_DIR} \
                        --batch_size ${MAX_BATCH_SIZE} \
                        --max_ite 5 \
                        --vocab_file ${VOCAB_FILE_PATH}

tir_logger "TEST 2: Inference request request with default parameters"
python3 ${MODEL_SCRIPTS_DIR}/../run.py --engine_dir ${ENGINE_DIR} \
                  --max_output_len 200 \
                  --vocab_file ${VOCAB_FILE_PATH} \
                  --input_text "Explain in Detail, What is GPU ?"
