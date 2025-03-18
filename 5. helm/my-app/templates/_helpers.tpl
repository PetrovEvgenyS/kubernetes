{{/* Generate basic labels for app */}}
{{- define "my-app.labels" -}}
app: {{ .Values.labels.app }}
env: {{ .Values.labels.env }}
owner: {{ .Values.labels.owner }}
{{- end -}}

{{/* Generate labels for postgres */}}
{{- define "postgres.labels" -}}
components: postgres
env: {{ .Values.labels.env }}
owner: {{ .Values.labels.owner }}
{{- end -}}

{{/* Generate template for sercrets */}}
{{- define "env.template" -}}
- name: {{ .env }}
  valueFrom:
    secretKeyRef:
      name: "{{ .name }}-secret"
      key: {{ .env }}
{{- end -}}