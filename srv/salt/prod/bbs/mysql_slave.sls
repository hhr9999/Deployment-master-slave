include:
- modules.database.mysql_zhucong.slave

statr_slave:
  file.managed:
    - name: /tmp/mysql_cong.sh
    - source: salt://bbs/files/mysql_cong.sh.j2
    - mode: '0755'
    - template: jinja
  cmd.run:
    - name: bash /tmp/mysql_cong.sh
    - unless: test $({{ pillar['mysql_install_dir'] }}/mysql/bin/mysql -uroot -p{{ pillar['mysql_password'] }} -e 'show slave status\G' | grep '_Running' |awk '{print $2}' | grep -c 'Yes') -eq 2


