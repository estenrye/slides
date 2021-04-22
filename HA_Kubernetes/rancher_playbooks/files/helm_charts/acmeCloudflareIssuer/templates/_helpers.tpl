{{/*
Expand the name of the chart.
*/}}
{{- define "acmeCloudflareIssuer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "acmeCloudflareIssuer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "acmeCloudflareIssuer.labels" -}}
helm.sh/chart: {{ include "acmeCloudflareIssuer.chart" . }}
{{ include "acmeCloudflareIssuer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "acmeCloudflareIssuer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "acmeCloudflareIssuer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Define which LetsEncrypt Server to Use
*/}}
{{- define "acmeCloudflareIssuer.server" -}}
{{- if .Values.acmeUseProductionServer }}
{{- default "https://acme-v02.api.letsencrypt.org/directory" .Values.acmeServer }}
{{- else }}
{{- default "https://acme-staging-v02.api.letsencrypt.org/directory" .Values.acmeServer }}
{{- end }}
{{- end }}