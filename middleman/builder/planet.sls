{% from 'middleman/macros.jinja' import middleman_builder with context %}

{% set remote = 'deploy_website@www.gluster.org:/var/www/middleman_website/planet/master' %}
{{ middleman_builder('planet','https://github.com/gluster/planet-gluster.git', remote) }}
