envinfo
=======

This is a simple collection of small snippets of jruby code
useful to collect system information about the execution environment
of J2EE Application Servers.

Package it in a .war file, deploy it and you'll be able to see, via a web interface:

  * The Java System Properties that are defined
  * The process PATH
  * The process umask
  * The CLASSPATH
  * ...

...even without the ability to put hands on the machine running it.

Packaging
---------

Using
-----

Adding tests
------------

The design is really simple even if a bit crude; the aim is to be able to
add any needed check with a few lines of ruby without caring too much about the
quality of the web output.

Contributing
------------

Notes
-----

The .css is borrowed from the BluePrint CSS Framework http://www.blueprintcss.org/