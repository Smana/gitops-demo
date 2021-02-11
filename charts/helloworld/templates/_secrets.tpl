{{- define "helloworld.secrets" }}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/role: "helloworld"
vault.hashicorp.com/tls-skip-verify: "True"
vault.hashicorp.com/agent-inject-secret-env: "secret/app/helloworld"
# Environment variable export template
vault.hashicorp.com/agent-inject-template-env: |
  {{` {{ with secret "secret/app/helloworld" }}
    {{ range $k, $v := .Data.data }}
         export {{ $k }}={{ $v }}
    {{ end }}
   {{ end }} `}}
# Write a sensitive file somewhere
vault.hashicorp.com/agent-inject-secret-osinfo: "secret/app/osinfo"
vault.hashicorp.com/secret-volume-path-osinfo: "/var/app1"
vault.hashicorp.com/agent-inject-template-osinfo: |
    {{` {{ with secret "secret/app/osinfo" -}}
      {{- .Data.data.osrelease }}
     {{- end }} `}}
{{ end }}