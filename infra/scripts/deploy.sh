    #!/bin/bash
    # Deployment script for Ansible provisioning

    # Variables
    MANAGER_IP=$(gcloud compute instances describe redis-swarm-manager --zone=asia-south1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
    WORKER_IP=$(gcloud compute instances describe redis-swarm-worker --zone=asia-south1-b --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
    SSH_USER=piush
    ANSIBLE_DIR=./ansible
    
    echo "Waiting for instances to be accessible..."
    sleep 30
    
    # Create ansible inventory file
    cat > $ANSIBLE_DIR/hosts <<EOL
[managers]
manager ansible_host=$MANAGER_IP ansible_user=$SSH_USER

[workers]
worker ansible_host=$WORKER_IP ansible_user=$SSH_USER

[swarm:children]
managers
workers
EOL

    # Set the correct permissions on the SSH key
    chmod 600 ./keys/id_rsa
    
    # # Run ansible playbook
    # cd $ANSIBLE_DIR
    # ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts --private-key ./id_rsa swarm-setup.yml
    
    echo "Deployment complete!"
    echo "Manager IP: $MANAGER_IP"
    echo "Worker IP: $WORKER_IP"
    echo "App should be available at http://$MANAGER_IP:5001"
