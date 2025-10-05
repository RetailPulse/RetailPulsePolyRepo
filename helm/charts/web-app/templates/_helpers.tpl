{{/*
Expand the name of the chart.
*/}}
{{- define "web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "web.fullname" -}}
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
{{- define "web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "web.labels" -}}
helm.sh/chart: {{ include "web.chart" . }}
{{ include "web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "web.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end }}

{{/*
Identity Access Management Service Name
*/}}
{{- define "web.iamExternalService" -}}
{{- if and .Values.global (.Values.global.iamExternalService) (ne .Values.global.iamExternalService nil) }}
  {{- .Values.global.iamExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Identity Access Management Service Port
*/}}
{{- define "web.iamExternalPort" -}}
{{- if and .Values.global (.Values.global.iamExternalPort) (ne .Values.global.iamExternalPort nil) }}
  {{- .Values.global.iamExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.iamExternalPort) (ne .Values.dependencies.iamExternalPort nil) }}
  {{- .Values.dependencies.iamExternalPort }}
{{- else }}
  {{- 8081  }}
{{- end }}
{{- end }}

{{/*
User Service Name
*/}}
{{- define "web.userExternalService" -}}
{{- if and .Values.global (.Values.global.userExternalService) (ne .Values.global.userExternalService nil) }}
  {{- .Values.global.userExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
User Service Port
*/}}
{{- define "web.userExternalPort" -}}
{{- if and .Values.global (.Values.global.userExternalPort) (ne .Values.global.userExternalPort nil) }}
  {{- .Values.global.userExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.userExternalPort) (ne .Values.dependencies.userExternalPort nil) }}
  {{- .Values.dependencies.userExternalPort }}
{{- else }}
  {{- 8082  }}
{{- end }}
{{- end }}

{{/*
Business Entity Service Name
*/}}
{{- define "web.businessEntityExternalService" -}}
{{- if and .Values.global (.Values.global.businessEntityExternalService) (ne .Values.global.businessEntityExternalService nil) }}
  {{- .Values.global.businessEntityExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Business Entity Service Port
*/}}
{{- define "web.businessEntityExternalPort" -}}
{{- if and .Values.global (.Values.global.businessEntityExternalPort) (ne .Values.global.businessEntityExternalPort nil) }}
  {{- .Values.global.businessEntityExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.businessEntityExternalPort) (ne .Values.dependencies.businessEntityExternalPort nil) }}
  {{- .Values.dependencies.businessEntityExternalPort }}
{{- else }}
  {{- 8083  }}
{{- end }}
{{- end }}

{{/*
Inventory Service Name
*/}}
{{- define "web.inventoryExternalService" -}}
{{- if and .Values.global (.Values.global.inventoryExternalService) (ne .Values.global.inventoryExternalService nil) }}
  {{- .Values.global.inventoryExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Inventory Service Port
*/}}
{{- define "web.inventoryExternalPort" -}}
{{- if and .Values.global (.Values.global.inventoryExternalPort) (ne .Values.global.inventoryExternalPort nil) }}
  {{- .Values.global.inventoryExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.inventoryExternalPort) (ne .Values.dependencies.inventoryExternalPort nil) }}
  {{- .Values.dependencies.inventoryExternalPort }}
{{- else }}
  {{- 8084  }}
{{- end }}
{{- end }}

{{/*
Sales Service Name
*/}}
{{- define "web.salesExternalService" -}}
{{- if and .Values.global (.Values.global.salesExternalService) (ne .Values.global.salesExternalService nil) }}
  {{- .Values.global.salesExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Sales Service Port
*/}}
{{- define "web.salesExternalPort" -}}
{{- if and .Values.global (.Values.global.salesExternalPort) (ne .Values.global.salesExternalPort nil) }}
  {{- .Values.global.salesExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.salesExternalPort) (ne .Values.dependencies.salesExternalPort nil) }}
  {{- .Values.dependencies.salesExternalPort }}
{{- else }}
  {{- 8085  }}
{{- end }}
{{- end }}

{{/*
Report Service Name
*/}}
{{- define "web.reportExternalService" -}}
{{- if and .Values.global (.Values.global.reportExternalService) (ne .Values.global.reportExternalService nil) }}
  {{- .Values.global.reportExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Report Service Port
*/}}
{{- define "web.reportExternalPort" -}}
{{- if and .Values.global (.Values.global.reportExternalPort) (ne .Values.global.reportExternalPort nil) }}
  {{- .Values.global.reportExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.reportExternalPort) (ne .Values.dependencies.reportExternalPort nil) }}
  {{- .Values.dependencies.reportExternalPort }}
{{- else }}
  {{- 8086  }}
{{- end }}
{{- end }}

{{/*
Payment Service Name
*/}}
{{- define "web.paymentExternalService" -}}
{{- if and .Values.global (.Values.global.paymentExternalService) (ne .Values.global.paymentExternalService nil) }}
  {{- .Values.global.paymentExternalService }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.rootHost) (ne .Values.dependencies.rootHost "") }}
  {{- .Values.dependencies.rootHost }}
{{- else }}
  {{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Payment Service Port
*/}}
{{- define "web.paymentExternalPort" -}}
{{- if and .Values.global (.Values.global.paymentExternalPort) (ne .Values.global.paymentExternalPort nil) }}
  {{- .Values.global.paymentExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.paymentExternalPort) (ne .Values.dependencies.paymentExternalPort nil) }}
  {{- .Values.dependencies.paymentExternalPort }}
{{- else }}
  {{- 8087  }}
{{- end }}
{{- end }}


{{/*
Web-App URL
*/}}
{{- define "web.webURL" -}}
{{- if and .Values.global (.Values.global.webURL) (ne .Values.global.webURL "") }}
  {{- .Values.global.webURL }}
{{- else if and .Values.global (.Values.global.rootHost) (ne .Values.global.rootHost nil) }}
  {{- .Values.global.rootHost }}
{{- else if and .Values.dependencies (.Values.dependencies.webURL) (ne .Values.dependencies.webURL "") }}
  {{- .Values.dependencies.webURL }}
{{- else }}
  {{- "localhost"  }}
{{- end }}
{{- end }}

{{/*
Web-App Port
*/}}
{{- define "web.webExternalPort" -}}
{{- if and .Values.global (.Values.global.webExternalPort) (ne .Values.global.webExternalPort nil) }}
  {{- .Values.global.webExternalPort }}
{{- else if and .Values.dependencies (.Values.dependencies.webExternalPort) (ne .Values.dependencies.webExternalPort nil) }}
  {{- .Values.dependencies.webExternalPort }}
{{- else }}
  {{- 30080  }}
{{- end }}
{{- end }}