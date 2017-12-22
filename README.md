# grafana2ECS
A script to launch Grafana into ECS.

This script will create a single-instance ECS cluster and launch a Grafana Docker image into a container on the cluster.
It creates all resources required for the deployment, and names them uniquely with a timestamp by default.

The script depends on the AWS CLI, which must be configured with credentials prior to use. See https://aws.amazon.com/cli/ for more info.

Run the script with --help to see available options.
