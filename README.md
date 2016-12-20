### Up

#### stand-alone file upload web service

##### install and run

```
user@box:~$ cd up/
user@box:~/up$ rake install
  Successfully built RubyGem
  Name: up
  Version: 0.1.0
  File: up-0.1.0.gem
Successfully installed up-0.1.0
1 gem installed
user@box:~/up$ cd ../
user@box:~$ upd
+ base configuration built at: ~/.config/up/config
user@box:~$ vi ~/.config/up/config
user@box:~$ upd
user@box:~$
```

##### configuration

the configuration file is automatically generated during the first run. 

```
shafez@up:~$ upd
+ base configuration built at: ~/.config/up/config
shafez@up:~$ cat .config/up/config
---
debug: true
app:
  upload_dir: "/home/shafez/public/uploads"
  times:
  - 1
  - 5
  - 10
  - 30
  - 1h
  - 1d
  log: "/home/shafez/.config/up/log"
web:
  localhost: 127.0.0.1
  localport: 8888
shafez@up:~$
```

files are stored in sub-directories of the defined 'uploads_dir'. these directories can be configured under 'app/times'. up will create the missing directories.

#### Up doesn't remove files - please setup cron to match your configuration

```
shafez@up:~$ ls -al public/uploads/
total 32
drwxr-xr-x 8 shafez shafez 4096 Dec 19 23:44 .
drwxr-xr-x 3 shafez shafez 4096 Aug 22 21:49 ..
drwxr-xr-x 2 shafez shafez 4096 Dec 19 23:54 1
drwxr-xr-x 2 shafez shafez 4096 Dec 19 22:48 10
drwxr-xr-x 2 shafez shafez 4096 Dec 19 23:26 1d
drwxr-xr-x 2 shafez shafez 4096 Dec 19 22:48 1h
drwxr-xr-x 2 shafez shafez 4096 Dec 19 22:48 30
drwxr-xr-x 2 shafez shafez 4096 Dec 19 23:55 5
shafez@up:~$
```

setting 'debug' to 'true' will make the daemon run in foreground.


#### nginx

nginx can be configured to proxy requests to Up

```
server {
	listen 80;
        listen [::]:80;
        server_name up.arahant.nl;
    	access_log /var/log/nginx/up.arahant.nl-access.log;
    	error_log /var/log/nginx/up.arahant.nl-error.log;
        location / {
             proxy_pass http://127.0.0.1:8888;
        }
}
```

live demo: http://up.arahant.nl
