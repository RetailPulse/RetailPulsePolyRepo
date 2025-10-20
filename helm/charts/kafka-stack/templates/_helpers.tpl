{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
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
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kafka.labels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
{{ include "kafka.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kafka.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kafka.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "kafka.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
ZooKeeper Service Name
*/}}
{{- define "kafka.zookeeperService" -}}
{{- printf "%s-rp-kafka-zookeeper-svc" .Release.Name }}
{{- end }}

{{/*
Kafka Service Name (Internal Plaintext)
*/}}
{{- define "kafka.kafkaService" -}}
{{- printf "%s-rp-kafka-svc" .Release.Name }}
{{- end }}

{{/*
Kafka UI Service Name
*/}}
{{- define "kafka.uiService" -}}
{{- printf "%s-rp-kafka-ui-svc" .Release.Name }}
{{- end }}

{{/*
Resolved ZooKeeper Connect String
*/}}
{{- define "kafka.resolvedZookeeperConnect" -}}
{{- if .Values.kafka.zookeeperConnect }}
{{- .Values.kafka.zookeeperConnect }}
{{- else }}
{{- printf "%s.%s.svc.cluster.local:%d" (include "kafka.zookeeperService" .) (include "kafka.namespace" .) (int .Values.zookeeper.clientPort) }}
{{- end }}
{{- end }}

{{/*
Resolved Kafka Bootstrap Servers (Internal)
*/}}
{{- define "kafka.resolvedBootstrapServers" -}}
{{- if .Values.kafka.advertisedListeners.plaintext.port }}  
  {{- printf "PLAINTEXT://%s.%s.svc.cluster.local:%d" (include "kafka.kafkaService" .) (include "kafka.namespace" .) (int .Values.kafka.advertisedListeners.plaintext.port) }}
{{- else }}
  {{- printf "PLAINTEXT://%s.%s.svc.cluster.local:%d" (include "kafka.kafkaService" .) (include "kafka.namespace" .) (int .Values.kafka.listeners.plaintext.port) }}
{{- end }}
{{- end }}

{{/*
Resolved Kafka Advertised Listeners (Internal)
*/}}
{{- define "kafka.resolvedAdvertisedListenersPlaintext" -}}
{{- if .Values.kafka.advertisedListeners.plaintext.port }}  
  {{- printf "PLAINTEXT://%s.%s.svc.cluster.local:%d" (include "kafka.kafkaService" .) (include "kafka.namespace" .) (int .Values.kafka.advertisedListeners.plaintext.port) }}
{{- else }}
  {{- printf "PLAINTEXT://%s.%s.svc.cluster.local:%d" (include "kafka.kafkaService" .) (include "kafka.namespace" .) (int .Values.kafka.listeners.plaintext.port) }}
{{- end }}
{{- end }}

{{/*
Resolved Kafka Advertised Listeners (External)
*/}}
{{- define "kafka.resolvedAdvertisedListenersExternal" -}}
{{- if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- printf "EXTERNAL://%s:%d" .Values.global.rootHost (int .Values.kafka.advertisedListeners.external.port) }}
{{- else if .Values.kafka.advertisedListeners.external.port }}
  {{- printf "EXTERNAL://%s:%d" .Values.kafka.advertisedListeners.external.host (int .Values.kafka.listeners.external.port) }}
{{- else }}
  {{- printf "EXTERNAL://localhost:%d" (int .Values.kafka.listeners.external.port) }}
{{- end }}
{{- end }}