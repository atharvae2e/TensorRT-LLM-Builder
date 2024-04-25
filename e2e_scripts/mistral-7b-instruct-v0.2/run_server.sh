#!/usr/bin/bash
set -e
set -x

DEFAULT_WORLD_SIZE=1
DEFAULT_HTTP_PORT=8080
DEFAULT_GRPC_PORT=9000
DEFAULT_METRIC_PORT=8082

WORLD_SIZE=${WORLD_SIZE:-${DEFAULT_WORLD_SIZE}}
HTTP_PORT=${HTTP_PORT:-${DEFAULT_HTTP_PORT}}
GRPC_PORT=${GRPC_PORT:-${DEFAULT_GRPC_PORT}}
METRIC_PORT=${METRIC_PORT:-${DEFAULT_METRIC_PORT}}

python3 /app/scripts/launch_triton_server.py \
    --world_size  ${WORLD_SIZE} \
    --model_repo ${MODEL_REPO_PATH} \
    --http_port ${HTTP_PORT} \
    --grpc_port ${GRPC_PORT} \
    --metrics_port ${METRIC_PORT} 


tail -f /dev/null