{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-operator.fullname" -}}
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
{{- define "testkube-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Operator labels
*/}}
{{- define "testkube-operator.labels" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ include "global.labels.standard" . }}
{{ include "testkube-operator.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "testkube-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Deployment labels
*/}}
{{- define "testkube-operator.deployLabels" -}}
control-plane: controller-manager
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{- default .Values.serviceAccount.name }}
{{- else }}
{{- default "testkube-operator-controller-manager" }}
{{- end }}
{{- end }}

{{/*
Create the name of the webhook service account to use
*/}}
{{- define "testkube-operator.webhook.serviceAccountName" -}}
{{- if .Values.webhook.patch.serviceAccount.name }}
{{- default .Values.webhook.patch.serviceAccount.name }}
{{- else }}
{{- default "testkube-operator-webhook-cert-mgr" }}
{{- end }}
{{- end }}

{{/*
Create testkube operator metrics server name
*/}}
{{- define "testkube-operator.metricsServiceName" -}}
{{- if .Values.metricsServiceName }}
{{- default .Values.metricsServiceName }}
{{- else }}
{{- default "testkube-operator-controller-manager-metrics-service" }}
{{- end }}
{{- end }}

{{/*
Create testkube operator webhook service name
*/}}
{{- define "testkube-operator.webhookServiceName" -}}
{{- default "testkube-operator-webhook-service" }}
{{- end }}

{{/*
Create testkube operator webhook certificate
*/}}
{{- define "testkube-operator.webhookCertificate" -}}
{{- default "testkube-operator-serving-cert" }}
{{- end }}


{{/*
Define Operator image
*/}}
{{- define "testkube-operator.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
      {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
      {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- end -}}
{{- end -}}
