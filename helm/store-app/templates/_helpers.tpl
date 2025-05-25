{{/*
Common labels
*/}}
{{- define "store-app.labels" -}}
helm.sh/chart: {{ include "store-app.chart" . }}
{{ include "store-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "store-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "store-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "store-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common name of the chart.
*/}}
{{- define "store-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Full name of the chart.
*/}}
{{- define "store-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "store-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "store-app.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "store-app.deployment.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "store-app.statefulset.apiVersion" -}}
{{- if semverCompare ">=1.9-0" .Capabilities.KubeVersion.GitVersion -}}
apps/v1
{{- else -}}
apps/v1beta2
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "store-app.ingress.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1" -}}
networking.k8s.io/v1
{{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
networking.k8s.io/v1beta1
{{- else -}}
extensions/v1beta1
{{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "store-app.ingress.isStable" -}}
{{- eq (include "store-app.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports pathType.

pathType was added to networking.k8s.io/v1beta1 in Kubernetes 1.18
and is present in networking.k8s.io/v1.
*/}}
{{- define "store-app.ingress.supportsPathType" -}}
{{- or (eq (include "store-app.ingress.apiVersion" .) "networking.k8s.io/v1") (and (eq (include "store-app.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion)) -}}
{{- end -}}
