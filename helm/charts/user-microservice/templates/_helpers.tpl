{{/*
Expand the name of the chart.
*/}}
{{- define "user.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "user.fullname" -}}
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
{{- define "user.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "user.labels" -}}
helm.sh/chart: {{ include "user.chart" . }}
{{ include "user.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "user.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "user.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
MySQL Service Name
*/}}
{{- define "user.mysqlService" -}}
{{- printf "%s-rp-user-sql-svc" .Release.Name }}
{{- end }}

{{/*
Web-App URL
*/}}
{{- define "user.webURL" -}}
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
{{- define "user.webPort" -}}
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
{{- define "user.iamService" -}}
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
{{- define "user.iamPort" -}}
{{- if and .Values.global (.Values.global.iamPort) (ne .Values.global.iamPort nil) }}
  {{- .Values.global.iamPort }}
{{- else if and .Values.dependencies (.Values.dependencies.iamPort) (ne .Values.dependencies.iamPort nil) }}
  {{- .Values.dependencies.iamPort }}
{{- else }}
  {{- 8081  }}
{{- end }}
{{- end }}