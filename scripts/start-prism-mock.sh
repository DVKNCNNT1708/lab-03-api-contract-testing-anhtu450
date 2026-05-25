#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-iot}"

case "${MODE}" in
  iot)
    npx prism mock contracts/iot-ingestion.openapi.yaml -p 4010 --host 0.0.0.0
    ;;
  vision)
    npx prism mock contracts/ai-vision.openapi.yaml -p 4011 --host 0.0.0.0
    ;;
  notify)
    npx prism mock contracts/notify.openapi.yaml -p 4010 --host 0.0.0.0
    ;;
  all)
    npm run mock:notify &
    NOTIFY_PID=$!
    trap 'kill ${NOTIFY_PID} 2>/dev/null || true' EXIT
    wait
    ;;
  *)
    echo "Usage: scripts/start-prism-mock.sh [iot|vision|notify|all]"
    exit 1
    ;;
esac
