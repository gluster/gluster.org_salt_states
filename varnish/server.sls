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
  file:
    - name: /etc/sysconfig/varnish
    - managed
    - source: salt://varnish/varnish.sysconfig
  file:
    - name: /etc/varnish/default.vcl
    - managed
    - source: salt://varnish/varnish.default.vcl
