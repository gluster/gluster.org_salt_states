bind-master:
  pkg:
    - installed
    - name: bind
  service: 
    - running
    - enable: True
    - name: named
  file.managed:
    - name: /etc/named.conf
    - mode: 644
    - user: root
    - group: root
    - check_cmd: named-checkconf
    - contents: |
        options {
          listen-on port 53 { 127.0.0.1; };
          listen-on-v6 port 53 { ::1; };
          directory   "/var/named";
          dump-file   "/var/named/data/cache_dump.db";
          statistics-file "/var/named/data/named_stats.txt";
          memstatistics-file "/var/named/data/named_mem_stats.txt";
          allow-query     { localhost; };
          recursion yes;

          dnssec-enable yes;
          dnssec-validation yes;
          dnssec-lookaside auto;

          /* Path to ISC DLV key */
          bindkeys-file "/etc/named.iscdlv.key";

          managed-keys-directory "/var/named/dynamic";
        };

        logging {
          channel default_debug {
            file "data/named.run";
            severity dynamic;
          };
        };

        zone "." IN {
          type hint;
          file "named.ca";
        };

        include "/etc/named.rfc1912.zones";
        include "/etc/named.root.key";


# gerer /etc/named.conf
#

