#!/bin/bash

# Write ECS config file
cat << EOF > /etc/ecs/ecs.config
ECS_LOGFILE=/log/ecs-agent.log
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGLEVEL=debug
ECS_CLUSTER=${APP_TO_INSTALL}
EOF
