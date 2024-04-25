#!/usr/bin/bash
set -e
source /app/scripts/e2e_scripts/variables.sh

if [[ -z "$GRPC_PORT" ]]; then
    GRPC_PORT=8001
fi

if [[ -z "$HTTP_PORT" ]]; then
    HTTP_PORT=8000
fi

if [[ -z "$METRIC_PORT" ]]; then
    METRIC_PORT=8002
fi

python3 /app/scripts/launch_triton_server.py \
      --world_size ${WORLD_SIZE} \
      --grpc_port ${GRPC_PORT} \
      --http_port ${HTTP_PORT} \
      --metrics_port ${METRIC_PORT} \
      --model_repo ${TRITON_MODEL_REPO}

tail -f /dev/null