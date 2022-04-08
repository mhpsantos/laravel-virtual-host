# laravel-virtual-host
## Why?
Why not automate a little bit of this tedious task? As a Laravel developer, I faced a problem creating VirtualHosts in my machine, either by forgetting the process or by doing it wrong at some steps. 

Now, I have this little script to create the VirtualHost in the same way for every project, so I don't have to bother searching the internet for how to do this or that.

## Usage
Execute the shell script using the following arguments:

-  -p = path to the root folder of your project
-  -n = name of the project (will be used in the creation of a folder under /var/www/)
-  -a = local web address for your Virtual Host
### Example
```
  ./virtual-host.sh -p ./cool-app/ -n coolapp -a coolapp.local
```
You will be asked to give SU permission to the script, as I found no other way to create or copy the files under /var/www/ or to edit the /etc/hosts file.

Have fun!
