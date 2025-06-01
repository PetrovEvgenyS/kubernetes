{{/* Generate basic labels for app */}}
{{- define "my-app.labels" -}}
app: {{ .Values.labels.app }}
env: {{ .Values.labels.env }}
owner: {{ .Values.labels.owner }}
{{- end -}}
