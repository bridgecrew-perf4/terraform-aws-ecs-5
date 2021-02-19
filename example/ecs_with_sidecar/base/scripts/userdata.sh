#!/bin/bash

# Write ECS config file
cat << EOF > /etc/ecs/ecs.config
ECS_LOGFILE=/log/ecs-agent.log
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGLEVEL=debug
ECS_CLUSTER=${APP_TO_INSTALL}
EOF

yum install -y nfs-utils
mkdir /mnt
chown root:root /mnt
chmod 700 /mnt

#mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-12345678.efs.us-west-2.amazonaws.com:/ /mnt
#echo -e 'nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-12345678.efs.us-west-2.amazonaws.com:/ /mnt' >> /etc/fstab
