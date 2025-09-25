{{/*
Expand the name of the chart.
*/}}
{{- define "identity-access-management.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "identity-access-management.fullname" -}}
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
{{- define "identity-access-management.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "identity-access-management.labels" -}}
helm.sh/chart: {{ include "identity-access-management.chart" . }}
{{ include "identity-access-management.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "identity-access-management.selectorLabels" -}}
app.kubernetes.io/name: {{ include "identity-access-management.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "identity-access-management.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
Web-App URL
*/}}
{{- define "identity-access-management.webURL" -}}
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
{{- define "identity-access-management.webPort" -}}
{{- if and .Values.global (.Values.global.webPort) (ne .Values.global.webPort nil) }}
  {{- .Values.global.webPort }}
{{- else if and .Values.dependencies (.Values.dependencies.webPort) (ne .Values.dependencies.webPort nil) }}
  {{- .Values.dependencies.webPort }}
{{- else }}
  {{- 30080  }}
{{- end }}
{{- end }}

{{- define "identity-access-management.userMysqlService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-user-sql-svc" .Release.Name }}
{{- else if and .Values.dependencies (.Values.dependencies.userMysqlService) (ne .Values.dependencies.userMysqlService "") }}
  {{- .Values.dependencies.userMysqlService }}
{{- else if and .Values.dependencies (.Values.dependencies.userReleaseName) (ne .Values.dependencies.userReleaseName "") }}
  {{- printf "%s-rp-user-sql-svc" .Values.dependencies.userReleaseName }}
{{- else }}
  {{- printf "%s-rp-user-sql-svc" .Release.Name }}
{{- end }}
{{- end }}
