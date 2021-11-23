grant_mysql_user:
  cmd.run:
    - name: {{ pillar['mysql_install_dir'] }}/mysql/bin/mysql -uroot -p{{ pillar['mysql_password'] }} -e "grant replication slave,super on *.* to '{{ pillar['mysql_user'] }}'@'{{ pillar['mysql_cong_ip'] }}' identified by '1'; flush privileges;"
    - unless: {{ pillar['mysql_install_dir'] }}/mysql/bin/mysql -uroot -p1 -e 'exit'
