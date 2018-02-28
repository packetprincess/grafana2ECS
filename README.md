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

## demoGrafanaDashboard.sh
A script to generate a Grafana dashboard for AWS resources. Takes either environment variables, command-line arguments, or defaults specified in the script as input. Sample dashboard code is included.

This script is intended as a demo to be customized for your application. To use, create and configure a dashboard for your resources in Grafana, and replace the dashboard outputs with your custom dashboard JSON, parameterized for your resources.  Append to deployment process to auto-update dashboard as resource IDs change.  Demo options below.

Usage: demoGrafanaDashboard.sh <options>
Options (all are optional, order invariant):
	
	-d				Debug Mode. Verbose output.
	-h				Help. This message.
	--dns <name>			Service DNS Name.
	--dash-file <name>		Output path for dashboard. Defaults to DNS Name.
	--title "<name>"		Set the dashboard title. Uses DNS Name if specified, otherwise defaults to demoDashboard.
	--aws-region <name>		Set AWS Region.
	--data-source "<name>"		CloudWatch Data Source Name
	--asg <resource id>		For monitoring ASG Stats.
	--elb <resource id>		For monitoring Requests & Latency.
	--ec2 <instance id>		For monitoring EC2 machine stats.
	--ecs <cluster name>		For monitoring ECS stats.
	--db-source "<name>"		Database Data Source Name
	--cp-test <test id>		Catchpoint Test ID.
