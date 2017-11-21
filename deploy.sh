#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: $0 -i <subscriptionId> -g <resourceGroupName> -n <deploymentName> -l <resourceGroupLocation>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare vmName=""
declare resourceGroupLocation=""
declare vmSize=""

# Initialize parameters specified from command line
while getopts ":i:g:n:l:s:" arg; do
	case "${arg}" in
		i)
			subscriptionId=${OPTARG}
			;;
		g)
			resourceGroupName=${OPTARG}
			;;
		n)
			vmName=${OPTARG}
			;;
		l)
			resourceGroupLocation=${OPTARG}
			;;
	        s)
			vmSize=${OPTARG}
		esac
done
shift $((OPTIND-1))

#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
	echo "Subscription Id:"
	read subscriptionId
	[[ "${subscriptionId:?}" ]]
fi

if [[ -z "$resourceGroupName" ]]; then
	echo "ResourceGroupName:"
	read resourceGroupName
	[[ "${resourceGroupName:?}" ]]
fi

if [[ -z "$vmName" ]]; then
	echo "VMName:"
	read vmName
fi

if [[ -z "$vmSize" ]]; then
	echo "VMSize:"
	read vmSize
fi

if [[ -z "$resourceGroupLocation" ]]; then
	echo "Enter a location below to create a new resource group else skip this"
	echo "ResourceGroupLocation:"
	read resourceGroupLocation
fi

#templateFile Path - template file to be used
templateFilePath="azure_template.json"

if [ ! -f "$templateFilePath" ]; then
	echo "$templateFilePath not found"
	exit 1
fi

#parameter file path
parametersFilePath="azure_parameters.json"

if [ ! -f "$parametersFilePath" ]; then
	echo "$parametersFilePath not found"
	exit 1
fi

tmpfile=`mktemp`
echo "temp file is $tmpfile"

sed -e "s/DUMMY_VMNAME/$vmName/" -e "s/DUMMY_VMSIZE/$vmSize/" -e "s/DUMMY_LOCATION/$resourceGroupLocation/" $parametersFilePath > $tmpfile

if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$vmName" ] || [ -z "$vmSize" ] ; then
	echo "Either one of subscriptionId, resourceGroupName, vmName, vmSize  is empty"
	usage
fi

#login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
	az login
fi

#set the default subscription id
az account set --subscription $subscriptionId

set +e

#Check for existing RG
groupshowout=`az group show --name $resourceGroupName`

if [ -z $groupshowout]; then
	echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
	set -e
	(
		set -x
		az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
	)
	else
	echo "Using existing resource group..."
fi

#Start deployment
echo "Starting deployment..."
(
	set -x
	az group deployment create --name $vmName --resource-group $resourceGroupName --template-file $templateFilePath --parameters $tmpfile
)


if [ $?  == 0 ];
 then
	echo "Template has been successfully deployed"
fi

