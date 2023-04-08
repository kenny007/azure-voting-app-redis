#!/bin/bash

count=0
started=false

while [ $count -lt 3 ] && ! $started; do
    ((count++))
    echo "[$STAGE_NAME] Starting container [Attempt: $count]"
    
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 | grep -q "200"; then
        started=true
    else
        sleep 1
    fi
done

if ! $started; then
    exit 1
fi
