{{- define "telemetry-ingestor.fullname" -}}
telemetry-ingestor
{{- end -}}

{{- define "telemetry-ingestor.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

