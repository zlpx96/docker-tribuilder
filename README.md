tribuilder
==========

Docker-based tool to build your Adove AIR SDK apps in a fully equiped container.

Current version is a Ubuntu 12.04 containing:

 * AIR 19.0
 * Java 7u71
 * Nodejs 0.12
 * Docker and docker-compose
 * Git
 * Build-essentials
 * Wine (used to run AIR)

Installation
------------

Using `curl`:

    $ curl https://raw.githubusercontent.com/j3k0/docker-tribuilder/master/tribuilder > /usr/local/bin/tribuilder
    $ chmod +x /usr/local/bin/tribuilder
    $ tribuilder

Using `wget`:

    $ wget -qO- https://raw.githubusercontent.com/j3k0/docker-tribuilder/master/tribuilder > /usr/local/bin/tribuilder
    $ chmod +x /usr/local/bin/tribuilder
    $ tribuilder

Usage
-----

Pull (optional):

    docker pull jeko/tribuilder:latest

From your air project directory:

    tribuilder mxmlc <arguments>
    tribuilder node build ...
    etc.

