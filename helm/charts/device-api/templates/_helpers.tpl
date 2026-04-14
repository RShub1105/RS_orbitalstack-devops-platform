{{- define "device-api.fullname" -}}
device-api
{{- end -}}

{{- define "device-api.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

