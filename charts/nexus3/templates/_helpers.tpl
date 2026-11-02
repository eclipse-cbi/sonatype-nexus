{{/*
PVC name of a project blob store. An optional claimSuffix lets a new PVC
(e.g. different StorageClass) live next to the old one during a migration.
*/}}
{{- define "nexus3.projectClaimName" -}}
nexus3-blobstorage-project-claim-rbd-{{ .name | splitList "." | last }}{{ if .claimSuffix }}-{{ .claimSuffix }}{{ end }}
{{- end -}}
