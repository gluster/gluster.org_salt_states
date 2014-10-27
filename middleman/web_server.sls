include:
  - httpd.server

middleman_web_server:
  pkg:
    - installed
    - names:
      - rsync
  user:
    - present
    - name: deploy_website
    - fullname: Middleman deploy user
    - home: /var/www/middelman_website
 
