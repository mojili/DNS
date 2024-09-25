#!jinja|yaml|gpg
{% set APP_NAME = "bind-exporter" %}
{% set IMAGE_NAME = 'bind-exporter' %}
{% set IMAGE_VERSION =  "v0.7.0" %}
{% set config = pillar.get('nodes_info', {}) %}
{% set REGISTRY_URL = 'demo-registry.digicdn.dev' %}
{% set REG_DEFAULTS = pillar.get('reg_defaults', {}) %}
{% set NAME_SERVER_1 = '172.30.70.12' %}
{% set NAME_SERVER_2 = '172.30.70.14' %}
{% set DOMAIN_NAME = 'digicdn.dev' %}

Docker_Login:
  cmd.run:
    - name: "echo \"$password\" | docker login -u {{ REG_DEFAULTS['reg_user'] }} --password-stdin {{ REGISTRY_URL }}"
    - env:
      - password: {{ REG_DEFAULTS['reg_pass'] }}

Docker_Stop_{{ APP_NAME }}:
  docker_container.stopped:
    - error_on_absent: false
    - names:
      - {{ APP_NAME }}

Docker_Remove_{{ APP_NAME }}:
  docker_container.absent:
    - names:
      - {{ APP_NAME }}

{{ APP_NAME }}:
  docker_container.running:
    - image: {{ REGISTRY_URL }}/prometheuscommunity/{{ IMAGE_NAME }}:{{ IMAGE_VERSION }}
    - network_mode: host
    - restart_policy: always
    - command: '--bind.stats-url http://127.0.0.1:8053'
    - dns:
      - {{ NAME_SERVER_1 }}
      - {{ NAME_SERVER_2 }}
    - binds:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    - domainname:
      - {{ DOMAIN_NAME }}
    - dns_search:
      - {{ DOMAIN_NAME }}

Docker_Logout:
  cmd.run:
    - name: "docker logout {{ REGISTRY_URL }}"
