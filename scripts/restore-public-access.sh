#!/bin/bash
# Restore public network access for all Prism resources.
# Microsoft policy runs daily and disables public access - run this script after it fires.
#
# Usage:
#   bash scripts/restore-public-access.sh

set -e

RG="rg-prism-prism-rag"

echo "Restoring public network access for resource group: $RG"

echo "[1/7] Storage Account..."
az storage account update \
  --name stprismk62sauxpgy4qc \
  --resource-group "$RG" \
  --public-network-access Enabled \
  --default-action Allow

echo "[2/7] AI Services (OpenAI / AI Foundry)..."
az resource update \
  --resource-group "$RG" \
  --name cog-prism-k62sauxpgy4qc \
  --resource-type Microsoft.CognitiveServices/accounts \
  --set properties.publicNetworkAccess=Enabled

echo "[3/7] Document Intelligence..."
az resource update \
  --resource-group "$RG" \
  --name cog-prism-di-k62sauxpgy4qc \
  --resource-type Microsoft.CognitiveServices/accounts \
  --set properties.publicNetworkAccess=Enabled

echo "[4/7] AI Search..."
az search service update \
  --name srch-prism-k62sauxpgy4qc \
  --resource-group "$RG" \
  --public-access enabled

echo "[5/7] Container Registry..."
az acr update \
  --name crprismk62sauxpgy4qc \
  --resource-group "$RG" \
  --public-network-enabled true

echo "[6/7] Log Analytics Workspace..."
az monitor log-analytics workspace update \
  --workspace-name log-prism-k62sauxpgy4qc \
  --resource-group "$RG" \
  --ingestion-access Enabled \
  --query-access Enabled

echo "[7/7] Application Insights..."
az monitor app-insights component update \
  --app appi-prism-k62sauxpgy4qc \
  --resource-group "$RG" \
  --ingestion-access Enabled \
  --query-access Enabled

echo "Done. All resources have public network access restored."
