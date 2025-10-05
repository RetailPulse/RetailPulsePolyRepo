{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "payment.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "payment.fullname" -}}
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
{{- define "payment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "payment.labels" -}}
helm.sh/chart: {{ include "payment.chart" . }}
{{ include "payment.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "payment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "payment.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "payment.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
Web-App URL
*/}}
{{- define "payment.webURL" -}}
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
{{- define "payment.webExternalPort" -}}
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
{{- define "payment.iamService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-iam-app-svc" .Release.Name }}
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
{{- define "payment.iamPort" -}}
{{- if and .Values.global (.Values.global.iamPort) (ne .Values.global.iamPort nil) }}
  {{- .Values.global.iamPort }}
{{- else if and .Values.dependencies (.Values.dependencies.iamPort) (ne .Values.dependencies.iamPort nil) }}
  {{- .Values.dependencies.iamPort }}
{{- else }}
  {{- 8081  }}
{{- end }}
{{- end }}

{{/*
Sales Service Name (Dynamic Resolution)
*/}}
{{- define "payment.salesService" -}}
{{- if .Values.dependencies.salesService }}
{{- .Values.dependencies.salesService }}
{{- else if .Values.dependencies.salesReleaseName }}
{{- printf "svc-%s-app-svc" .Values.dependencies.salesReleaseName }}
{{- else }}
{{- "svc-rp-sales" }} 
{{- end }}
{{- end }}

{{/*
Kafka Bootstrap Servers
*/}}
{{- define "payment.kafkaService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-kafka-svc" .Release.Name }}
{{- else if .Values.dependencies.kafkaService }}
  {{- .Values.dependencies.kafkaService }}
{{- else if .Values.dependencies.kafkaReleaseName }}
  {{- printf "%s-rp-kafka-svc.%s.svc.cluster.local:9092" .Values.dependencies.kafkaReleaseName (include "payment.namespace" .) }}
{{- else }}
  {{- printf "%s-rp-kafka-svc.%s.svc.cluster.local:9092" .Release.Name (include "payment.namespace" .) }} # Fallback
{{- end }}
{{- end }}

{{/*
Kafka Service Port
*/}}
{{- define "payment.kafkaPort" -}}
{{- if and .Values.global (.Values.global.kafkaPort) (ne .Values.global.kafkaPort nil) }}
  {{- .Values.global.kafkaPort }}
{{- else if and .Values.dependencies (.Values.dependencies.kafkaPort) (ne .Values.dependencies.kafkaPort nil) }}
  {{- .Values.dependencies.kafkaPort }}
{{- else }}
  {{- 9092  }}
{{- end }}
{{- end }}

{{/*
Kafka Payment Topic
*/}}
{{- define "payment.kafkaPaymentTopic" -}}
{{- if and .Values.global (.Values.global.kafkaPaymentTopic) (ne .Values.global.kafkaPaymentTopic nil) }}
  {{- .Values.global.kafkaPaymentTopic }}
{{- else if and .Values.dependencies (.Values.dependencies.kafkaPaymentTopic) (ne .Values.dependencies.kafkaPaymentTopic nil) }}
  {{- .Values.dependencies.kafkaPaymentTopic }}
{{- else }}
  {{- "payment-topic" }}
{{- end }}
{{- end }}