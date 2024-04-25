#!/usr/bin/bash 
set -e
source /app/scripts/e2e_scripts/variables.sh

tir_logger "Installing Engine Creation Dependencies" 
pip3 install -r ${MODEL_SCRIPTS_DIR}/requirements.txt 
tir_logger "Converting Checkpoint to unified TensorRT-LLM checkpoint" 


python3 ${MODEL_SCRIPTS_DIR}/convert_checkpoint.py --model_dir ${CHECKPOINT_DIR}  \
                            --output_dir ${UNIFIED_CHECKPOINT_DIR} \
                            --dtype ${ACTIVATION_DTYPE} \
                            --tp_size ${TP_SIZE} \
                            --pp_size ${PP_SIZE} \
                            --workers ${WORKERS}



tir_logger "Unified TensorRT-LLM Checkpoint Created" 


if [[ "$DOWNLOAD_SOURCE" == "HUGGINGFACE" ]]; then
    tir_logger "Model Checkpoint Deletion Started" 
    rm -rf ${CHECKPOINT_DIR} 
    tir_logger "Model Checkpoint Deletion Completed"
fi

 

tir_logger "Engine Creation started using unified TensorRT-LLM checkpoint" 


if [[ -z "$GPU_TYPE" ]]; then
    trtllm-build --checkpoint_dir ${UNIFIED_CHECKPOINT_DIR} \
                 --output_dir ${ENGINE_DIR} \
                 --gemm_plugin ${ACTIVATION_DTYPE} \
                 --max_batch_size ${MAX_BATCH_SIZE} \
                 --max_input_len ${MAX_INPUT_LEN} \
                 --max_output_len ${MAX_OUTPUT_LEN} \
                 --max_beam_width ${MAX_BEAM_WIDTH} \
                 --max_num_tokens ${MAX_NUM_TOKENS} \
                 --opt_num_tokens ${OPT_NUM_TOKENS} \
                 --pp_size ${PP_SIZE} \
                 --tp_size ${TP_SIZE}  \
                 --workers ${WORKERS} \
                 --use_custom_all_reduce disable
else 
    trtllm-build --checkpoint_dir ${UNIFIED_CHECKPOINT_DIR} \
                 --output_dir ${ENGINE_DIR} \
                 --cluster_key ${GPU_TYPE} \
                 --gemm_plugin ${ACTIVATION_DTYPE} \
                 --max_batch_size ${MAX_BATCH_SIZE} \
                 --max_input_len ${MAX_INPUT_LEN} \
                 --max_output_len ${MAX_OUTPUT_LEN} \
                 --max_beam_width ${MAX_BEAM_WIDTH} \
                 --max_num_tokens ${MAX_NUM_TOKENS} \
                 --opt_num_tokens ${OPT_NUM_TOKENS} \
                 --pp_size ${PP_SIZE} \
                 --tp_size ${TP_SIZE}  \
                 --workers ${WORKERS} \
                 --use_custom_all_reduce disable
fi 

tir_logger "Engine Created" 

tir_logger "Unified Checkpoint Deletion Started" 
rm -rf ${UNIFIED_CHECKPOINT_DIR} 
tir_logger "Unified Checkpoint Deletion Completed"


