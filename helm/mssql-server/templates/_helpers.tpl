{{/*
Expand the name of the chart.
*/}}
{{- define "mssql-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mssql-server.fullname" -}}
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
{{- define "mssql-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mssql-server.labels" -}}
helm.sh/chart: {{ include "mssql-server.chart" . }}
{{ include "mssql-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mssql-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mssql-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mssql-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mssql-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mssql-server.logShippingClaimName" -}}
{{- .Values.logShipping.claimName | default (printf "%s-%s" (.Release.Namespace | trunc 63 | trimSuffix "-") "logship" ) }}
{{- end }}

{{/*
Create the configmap name
*/}}
{{- define "mssql-server.configMapName" -}}
{{- include "mssql-server.fullname" . }}-config
{{- end }}

{{/*
Create the mssqllog pvc name
*/}}
{{- define "mssql-server.mssqllogPVCName" -}}
{{- include "mssql-server.fullname" . }}-log
{{- end }}

{{/*
Create the mssqldb pvc name
*/}}
{{- define "mssql-server.mssqlsqldataPVCName" -}}
{{- include "mssql-server.fullname" . }}-mssqldata
{{- end }}

{{/*
Create the mssqluserdb pvc name
*/}}
{{- define "mssql-server.mssqluserdbPVCName" -}}
{{- include "mssql-server.fullname" . }}-userdb
{{- end }}

{{/*
Create the mssqltmp pvc name
*/}}
{{- define "mssql-server.mssqltempPVCName" -}}
{{- include "mssql-server.fullname" . }}-temp
{{- end }}

{{/*
Create the secret name
*/}}
{{- define "mssql-server.secretName" -}}
{{- include "mssql-server.fullname" . }}
{{- end }}

{{/*
Get sa password value
*/}}
{{- define "mssql-server.sapassword" -}}
{{- if .Release.IsInstall -}}
{{ .Values.sa_password | default (randAlphaNum 20) | b64enc | quote }}
{{- else -}}
{{ index (lookup "v1" "Secret" .Release.Namespace (include "mssql-server.secretName" .)).data "sa_password" }}
{{- end }}
{{- end }}
