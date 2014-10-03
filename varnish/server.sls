varnish:
  pkg:
    - installed
  service:
    - running
    - names:
      - varnish
      - varnishncsa
    - require:
      - pkg: varnish
    - watch:
      - file: /etc/sysconfig/varnish
      - file: /etc/varnish/default.vcl
  file:
    - name: /etc/sysconfig/varnish
    - managed
    - source: salt://varnish/varnish.sysconfig
  file:
    - name: /etc/varnish/default.vcl
    - managed
    - source: salt://varnish/varnish.default.vcl
