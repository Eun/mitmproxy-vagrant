# mitmproxy-vagrant

This repo contains a vagrant machine that comes with [mitmproxy](https://mitmproxy.org).  
You can use it to inspect and debug traffic.

## Instructions
1. Clone this repo
2. `cd` into the cloned repo and run `vagrant up`
3. Set the default gateway address (of the device you want to inspect) to the vagrant ip address. (Copy it from the output)
4. Run `vagrant ssh` & `sudo screen -rr`
5. For https traffic you need to import the mitmproxy root certificate: Browse to [mitm.it](http://mitm.it) to download and install.