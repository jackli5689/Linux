base:
  '*':
    - init.init
prod:
  'Linux-node*':
    - cluster.haproxy-outside
  'SaltstackServer*':
    - cluster.haproxy-outside-keepalived

  'linux-node1*':
    - bbs.memcached
