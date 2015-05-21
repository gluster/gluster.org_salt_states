{% from 'middleman/macros.jinja' import middleman_builder with context %}

{% set remote = 'deploy_website@www.gluster.org:/var/www/middleman_website/web/master' %}
{{ middleman_builder('web', 'https://github.com/gluster/glusterweb.git', remote) }}


