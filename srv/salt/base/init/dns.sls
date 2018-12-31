/etc/resolve.conf:
  file.managed:
    - source: salt://init/files/resolve.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
