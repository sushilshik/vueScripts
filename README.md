# vueScripts

## Description 

JRuby scripts for VUE - open source concept mapping application written in Java (https://en.wikipedia.org/wiki/Visual_Understanding_Environment). At first you need to patch VUE to integrate JRuby support. Then you can write and execute JRuby code in nodes on VUE canvas to control any VUE objects. It is like JavaScript for web browsers.

Visual dynamic tests prototype is main project implemented with this JRuby scripts.

File with tests example - https://github.com/sushilshik/vueScripts/raw/master/vue_maps/tests-example.vpk 

This is fast prototype code.

## VUE Patch

Patch VUE to integrate JRuby. You need it to use tests examples.

1. git clone https://github.com/VUE/VUE.git
2. cd VUE/
3. git checkout tags/3.2.2
4. git checkout -b 3.2.2-work
5. wget https://raw.githubusercontent.com/sushilshik/vueScripts/master/jruby.patch

Read patch code - it is really small.

6. git apply jruby.patch
7. wget http://central.maven.org/maven2/org/jruby/jruby-complete/1.7.16/jruby-complete-1.7.16.jar
8. mv jruby-complete-1.7.16.jar VUE2/lib/
9. ant compile
10. ant jar
11. java -jar VUE2/src/build/VUE.jar

Example and visual explanation of work with JRuby code in VUE - https://github.com/sushilshik/vueScripts/raw/master/vue_maps/vue_scripting.vpk

## Screenshots

### JRuby code in VUE

Jruby code in VUE node.

![Jruby code in VUE node](http://www.nkbtr.org/down/jruby_vue_node.png)

vue_scripting.vpk canvas screenshot with example code and how to use explanation.

![vue_scripting.vpk](http://www.nkbtr.org/down/jruby_vue_example.png)

### Tests project

Tests and tests data.

![Tests and tests data](http://www.nkbtr.org/down/tests_examples_screens/tests_simple.png)

Tests.

![Tests](http://www.nkbtr.org/down/tests_examples_screens/tests_simple_test_screen.png)

Tests data.

![Tests data](http://www.nkbtr.org/down/tests_examples_screens/tests_simple_test_data_rows.png)

## Contacts

https://www.facebook.com/mike.ahundov - any questions on setup, use, etc.
