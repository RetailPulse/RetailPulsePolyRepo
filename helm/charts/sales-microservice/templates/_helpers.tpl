{{/*
Expand the name of the chart.
*/}}
{{- define "sales.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sales.fullname" -}}
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
{{- define "sales.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sales.labels" -}}
helm.sh/chart: {{ include "sales.chart" . }}
{{ include "sales.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sales.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sales.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "sales.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
MySQL Service Name
*/}}
{{- define "sales.mysqlService" -}}
{{- printf "%s-rp-sales-sql-svc" .Release.Name }}
{{- end }}

{{/*
Inventory Service Name
*/}}
{{- define "sales.inventoryService" -}}
{{- if .Values.global.autoReleaseName }}
{{- printf "%s-rp-inventory-app-svc" .Release.Name }}
{{- else if .Values.dependencies.inventoryService }}
{{- .Values.dependencies.inventoryService }}
{{- else if .Values.dependencies.inventoryReleaseName }}
{{- printf "%s-rp-inventory-app-svc" .Values.dependencies.inventoryReleaseName }}
{{- else }}
{{- printf "%s-rp-inventory-app-svc" .Release.Name }} # Fallback, might not be correct
{{- end }}
{{- end }}