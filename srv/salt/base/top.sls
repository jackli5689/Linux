base:
  '*':
    - init.init
prod:
  '*':
    - cluster.haproxy-outside
