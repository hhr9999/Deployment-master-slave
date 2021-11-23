{% if grains['osmajorrelease'] == '7' %}
ncurses-compat-libs:
  pkg.installed
{% endif %}

{% if grains['osmajorrelease'] == '8' %}
ncurses-compat-libs:
  pkg.installed
{% endif %}


mysql:
  user.present:
    - system: true
    - createhome: false
    - shell: /sbin/nologin

{{ pillar['mysql_install_dir'] }}:
  archive.extracted:
    - source: salt://modules/database/mysql/files/mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz
    - unless: test -d {{ pillar['mysql_install_dir'] }}/mysql-5.7.34-linux-glibc2.12-x86_64
  file.symlink:
    - name: {{ pillar['mysql_install_dir'] }}/mysql
    - target: {{ pillar['mysql_install_dir'] }}/mysql-5.7.34-linux-glibc2.12-x86_64 


{{ pillar['mysql_install_dir'] }}/mysql:
  file.directory:
    - user: mysql
    - group: mysql
    - mode: '0755'
    - recurse:
      - user
      - group

{{ pillar['data_dir'] }}:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true
    - recurse:
      - user
      - group 

/etc/profile.d/mysqld.sh:
  file.managed:
    - source: salt://modules/database/mysql/files/mysqld.sh

{{ pillar['mysql_install_dir'] }}/mysql/support-files/mysql.server:
  file.managed:
    - source: salt://modules/database/mysql/files/mysql.server
    - user: mysql
    - group: mysql
    - mode: '0755'

/usr/lib/systemd/system/mysqld.service:
  file.managed:
    - source: salt://modules/database/mysql/files/mysqld.service
    - user: root
    - group: root
    - mode: '0644'

mysql-initialize:
  cmd.run:
    - name: '{{ pillar['mysql_install_dir'] }}/mysql/bin/mysqld --initialize-insecure --user=mysql --datadir={{ pillar['data_dir'] }}/' 
    - unless: test $(ls -l {{ pillar['data_dir'] }} |wc -l) -gt 1

