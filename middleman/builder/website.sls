{% from 'middleman/macros.jinja' import middleman_builder with context %}

{% set name = 'web_master' %}
{% set remote = 'deploy_website@www.gluster.org:/var/www/master' %}
{{ middleman_builder(name,'https://github.com/gluster/glusterweb.git', remote) }}


