# installer
# download in /usr/local
{% set version = '2.11.5' %}
{% set url = 'https://www.gerritcodereview.com/download/gerrit-' + version + '.war' %}
{% set user = 'review' %}
{% set review_dir = '/srv/review/' %}
{% set repos_to_mirror_gh = ['glusterfs','glusterfs-specs'] %}
{% set comment_links = [
    {'name': 'bugzilla', 'match': '([Bb][Uu][Gg]:\\s+)(\\d+)', 'html': '$1<a href=\"https://bugzilla.redhat.com/show_bug.cgi?id=$2\">$2</a>' },    #"
    {'name': 'coverity', 'match': '(CID:\\s+)(\\d+)',          'html': '$1<a href=\"https://scan6.coverity.com:8443/query/defects.htm?projectId=10714&cid=$2\">$2</a>' },   #"
    {'name': 'changeid', 'match': '(I[0-9a-f]{8,40})',         'html': '"#q,$1"',
    ] 
%} 


include:
  - postgresql

# TODO install proxy + ssl
#

deps:
  pkg:
    - installed
    - name:
      - java-1.8.0-openjdk-headless
      - curl 
      - git


gerrit-{{ version }}:
  cmd:
    - run
    - creates: /usr/local/lib/gerrit-{{ version }}.war
    - name: curl -L {{ url }} > /usr/local/lib/gerrit-{{ version }}.war

link_to_latest:
  file:
    - symlink
    - name: /usr/local/lib/gerrit.war
    - target: /usr/local/lib/gerrit-{{ version }}.war

{{ user }}:
  user:
    - present
    - home: {{ review_dir }}
    - system: True

{{ review_dir }}/etc:
  file:
    - directory
    - mode: 644
    - user: {{ review }}

{{ review_dir }}/etc/gerrit.config
  file:
    - managed
    - mode: 644
    - user: {{ user }}
    - contents: |
          [gerrit]
                  # TODO use a different path
                  basePath = /srv/git
                  canonicalWebUrl = https://review.gluster.org/
                  canonicalGitUrl = git://review.gluster.org/
          [database]
                  #TODO make it configurable
                  type = postgresql
                  hostname = localhost
                  database = reviewdb
                  username = review
          [index]
                  type = LUCENE
          [auth]
                  type = HTTP
                  contributorAgreements = yes
                  httpHeader = GITHUB_USER
                  loginUrl = /login
                  loginText = Sign-in with GitHub
          [sendemail]
                  smtpServer = localhost
          [container]
                  user = {{ user }}
                  javaHome = /etc/alternatives/jre
          [sshd]
                  listenAddress = *:29418
                  advertisedaddress = git.gluster.org
                  reuseAddress = true
          [httpd]
                  listenUrl = proxy-https://127.0.0.1:8081/
                  filterClass = com.googlesource.gerrit.plugins.github.oauth.OAuthFilter
          [cache]
                  directory = cache
          [cache "web_sessions"]
                  maxAge = 1 y
          [github]
                  url = https://github.com
                  clientId = {{ pillar['gerrit']['github']['client_id'] }}
                  clientSecret = {{ pillar['gerrit']['github']['client_secret'] }} 
          {% for cl in comment_links %}
          [commentlink "{{ cl.name }}"]
                  match = {{ cl.math }}
                  html = {{ cl.html }}
          {% endfor %}
          [download]
          {% for s in ['ssh','http', 'anon_git', 'anon_http'] %}
                  scheme = {{ s }}
          {% endfor %}        

{{ review_dir }}/etc/gerrit.config
  file:
    - managed
    - mode: 600
    - user: {{ user }}
    - contents: |
          [database]
                  password = {{ pillar['gerrit]['postgresql']['password'] }}
          [auth]
                  registerEmailPrivateKey = {{ pillar['gerrit']['email_private_key'] }}
                  restTokenPrivateKey = {{ pillar['gerrit']['token_private_key'] }}

# create the config before running this
#
init_gerrit_review:
  cmd:
    - run
    - creates: {{ review_dir }}/bin/gerrit.sh
    - name: java -jar /usr/local/lib/gerrit.war init --batch {% for p in plugins %}--install-plugin {{ p }}{% endfor %}
    - cwd: {{ review_dir }}

# TODO create a systemd unit
# enable it
# make a link for log, /tmp, etc ?

{{ review_dir }}/etc/replication.config
  file:
    - managed
    - mode: 644
    - user: {{ user }}
    - contents: |
          [remote "git-gluster-org"]
                  push = +refs/heads/*:refs/heads/*
                  push = +refs/tags/*:refs/tags/*
                  url = file:///git/${name}.git
          {% for r in repo_to_mirror_gh %}
          [remote "github-{{ r }}"]
                  push = +refs/heads/*:refs/heads/*
                  push = +refs/tags/*:refs/tags/*
                  url = ssh://git@{{ r }}.github.com/gluster/${name}.git
                  projects = {{ r }}
          {% endfor %}

{{ review_dir }}/.ssh:
  file:
    - directory
    - mode: 644
    - user: {{ user }}

{{ review_dir }}/.ssh/config:
  file:
    - managed
    - mode: 644
    - user: {{ user }}
    - contents: |
          {% for r in repo_to_mirror_gh %}
            Host {{ r }}.github.com
                Hostname github.com
                IdentityFile ~/.ssh/{{ r }}-github.com-id_rsa
          {% endfor %}

{% for r in repo_to_mirror_gh %}
{% set file = review_dir + '/.ssh/' + r + '-github.com-id_rsa' %}
ssh_key_{{ r }}_github.com:
  cmd:
    - run
    - name: ssh-keygen -f {{ file }} -N ''
    - creates: {{ file }}
{% endfor %}

# TODO automate upload on GH with api
