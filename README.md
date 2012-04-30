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

It has been tested on:

 * Jboss 5.1
 * WebLogic Server 11g
 * Websphere Application Server 8
 
Using
-----

You need jruby and the gems specified in the included Gemfile

### Testing ###

 * Run rackup in home of the project directory
 * Connect with a browser to http://127.0.0.1:9292/

 You'll be able to get some info about the environment, but not the one specific for J2EE
 environments.

### Packaging ###

 1. Create the envinfo.war file running `warbler`
 2. Deploy it to your favorite Java Application Server

Adding tests
------------

The design is really simple even if a bit crude; the aim is to be able to
add any needed check with a few lines of ruby without caring too much about the
quality of the web output.

Contributing
------------

You've added some function? Fixed some bug? Cleaned up the code? Send me a pull request
and if possible I'll be happy to merge your changes.

Notes
-----

The .css is borrowed from the BluePrint CSS Framework http://www.blueprintcss.org/
