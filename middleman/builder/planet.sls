{% from 'middleman/macros.jinja' import middleman_builder with context %}

{% set remote = 'deploy_website@planet.gluster.org:/srv/middleman_website/www/planet/master' %}
{{ middleman_builder('planet','https://github.com/gluster/planet-gluster.git', remote) }}

refresh_planet:
  cron:
    - present
    - name: touch /srv/middleman_builder/git_updated_planet
    - minute: '*/15'
    - user: middleman_builder


