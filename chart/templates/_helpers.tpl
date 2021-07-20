{{/*
Expand the name of the chart.
*/}}
{{- define "simple-web-helmchart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "simple-web-helmchart.fullname" -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "simple-web-helmchart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "simple-web-helmchart.labels" -}}
helm.sh/chart: {{ include "simple-web-helmchart.chart" . }}
{{ include "simple-web-helmchart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "simple-web-helmchart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "simple-web-helmchart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
