{{- define "ota-controller.fullname" -}}
ota-controller
{{- end -}}

{{- define "ota-controller.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

