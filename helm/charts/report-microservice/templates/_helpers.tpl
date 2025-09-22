{{/*
Expand the name of the chart.
*/}}
{{- define "report.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "report.fullname" -}}
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
{{- define "report.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "report.labels" -}}
helm.sh/chart: {{ include "report.chart" . }}
{{ include "report.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "report.selectorLabels" -}}
app.kubernetes.io/name: {{ include "report.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "report.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
MongoDB Service Name
*/}}
{{- define "report.mongodbService" -}}
{{- printf "%s-rp-report-mongodb-svc" .Release.Name }}
{{- end }}

{{/*
MongoDB Secret Name
*/}}
{{- define "report.mongodbSecret" -}}
{{- printf "%s-rp-report-mongodb-secret" .Release.Name }}
{{- end }}

{{/*
Inventory Service Name
*/}}
{{- define "report.inventoryService" -}}
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

{{/*
IAM Service Name
*/}}
{{- define "report.iamService" -}}
{{- if .Values.global.autoReleaseName }}
{{- printf "%s-rp-iam-app-svc" .Release.Name }}
{{- else if .Values.dependencies.iamService }}
{{- .Values.dependencies.iamService }}
{{- else if .Values.dependencies.iamReleaseName }}
{{- printf "%s-rp-iam-app-svc" .Values.dependencies.iamReleaseName }}
{{- else }}
{{- printf "%s-rp-iam-app-svc" .Release.Name }} # Fallback, might not be correct
{{- end }}
{{- end }}