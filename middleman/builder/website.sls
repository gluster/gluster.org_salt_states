{% from 'middleman/macros.jinja' import middleman_builder with context %}

{% set remote = 'deploy_website@www.gluster.org:/var/www/middleman_website/web/master' %}
{{ middleman_builder('web', 'https://github.com/gluster/glusterweb.git', remote) }}

# since we have feeds on the main website
refresh_website:
  cron:
    - present
    - name: touch /srv/middleman_builder/git_updated_web
    - minute: '*/30'
    - user: middleman_builder


