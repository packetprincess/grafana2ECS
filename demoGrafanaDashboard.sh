#!/bin/bash 
# Sample Templated script to generate a Grafana Dashboard
# Generates a dashboard sample for monitoring a cluster
# that just popped up with grafana2ECS
###########################################################
# Get local env
THIS=`basename $0`
HERE=`pwd`
NOW=`date +%y%m%d-%H%M%S`
set_environment()

# Command line options override environment vars.
# Defaults in case neither are set:
{	
	[[ $DNSNAME ]] || DNSNAME="ec2-xxxxxxxx.ap-northeast-2.compute.amazonaws.com"
	[[ $DASH_PATH ]] || DASH_PATH=$HERE/dashboards/
	[[ $DASH_FILE_NAME ]] || DASH_FILE_NAME=${DASH_PATH}$DNSNAME		
	[[ $DASH_TITLE ]] || DASH_TITLE="demoDashboard"
	
	[[ $AWSREGION ]] || AWSREGION="ap-northeast-2"
	[[ $DATA_SOURCE ]] || DATA_SOURCE="Cloudwatch"
	[[ $AUTOSCALING_GROUP ]] || AUTOSCALING_GROUP="asg-demoASG-0123456789"
	[[ $LOADBALANCER ]] || LOADBALANCER="elb-demoELB-0123456789"
	[[ $INSTANCE_ID ]] || INSTANCE_ID="i-02a08be3f3b6d9acc"
	[[ $ECS_CLUSTER_NAME ]] || ECS_CLUSTER_NAME="demoCluster-180226234834"

	[[ $DB_DS_NAME ]] || DB_DS_NAME="Catchpoint"
	[[ $CP_TEST_ID ]] || CP_TEST_ID="0123456789"

	[[ $CAN_EDIT ]] || CAN_EDIT="false"
}

# Usage Message
usage_msg(){
	printf "Usage: $THIS <options>\n"
	printf "Options (all are optional, order invariant):\n"
	printf "\t-d\t\t\t\tDebug Mode. Verbose output.\n"
	printf "\t-h\t\t\t\tHelp. This message.\n"
	printf "\t--dns <name>\t\t\tService DNS Name.\n"
	printf "\t--dash-file <name>\t\tOutput path for dashboard. Defaults to DNS Name.\n"
	printf "\t--title \"<name>\"\t\t\tSet the dashboard title. Uses DNS Name if specified, otherwise defaults to demoDashboard.\n"
	printf "\t--aws-region <name>\t\tSet AWS Region.\n"
	printf "\t--data-source "<name>"\t\tCloudWatch Data Source Name.\n"
	printf "\t--asg <resource id>\t\tFor monitoring ASG Stats.\n"
	printf "\t--elb <resource id>\t\tFor monitoring Requests & Latency.\n"
	printf "\t--ec2 <instance id>\t\tFor monitoring EC2 machine stats.\n"
	printf "\t--ecs <cluster name>\t\tFor monitoring ECS stats.\n"
	printf "\t--db-source \"<name>\"\t\tDatabase Data Source Name.\n"
	printf "\t--cp-test <test id>\t\tCatchpoint Test ID.\n"
	exit 0
}

# Parse Options
while [[ $# -gt 0 ]]; do
	case $1 in
		-d) DBG=1; shift 1;;
		--dns) DNSNAME=$2; shift 2;;
		--dash-path) DASH_PATH=$2; shift 2;;
		--dash-file) DASH_FILE_NAME=$2; shift 2;;		
		--title) DASH_TITLE=$2; shift 2;;

		--aws-region) AWSREGION=$2; shift 2;;
		--data-source) DATA_SOURCE=$2; shift 2;;
		--asg) AUTOSCALING_GROUP=$2; shift 2;;
		--elb) LOADBALANCER=$2; shift 2;;
		--ec2) INSTANCE_ID=$2; shift 2;;
		--ecs) ECS_CLUSTER_NAME=$2; shift 2;;
		
		--db-source) DB_DS_NAME=$2; shift 2;;
		--cp-test) CP_TEST_ID=$2; shift 2;;
		
		*) usage_msg;;
	esac	
