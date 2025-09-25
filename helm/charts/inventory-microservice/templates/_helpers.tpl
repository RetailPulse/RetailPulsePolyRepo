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
Redis Secret Name (for App)
*/}}
{{- define "inventory.redisSecretName" -}}
{{- printf "%s-rp-inventory-redis-secret" .Release.Name }}
{{- end }}

{{/*
Web-App URL
*/}}
{{- define "inventory.webURL" -}}
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
{{- define "inventory.webPort" -}}
{{- if and .Values.global (.Values.global.webPort) (ne .Values.global.webPort nil) }}
  {{- .Values.global.webPort }}
{{- else if and .Values.dependencies (.Values.dependencies.webPort) (ne .Values.dependencies.webPort nil) }}
  {{- .Values.dependencies.webPort }}
{{- else }}
  {{- 30080  }}
{{- end }}
{{- end }}

{{/*
Identity Access Management Service Name
*/}}
{{- define "inventory.iamService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-iam-app-svc" .Values.global.autoReleaseName }}
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
{{- define "inventory.iamPort" -}}
{{- if and .Values.global (.Values.global.iamPort) (ne .Values.global.iamPort nil) }}
  {{- .Values.global.iamPort }}
{{- else if and .Values.dependencies (.Values.dependencies.iamPort) (ne .Values.dependencies.iamPort nil) }}
  {{- .Values.dependencies.iamPort }}
{{- else }}
  {{- 8081  }}
{{- end }}
{{- end }}

{{/*
Business Entity Service Name
*/}}
{{- define "inventory.businessEntityService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-businessentity-app-svc" .Release.Name }}
{{- else if and .Values.dependencies (.Values.dependencies.businessEntityService) (ne .Values.dependencies.businessEntityService "") }}
  {{- .Values.dependencies.businessEntityService }}
{{- else if and .Values.dependencies (.Values.dependencies.businessEntityReleaseName) (ne .Values.dependencies.businessEntityReleaseName "") }}
  {{- printf "%s-rp-businessentity-app-svc" .Values.dependencies.businessEntityReleaseName }}
{{- else }}
  {{- printf "%s-rp-businessentity-app-svc" .Release.Name }} # Fallback, might not be correct
{{- end }}
{{- end }}