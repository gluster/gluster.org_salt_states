{% from 'middleman/macros.jinja' import middleman_builder with context %}
{% for branch in pillar['middleman_git_branch'] %}
 {% set name = 'website_%s' % branch %}
 {% set remote = 'deploy_website@www.gluster.org:/var/www/middleman_website/%s' % branch %}
{{ middleman_builder(name,'git://forge.gluster.org/gluster-site/gluster-site.git', remote) }}

{% endfor %}


