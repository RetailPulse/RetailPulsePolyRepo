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
Web-App URL
*/}}
{{- define "report.webURL" -}}
{{- if and .Values.global (.Values.global.webURL) (ne .Values.global.webURL "") }}
  {{- .Values.global.webURL }}
{{- else if and .Values.dependencies (.Values.dependencies.webURL) (ne .Values.dependencies.webURL "") }}
  {{- .Values.dependencies.webURL }}
{{- else }}
  {{- "localhost"  }}
{{- end }}
{{- end }}

{{/*
Web-App Port
*/}}
{{- define "report.webExternalPort" -}}
{{- if and .Values.global (.Values.global.webExternalPort) (ne .Values.global.webExternalPort nil) }}
  {{- .Values.global.webExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.webExternalPort) (ne .Values.dependencies.webExternalPort nil) }}
  {{- .Values.dependencies.webExternalPort }}
{{- else }}
  {{- 30080  }}
{{- end }}
{{- end }}

{{/*
Identity Access Management Service Name
*/}}
{{- define "report.iamService" -}}
{{- if and .Values.global (.Values.global.iamInternalService) (ne .Values.global.iamInternalService nil) }}
  {{- printf "%s://%s-%s" .Values.global.protocol .Release.Name .Values.global.iamInternalService }}
{{- else if and .Values.dependencies (.Values.dependencies.iamReleaseName) (ne .Values.dependencies.iamReleaseName "") }}
  {{- printf "%s-rp-iam-app-svc" .Values.dependencies.iamReleaseName }}
{{- else if and .Values.dependencies (.Values.dependencies.iamService) (ne .Values.dependencies.iamService "") }}
  {{- .Values.dependencies.iamService }}
{{- else }}
  {{- printf "%s-rp-iam-app-svc" .Release.Name }} 
{{- end }}
{{- end }}

{{/*
Identity Access Management Service Port
*/}}
{{- define "report.iamPort" -}}
{{- if and .Values.global (.Values.global.iamPort) (ne .Values.global.iamPort nil) }}
  {{- .Values.global.iamPort }}
{{- else if and .Values.dependencies (.Values.dependencies.iamPort) (ne .Values.dependencies.iamPort nil) }}
  {{- .Values.dependencies.iamPort }}
{{- else }}
  {{- 8081  }}
{{- end }}
{{- end }}

{{/*
Inventory Service Name
*/}}
{{- define "report.inventoryService" -}}
{{- if and .Values.global (.Values.global.inventoryInternalService) (ne .Values.global.inventoryInternalService nil) }}
  {{- printf "%s-%s" .Release.Name .Values.global.inventoryInternalService }}
{{- else if and .Values.dependencies (.Values.dependencies.inventoryService) (ne .Values.dependencies.inventoryService "") }}
  {{- .Values.dependencies.inventoryService }}
{{- else if and .Values.dependencies (.Values.dependencies.inventoryReleaseName) (ne .Values.dependencies.inventoryReleaseName "") }}
  {{- printf "%s-rp-inventory-app-svc" .Values.dependencies.inventoryReleaseName }}
{{- else }}
  {{- printf "%s-rp-inventory-app-svc" .Release.Name }} # Fallback, might not be correct
{{- end }}
{{- end }}