done

# Set the Dashboard Title to matchthe DNS Name if none was set
[[ $DNSNAME && ! $DASH_TITLE ]] && DASH_TITLE="$DNSNAME"
set_environment
[[ -d $DASH_PATH ]] || mkdir $DASH_PATH


# Output header
print_header(){
printf '{
    "timezone": "",
    "title": "'$DASH_TITLE'",
    "uid": "_o61jp6kz",
    "version": 2,
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": '$CAN_EDIT',
  "gnetId": null,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "schemaVersion": 16,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ],
  "panels": ['
} # End header function


# Panels can be separated out and iterated or sequenced  
print_dash(){
  printf '{
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "'$DATA_SOURCE'",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 8,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "dimensions": {
            "InstanceId": "'$INSTANCE_ID'"
          },
          "metricName": "CPUUtilization",
          "namespace": "AWS/EC2",
          "period": "",
          "refId": "A",
          "region": "'$AWSREGION'",
          "statistics": [
            "Average"
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "ec2 cpu",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": true,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ]
    }'
} ### End dash printing function

print_dash2(){
	printf '{
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": "'$DATA_SOURCE'",
	      "fill": 1,
	      "gridPos": {
	        "h": 9,
	        "w": 12,
	        "x": 0,
	        "y": 9
	      },
	      "id": 6,
	      "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
	      },
	      "lines": true,
	      "linewidth": 1,
	      "links": [],
	      "nullPointMode": "null",
	      "percentage": false,
	      "pointradius": 5,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "dimensions": {
	            "ClusterName": "'$ECS_CLUSTER_NAME'"
	          },
	          "metricName": "MemoryUtilization",
	          "namespace": "AWS/ECS",
	          "period": "",
	          "refId": "A",
	          "region": "'$AWSREGION'",
	          "statistics": [
	            "Average"
	          ]
	        }
	      ],
	      "thresholds": [],
	      "timeFrom": null,
	      "timeShift": null,
	      "title": "mem",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "transparent": true,
	      "type": "graph",
	      "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "format": "short",
	          "label": null,
	          "logBase": 1,
	          "max": null,
	          "min": null,
	          "show": true
	        },
	        {
	          "format": "short",
	          "label": null,
	          "logBase": 1,
	          "max": null,
	          "min": null,
	          "show": true
	        }
	      ]
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": "'$DATA_SOURCE'",
	      "fill": 1,
	      "gridPos": {
	        "h": 9,
	        "w": 12,
	        "x": 0,
	        "y": 18
	      },
	      "id": 4,
	      "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
	      },
	      "lines": true,
	      "linewidth": 1,
	      "links": [],
	      "nullPointMode": "null",
	      "percentage": false,
	      "pointradius": 5,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "dimensions": {
	            "ClusterName": "'$ECS_CLUSTER_NAME'"
	          },
	          "metricName": "CPUUtilization",
	          "namespace": "AWS/ECS",
	          "period": "",
	          "refId": "A",
	          "region": "'$AWSREGION'",
	          "statistics": [
	            "Average"
	          ]
	        }
	      ],
	      "thresholds": [],
	      "timeFrom": null,
	      "timeShift": null,
	      "title": "cpu",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "transparent": true,
	      "type": "graph",
	      "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "format": "short",
	          "label": null,
	          "logBase": 1,
	          "max": null,
	          "min": null,
	          "show": true
	        },
	        {
	          "format": "short",
	          "label": null,
	          "logBase": 1,
	          "max": null,
	          "min": null,
	          "show": true
	        }
	      ]
	    }'
}

# Define the Footer to print
print_footer(){
printf ']}}\n' 
} # End printing footer

# Define Template Printing Order
print_template(){
	print_header
	print_dash
	printf ',\n'
	print_dash2
	print_footer
}
print_template > $DASH_FILE_NAME

exit 0
