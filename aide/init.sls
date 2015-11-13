aide:
  pkg:
    - installed

aide_config:
  file:
    - managed
    - name:
      /etc/aide_mirror.conf
    - contents: |
        database_out=file:/srv/aidedb
        gzip_dbout=yes
        verbose=5
        PUB = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha256+sha512
        /srv/pub = PUB

/srv/pub:
  file:
    - directory
    - mode: 644

include:
  - .mount_mirror_nfs


aide_cron:
  file:
    - managed
    - name: /usr/local/sbin/cron_aide.sh
    - source: salt://aide/cron_aide.sh
    - mode: 755
  cron:
    - present
    - user: root
    - minute: '0'
    - hour: '*/6'
    - name: /usr/local/sbin/cron_aide.sh

# faire un cron 
# faire un repertoire /srv/pub
#                     /srv/aidedb
# modif /etc/aide.conf
# database_out=file:/srv/aidedb
# gzip_dbout=yes
# user, group, ctime, number of links, p, mtime, size, acl, selinux, sha512, rmd160
# /srv/pub 
#
#
