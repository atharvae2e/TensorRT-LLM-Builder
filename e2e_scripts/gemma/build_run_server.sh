#!/usr/bin/bash
set -e
source /app/scripts/e2e_scripts/variables.sh

tir_logger "Preparing Tensorrt-LLM backend"
tir_logger "Creating Configuration Files"
mkdir -p ${TRITON_MODEL_REPO}
cp -r ${INFLIGHT_BATCHER_MODELS_DIR}/* ${TRITON_MODEL_REPO}
tir_logger "Updating Configuration Files"

TOKENIZER_FILE=${TOKENIZER_DIR}/tokenizer.model

python3 ${TOOLS_DIR}/fill_template.py -i ${TRITON_MODEL_REPO}/preprocessing/config.pbtxt tokenizer_dir:${TOKENIZER_FILE},tokenizer_type:sp,triton_max_batch_size:${MAX_BATCH_SIZE},preprocessing_instance_count:1 && \
python3 ${TOOLS_DIR}/fill_template.py -i ${TRITON_MODEL_REPO}/postprocessing/config.pbtxt tokenizer_dir:${TOKENIZER_FILE},tokenizer_type:sp,triton_max_batch_size:${MAX_BATCH_SIZE},postprocessing_instance_count:1 && \
python3 ${TOOLS_DIR}/fill_template.py -i ${TRITON_MODEL_REPO}/tensorrt_llm_bls/config.pbtxt triton_max_batch_size:${MAX_BATCH_SIZE},decoupled_mode:False,bls_instance_count:1,accumulate_tokens:False && \
python3 ${TOOLS_DIR}/fill_template.py -i ${TRITON_MODEL_REPO}/ensemble/config.pbtxt triton_max_batch_size:${MAX_BATCH_SIZE} && \
python3 ${TOOLS_DIR}/fill_template.py -i ${TRITON_MODEL_REPO}/tensorrt_llm/config.pbtxt triton_max_batch_size:${MAX_BATCH_SIZE},decoupled_mode:False,max_beam_width:1,engine_dir:${ENGINE_DIR},max_tokens_in_paged_kv_cache:2560,max_attention_window_size:2560,kv_cache_free_gpu_mem_fraction:0.5,exclude_input_in_output:True,enable_kv_cache_reuse:False,batching_strategy:inflight_batching,max_queue_delay_microseconds:600,batch_scheduler_policy:guaranteed_no_evict,enable_trt_overlap:False && \
tir_logger "Configuration File Created"
tir_logger "Lauching Triton Server with Tensorrt-llm-backend"

/app/scripts/e2e_scripts/run_server.sh
