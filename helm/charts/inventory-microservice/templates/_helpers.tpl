{{/*
Expand the name of the chart.
*/}}
{{- define "inventory.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "inventory.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "inventory.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "inventory.labels" -}}
helm.sh/chart: {{ include "inventory.chart" . }}
{{ include "inventory.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "inventory.selectorLabels" -}}
app.kubernetes.io/name: {{ include "inventory.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "inventory.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
MySQL Service Name
*/}}
{{- define "inventory.mysqlService" -}}
{{- printf "%s-rp-inventory-sql-svc" .Release.Name }}
{{- end }}

{{/*
Redis Service Name
*/}}
{{- define "inventory.redisService" -}}
{{- printf "%s-rp-inventory-redis-svc" .Release.Name }}
{{- end }}

{{/*
Business Entity Service Name
*/}}
{{- define "inventory.businessEntityService" -}}
{{- if .Values.global.autoReleaseName }}
{{- printf "%s-rp-businessentity-app-svc" .Release.Name }} 
{{- else if .Values.dependencies.businessEntityService }}
{{- .Values.dependencies.businessEntityService }}
{{- else if .Values.dependencies.businessEntityReleaseName }}
{{- printf "%s-rp-businessentity-app-svc" .Values.dependencies.businessEntityReleaseName }}
{{- else }}
{{- printf "%s-rp-businessentity-app-svc" .Release.Name }} # Fallback, might not be correct
{{- end }}
{{- end }}

{{/*
Redis Secret Name (for App)
Assumes the secret is either created by this chart's redis or provided by another.
*/}}
{{- define "inventory.redisSecretName" -}}
{{- if .Values.global.autoReleaseName }}
{{- printf "%s-rp-inventory-redis-secret" .Release.Name }} 
{{- else if .Values.dependencies.redisSecretReleaseName }}
{{- printf "%s-rp-inventory-redis-secret" .Values.dependencies.redisSecretReleaseName }}
{{- else }}
{{- printf "%s-rp-inventory-redis-secret" .Release.Name }} # Default to this chart's Redis secret
{{- end }}
{{- end }}