{% set remote = 'deploy_website@www.gluster.org:/var/www/planet/' %}
{% from 'macros.jinja' import middleman_builder with context %}
{{ middleman_builder('planet','https://github.com/gluster/planet-gluster.git', remote) }}
