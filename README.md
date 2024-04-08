andrewrothstein.glab
===========================
![Build Status](https://github.com/andrewrothstein/glab/actions/workflows/build.yml/badge.svg)

Installs the gitlab [cli](https://gitlab.com/gitlab-org/cli).

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.glab
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
