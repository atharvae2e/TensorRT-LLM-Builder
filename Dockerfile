FROM aimle2e/triton_trt_llm:0.9.0

WORKDIR /app

COPY tensorrtllm_backend/scripts scripts
COPY tensorrtllm_backend/tools tools
COPY tensorrtllm_backend/all_models/inflight_batcher_llm inflight_batcher_llm_models

# e2e_scripts/<model-speicific-script-path> scripts/e2e_scripts
COPY e2e_scripts/mistral-7b-instruct-v0.2 scripts/e2e_scripts

# For Gemma : tensorrtllm_backend -> TAG:gemma
# COPY tensorrtllm_backend/all_models/gemma inflight_batcher_llm_models


RUN find . -type f -name "*.py" -exec chmod +x {} \;
RUN find . -type f -name "*.sh" -exec chmod +x {} \;

ENTRYPOINT [ "/app/scripts/e2e_scripts/startup.sh" ]

# For Manual Testing 
# CMD ["tail", "-f", "/dev/null"]