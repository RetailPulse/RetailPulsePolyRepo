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
Web-App URL
*/}}
{{- define "sales.webURL" -}}
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
{{- define "sales.webExternalPort" -}}
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
{{- define "sales.iamService" -}}
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
{{- define "sales.iamPort" -}}
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
{{- define "sales.inventoryService" -}}
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

{{/*
Payment Service Name
*/}}
{{- define "sales.paymentService" -}}
{{- if and .Values.global (.Values.global.paymentInternalService) (ne .Values.global.paymentInternalService nil) }}
  {{- printf "%s-%s" .Release.Name .Values.global.paymentInternalService }}
{{- else if and .Values.dependencies (.Values.dependencies.paymentService) (ne .Values.dependencies.paymentService "") }}
  {{- .Values.dependencies.paymentService }}
{{- else if and .Values.dependencies (.Values.dependencies.paymentReleaseName) (ne .Values.dependencies.paymentReleaseName "") }}
  {{- printf "%s-rp-payment-app-svc" .Values.dependencies.paymentReleaseName }}
{{- else }}
  {{- printf "%s-rp-payment-app-svc" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Kafka Service Name
*/}}
{{- define "sales.kafkaService" -}}
{{- if and .Values.global (.Values.global.autoReleaseName) (ne .Values.global.autoReleaseName nil) }}
  {{- printf "%s-rp-kafka-svc.%s.svc.cluster.local" .Release.Name .Release.Namespace }}  
{{- else if and .Values.dependencies (.Values.dependencies.kafkaService) (ne .Values.dependencies.kafkaService "") }}
  {{- .Values.dependencies.kafkaService }}
{{- else if and .Values.dependencies (.Values.dependencies.kafkaReleaseName) (ne .Values.dependencies.kafkaReleaseName "") }}
  {{- printf "%s-rp-kafka-app-svc" .Values.dependencies.kafkaReleaseName }}
{{- else }}
  {{- printf "%s-rp-kafka-app-svc" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Kafka Service Port
*/}}
{{- define "sales.kafkaPort" -}}
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
{{- define "sales.kafkaPaymentTopic" -}}
{{- if and .Values.global (.Values.global.kafkaPaymentTopic) (ne .Values.global.kafkaPaymentTopic nil) }}
  {{- .Values.global.kafkaPaymentTopic }}
{{- else if and .Values.dependencies (.Values.dependencies.kafkaPaymentTopic) (ne .Values.dependencies.kafkaPaymentTopic nil) }}
  {{- .Values.dependencies.kafkaPaymentTopic }}
{{- else }}
  {{- "payment-topic" }}
{{- end }}
{{- end }}
