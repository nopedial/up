### Up

#### stand-alone file upload web service

##### install and run

```
user@box:~$ cd up/
user@box:~/up$ rake install
  Successfully built RubyGem
  Name: up
  Version: 0.0.1
  File: up-0.0.1.gem
Successfully installed up-0.0.1
1 gem installed
user@box:~/up$ cd ../
user@box:~$ upd
+ base configuration built at: ~/.config/up/config
user@box:~$ vi ~/.config/up/config
user@box:~$ upd
user@box:~$
```

##### configuration

the configuration file is automatically created during the first run.

```
user@box:~$ upd
+ base configuration built at: ~/.config/up/config
user@box:~$ cat ~/.config/up/config
---
debug: false
uploads_dir: "/home/shafez/public/uploads"
web:
  localhost: 127.0.0.1
  localport: 8888
user@box:~$
```

setting 'debug' to 'true' will make the daemon run in foreground.
