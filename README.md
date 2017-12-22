# grafana2ECS
A script to launch Grafana into ECS.

This script will create a single-instance ECS cluster and launch a Grafana Docker image into a container on the cluster.
It creates all resources required for the deployment, and names them uniquely with a timestamp by default.
When the deployment is ready, the public DNS name of the instance is returned.  The service may take up to ~60 seconds after the script is finished to be available in the web browser.

This script depends on the AWS CLI, which must be configured with credentials prior to use. See https://aws.amazon.com/cli/ for more info.

Usage: grafana2ecs <options>
All options are optional. Options include:

	-d			        Debug ON. Very Verbose Output.
	-n			        Don't Run. Print settings and quit.
	--cluster-name <name>		Set Cluster Name
	--role-name <name>		Set IAM Role Name
	--instance-profile <name>	Set Instance Profile Name
	--task-family <name>		Set ECS Task Family Name
	--task-name <name>		Set ECS Task Name
	--task-image <image>		Docker registry location of task image (default is grafana/grafana)
	--task-memory <size>		Amount of Task Memory to register, in MB (default is 256)
	--container-port <port>	  	Port on container to access service (default is 3000)
	--service-name <name>		Name of ECS Service to run Task definition
	--security-group <name>	  	Name of Security Group
	--region <name>		        AWS Region to launch in. (default is ap-northeast-2)
	--help                    	Display this message and quit.


In truth, this script should be able to launch any public Docker image into ECS by setting the appropriate options on the command line. It is currently configured for Grafana by default, and alternative images have not been tested. Use at your own risk. :)
