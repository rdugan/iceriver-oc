# IceRiver Overclocking Firmware
Modified firmware for all IceRiver ASICs, adding clock and voltage control, sensor graphing, properly secured login and API access, and other goodies.

Customizable OC/OV, small fee benefitting the community, no unnecessary changes to your device.

Firmware files can be downloaded from the Releases section on the right hand side of this page.

If you have any issues, finding me (pbfarmer) in the Kaspa Discord will probably result in the fastest response/resolution.

<br>

# Table of Contents
- [Special Thanks](#special-thanks)
- [Fee](#fee)
- [Known Issues](#known-issues)
- [Features](#features)
  - [Configuration additions and updates](#configuration-additions-and-updates)
    - [Configurable clock and voltage offset](#configurable-clock-and-voltage-offset)
    - [Better fan controls](#better-fan-controls)
  - [Additional telemetry and other changes to home page](#additional-telemetry-and-other-changes-to-home-page)
    - [Graphing of chip metrics and longer term hashrates](#graphing-of-chip-metrics-and-longer-term-hashrates)
    - [Uptime and job rate on pool status](#uptime-and-job-rate-on-pool-status)
    - [Chip temperature monitoring](#chip-temperature-monitoring)
    - [Real-time voltage and clock display](#real-time-voltage-and-clock-display)
    - [Primary pool health monitor](#primary-pool-health-monitor)
  - [API](#api)
  - [General UI improvements](#general-ui-improvements)
  - [Stability and security improvements](#stability-and-security-improvements)
    - [Fix for web server crashes](#fix-for-web-server-crashes)
    - [New auth/auth routines](#new-authauth-routines)
    - [TLS certificate management](#tls-certificate-management)
    - [Healthcheck loop](#healthcheck-loop)
- [Installation](#installation)
  - [Power and metering](#power-and-metering)
  - [Cooling](#cooling)
  - [Tuning](#tuning)
  - [Reproducing results from other firmware](#reproducing-results-from-other-firmware)
- [Usage Tips](#usage-tips)
- [Let's Talk About Hashrates](#lets-talk-about-hashrates)

<br>

# Special Thanks

None of these firmwares would be possible without a number of people's efforts in testing and feedback (as well as specific efforts in pulling the stock firmware from the KS0 Pro - these people are mentioned in the release notes.)  

However, one person in particular has sacrificed his machines from the beginning, granting me direct access for development, allowing me to risk his machines while testing brand new features, and suffering numerous mining interruptions during the frequent updates and restarts.  

This person goes by the Discord handle Onslivion - it would be great if you could drop him a thanks on the Kaspa Discord, and maybe even send him a tip or some of your hashrate:

kaspa:qzh2xglq33clvzm8820xsj7nnvtudaulnewxwl2kn0ydw9epkqgs2cjw6dh3y

<br>

# Fee
* While the fee remains 1% for the base version, unfortunately the previous 50/50 split with the Kaspa Development Fund needs to be adjusted.  Development and support of this product has become much more than a full time job, while at the same time the fee income is declining rapidly due to reward reductions and nethash growth.  As a result, the split will be restructured as 80/20 for the first 600K KAS/yr, while any proceeds beyond that will continue to be split 50/50 as before.  Please understand this decision is not taken lightly, but is the only chance I have to continue my current level of involvement with the product.  Should the price of KAS appreciate significantly sooner than expected, this arrangement will of course be reconsidered.  For reference / transparency, the total fee income as of 2024-07-30 (over ~8 months) has been 314K KAS, half of which has been directed to the Kaspa Dev Fund.
* A commercial/hosting version is now available with a current fee of 1.33%.  This version includes additional features useful for larger deployments, such as multiple user management, hashrate splitting (e.g. for setting up hosting fees), and brand/logo replacement.  This fee will increase in future releases as more features are added (such as aggregate dashboards, auto-tuning, etc), but is expected to be capped at 2%.
* Fee traffic is directed to *.kaspa.pool.pbfarmer.cc, which is currently just an alias for Herominers (e.g. us.kaspa.pool.pbfarmer.cc => us.kaspa.herominers.com).  If the system is unable to connect to one of the 5 closest Herominers pools, OC will be removed and performance reduced until a connection is once again available.  A warning indicator will appear in the UI in such situations.

<br>

# Known Issues
* IceRiver ASICs insist on using static IP settings, even after you set them to DHCP.  If these IPs are not reserved in your router, at some point your router may assign these IPs to another device in your network, and you will have network / connection problems.  The solution to this is to find the MAC address to IP address mapping table in the LAN/DHCP section of your router settings, and add a mapping for every one of your ASICs (the MAC address should be on a sticker on the outside of your ASIC.)  Once you've added these mappings, restart the router, update every ASIC to use DHCP, and restart all of the ASICs.  Now your ASICs should acquire the fixed IP via DHCP, and even if/when they revert to static IPs, it should no longer cause issues, since the router has reserved the IP(s).
* At some point a widespread DNS update seems to have affected multiple ISPs, which caused them to 'black-hole' traffic to *.pbfarmer.cc.  This meant that while the pool connections succeeded, all subsequent traffic disappeared into the void.  If you are seeing a similar situation where you appear to be connected to a pool, but are not getting any jobs or producing shares, try updating your DNS server (preferably in your router, but also possible on the ASIC) to a public option such as Google (8.8.8.8, 8.8.4.4), Cloudflare (1.1.1.1), etc.
* A number of people have found that the fee traffic or maybe domain name are tripping spam/ddos/botnet protections in their routers, which commonly target mining traffic.  If your ASIC seems to connect to pools but is not mining (even after following the previous steps), check for these types of settings in your router and try disabling them.  For exmaple, in my ASUS router, I need to disable the 'AIProtection' features called 'Two-Way IPS' and 'Infected Device Prevention and Blocking' to do any sort of crypto mining.
* There may be incompatiblities between HiveOS/AsicHub or other 3rd party management/monitoring tools and this firmware.  Many of these tools scrape the ASIC UI to get data, and since I've signficantly modified the UI, their scrapers may no longer be compatible.  The only way to address this is for the management tools to migrate to the available API.

<br>

# Features

## Configuration additions and updates

<br>

### Configurable clock and voltage offset

![Performance Settings](/docs/images/iceriver-oc_settings.png)

Clock and voltage settings have been added to the 'Miner' page.  Clock can be increased/decreased to any integer value (within hardware limits).  Changes take effect immediately without restart, but note that clock increases are gradually applied in increments of 25Mhz per 30s.  As a result, it may take some time to get to full speed, possibly even ~10 minutes, depending on how large of an offset you choose.  

Voltage can also be increased/decreased to any integer value (within hardware limits), with changes taking effect immediately.  Settings will be rounded down to the nearest multiple of 6.25mV internally for everything but KS0 Pro.  A simple model to keep in mind is that for every 25mv increase, the proper increments are 7mv-6mv-6mv-6mv, or for example, 7, 13, 19, 25 for the first 25mv. 

For KS0 Pro, voltage can be adjusted in 2mV increments.  

VOLTAGE CONTROL IS NOT AVAILABLE FOR KS3/M/L AT THIS TIME.

<br>

*IMPORTANT: THERE ARE CURRENTLY NO GUARDRAILS, AND NO LIMITS ENFORCED BY THIS SOFTWARE ON EITHER CLOCKS OR VOLTAGE, SO USE WITH CARE.*

<br>

### Better fan controls

![Performance Settings](/docs/images/iceriver-oc_fan_settings.png)

A new fan mode has been added which automatically adjusts fan speed to maintain a max hash chip temperature.  Temps are read every 10s and fan speed is adjusted as necessary.  

It is suggested to use a minimum fan speed within maybe 75% of the speed the fans normally run, so that periods of highly dynamic temperature ranges (such as startup) do not allow excessive power stage temps while the hash chips are warming up.  For example, if the fans would settle around 80% during normal operating temps, a min fan speed of 60% may be appropriate.

Please note, this setting does not guarantee the set temperature.  It may overshoot during startup or other dynamic periods, but it should stabilize at or near (within a few degrees) the requested temperature.

Fixed fan speeds will also now be reapplied at startup, after a ~1-2m delay.

<br>

<br>

## Additional telemetry and other changes to home page

<br>

### Graphing of chip metrics and longer term hashrates

![Home Page](/docs/images/iceriver-oc_home.png)

Two hours of graphing has been added for all chip metrics, with filters for summaries (per board min/max/avg), board, or all chips.  Additionally, board temp graphs have been added for all models, which includes intake, and exhaust sensor temps, as well as power stage (driver) temps for KS0/Pro/Ultra, KS1, and KS2.  In summary mode, the max power stage temp is shown for each board, while in board mode, the max power stage temp is shown for each group/controller (PSG).  Max recommended operating temp is 125C according to the chip documentation, though it is probably wise to keep a healthy margin below this temp.  

Please be aware, that temperature is not the only consideration for healthy operation.  Power/current draw is also a concern, for which we don't currently have visibility or specifications.

Hashrate graphing (as well as the headline stats) now includes 30m and 2hr tracking, and also includes board level filtering.  

Mouseover tooltips have been synchronized across all graphs, to help with diagnosing issues / anomalies.

Instantaneous values are shown in the legend, and individual lines can be disabled/enabled by clicking on the labels.  Graph scales are no longer zero based, and adjust depending on which lines are displayed, meaning they are no longer artifically flattend by poor resolution, and you can actually see the variability in each measurement.

*Hopefully this helps clear up how variable 5m readings really are.*

<br>

### Uptime and job rate on pool status

![Home Page](/docs/images/iceriver-oc_overview_stats.png)

The uninterrupted uptime, and job issuance rate are added to the pool stats section.  Job rate is simply an additional health indicator of a pool connection - currently job rates for the Kaspa network should be around 1 per second (soon to be 10/s with Rust deployment) with a variation of roughly +/- 15%.  While job rates consistently higher or lower than this should not technically affect your earnings due to Kaspa's block acceptance policy (assuming the pool is not unnecessarily rejecting 'old' shares), it is a signal that the pool may not be functioning properly, and you may want to alert the pool operator, or possibly find another option.

*It has been communicated by kaspa-pool operators that they intentionally reduce job rate to limit overhead, and that it doesn't affect stale share rates in their case*

Multiple status indicators have been added to the pool section to help diagnose different network / pool issues.  A gray busy (spinning) icon indicates the asic is attempting to connect to the pool.  A green busy icon indicates a network connection, but no stratum connection yet. A yellow warning icon indicates a successful stratum connection, but no jobs have been received.

<br>

### Chip temperature monitoring
The per-board max temp of the hash chips is added to the board stats section.  No guidance has been provided by IceRiver as to safe limits, but their miner software appears to restrict clock raises above 95C, and will actually throttle clocks above 110C.  At least following general guidance from G/CPUs is probably prudent (e.g. >85C warning zone, >95C danger zone, >105C critical zone).  

Anecdotal evidence from users seems to indicate chip temps in the range of 70-80C provided optimal hashrates, at least on KS1/2/3*.  For KS0/PRO, this may be hotter than desired, as exhaust temps (primarily reflecting power stage temps) tend to be higher due to the tight enclosure and lack of airflow.  80c chip temps appear to be ideal for KS0 Ultras for maximum hashrate.

<br>

### Real-time voltage and clock display
The per board real-time average chip voltage and clock values are added to the board stats section.  A spinning indicator is added while clocks are still ramping, indicating that hashrate has not yet reached the target.  Please note that real-time voltage will never match your setting - drivers under load experience voltage drop, meaning the running voltage will always be below the set voltage, with more load causing a greater drop.

<br>

### Primary pool health monitor
Health-check loop run on primary pool availability.  If miner has switched to one of the secondary pools for any reason, you will be switched back to your primary pool as soon as it becomes available again.

<br>

## API

While the previously available API on port 4111 is still available, a new rationalized API including all of the additional features from the UI is now avaiable over https (port 443).

Full documentation is available in [json format](/docs/apidoc.json).

<br>

## General UI improvements
* Dark mode!
* Auto refresh controls
* Responsive design
* Numerous other css/js fixes vs stock firmware.  This is a constant work-in-progress.

<br>

<br>

## Stability and security improvements

### Fix for web server crashes
Replaced stock web server with updated and production environment targeted version, added cache/memory control configuration, and fixed memory leaks.  This should address the issues seen by users of HiveOS and other external monitoring tools that caused the web server to crash after too many page loads (resulting in the ASIC UI being unavailable.)

<br>

### New auth/auth routines
The authentication and authorization controls have been completely replaced, and all traffic redirected over https.  This means forwarding the http(s) traffic through your firewall for off-site monitoring should be much safer (though I would still not necessarily recommend this - simply due to best security practices...) Login is no longer transmitted over unsecured http, and people can no longer hijack your asic simply by setting a cookie to skip login.  The random 'login incorrect' messages due to file system corruption should also be a thing of the past.

Additionally the redesigned API has been secured w/ an access token, through which granular permissions can be assigned.

![Account Page](/docs/images/iceriver-oc_account.png)

Just as you would update the login password, PLEASE DELETE/REPLACE THIS API TOKEN if you plan on exposing your machine publicly, as it is the same across all machines by default.

<br>

### TLS certificate management
The TLS certificates (and certificate authority) for https are automatically generated on the ASIC, meaning they will cause 'Not secure' warnings in your browser since they are not from a well known authority.  While harmless, these warnings can be annoying, so the firmware provides the ability to download the CA certificate so it can be uploaded into your browsers certificate store.

![TLS Certs](/docs/images/iceriver-oc_tls.png)

To do so in Chrome, for instance, go to chrome://settings/security, click on 'Manage Certificates', select the 'Trusted Root Certification Authorities' tab (or just 'Authorities' for Linux), and click on the import button.  After restarting your browser, you should no longer see the 'Not secure' warning.

If you have multiple ASICs, you will have a different CA for each by default.  However, instead of adding each of these to your browser(s) or other devices, you can propagate a single CA across all ASICs by downloading both the CA certificate and CA key from one ASIC, uploading both files to all of your other ASICs, then regenerating the certificate on each of those other ASICs.

If you access your ASIC via a domain name or multiple IPs, you can also add these to the TLS certificate by listing them in the 'Regenerate certificate' field and clicking 'regenerate'.

<br>

### Healthcheck loop
A healthcheck loop has been added, which will automatically restart the miner or web server should either crash for any reason.

Additionally, the 'reset' executable that has been found to randomly disappear from peoples machines (even stock setups), is now packaged with the firmware, and a healthcheck loop has been added to replace/restart the file if necessary.  This should address the 30m reboot loops many people are experiencing.

<br>

# Installation
DO NOT install over the xyys (including tswift branded) firmware on KS0 Ultras or KS5* models.  Please make sure to follow his uninstallation instructions before installing this or any other firmware!

This is a standard firmware update package, including/improving on the latest IceRiver firmware, and applied just as official firmware would be.  Applying over any previous updates should work for KS0/Pro, KS1, KS2, and KS3* models. Applying over stock, or previous versions of this firmware should also work for KS0 Ultra, and KS5* models.

However, if you run into problems, try the following process:
* Restore factory settings
* Restart the machine if it does not do so automatically
* Upload this firmware
* Once again, restart the machine if it does not do so automatically
* Force refresh the web page in your browser and/or clear the cache

Also, make sure to redo your pool settings, as they will have been reset to the default Kaspa Dev Fund address.

<br>

# Usage Tips

### Power and metering
Laptop power supplies for KS0/Pro/Ultra models should generally be 19.5V with 5.5mm x 2.5mm connectors, but the amp rating can vary depending on your OC targets.  However, barrel connectors of this size tend to be rated for either 5 or 10a, and it is unlikely IceRiver used 5a options, so it would be a reasonable assumption that they used 10a (7.5a is another possibility).  This means that any adapter over 200w is likely exceeding the rating of the socket, such that the plug could melt or even catch fire, if not actively cooled (even then the risk remains).  Please be extremely careful should you choose to use one of the higher power laptop charger options.

It is highly recommended you have a power meter attached to your machines, to ensure you are within your PSU limits.  This is especially true for KS3* and KS5* models, which have very little PSU headroom even at stock settings, as well as KS0* models due to the wide range of power supplies.

<br>

### Cooling 

KS0 Pro and Ultra models need special attention to cooling.  The power stages on these already run very hot, so hardware modifications for improved cooling are highly recommended - including heatsinks, and better airflow.

Hash chips on all models tend to perform best in the 75-80c range, but this is especially true for the KS0 Ultra, where even reducing from 80c to 75c, I've experienced a drop in the 2hr hashrate of > 3%.

<br>

### Tuning 

CLOCK OFFSET PERCENTAGE AND HASHRATE INCREASE PERCENTAGE SHOULD BE EQUAL ON A HEALTHY MACHINE.

E.g. if your clock offset is 30% on a KS1, then your hashrate should be 1.3TH/s, or 30% more than the default 1 TH/s.  If this is not the case (over an appropriate measurement window,) then it means your chips are starved for voltage.

Proper tuning is a process that takes time.  Using other peoples settings is generally not a great idea, as every machine is different.  Best practice is to start at a conservative clock offset that results in a matching hashrate increase with no voltage changes.  As you further raise your clocks in small increments (e.g. 25mhz or less), once you no longer see hashrate respond 1:1 (or maybe even start dropping), it is an indication that more voltage is needed.  

At that point, increase voltage by a single step (2mv for KS0 Pro, 7 or 6mv depending on current level for all other models), then see if hashrate responds.  If it does, and once again equals clock offset on a percentage basis, go back to raising clock.  Continue this back and forth between clock and voltage offsets until you reach your desired hashrate, while being mindful of temperature and power limits.

While 5m and 30m hashrates in the GUI are useful tools for directional guidance after the machine has had time to ramp up, final hashrate measurements should be done over an extended time period.  5 minute hashrate readings are quite variable, and even 30 minute hashrate readings aren't great, as you can still have a couple percent variability.  The 2hr reading in the UI should have less than 1% variability from my experience, though it doesn't take hardware errors / pool rejections into account.

<br>

### Reproducing results from other firmware

And finally, if you are trying to replicate the OC results of another firmware...  
* If you previously got X hashrate on the free OC firmware (where X is at least a 30m average from the UI, or a 24 hr avg from the pool), then simply set your clock offset such that the percent increase is (X / \<stock hashrate\>) - 1, with no additional voltage.  For example, if you were getting a 24hr average of 160GH/s on a KS0, then simply set your clock so that the percent increase is (160 / 100) - 1 = 0.6 or 60%.  If you want even higher hashrate, you can then proceed to raise clocks/voltages as appropriate.
* If you previously got X hashrate on another paid OC firmware, the clock setting procedure is the same as above.  However, in addition, the other firmware was also almost certainly setting voltage above stock levels, so after setting the appropriate clock, you should increase voltage one step at a time until the hashrate reaches the expected level.

<br>

# Let's Talk About Hashrates
All OC firmware, including this one, only control clocks and voltages.  It is my experience that given the necessary voltage, the hashrate responds linearly on a 1:1 basis to the clock change, percentage-wise.  But in the end, all we can do is change the clock and hope the ASIC responds with the expected hashrate change.

Hashrate readings in the ASIC UI are not like those from CPU/GPU mining.  IceRiver ASICs are not counting actual hashes - they are simply estimating hashrate based on the number of shares produced * difficulty.  This is exactly how a pool measures your hashrate, but the problem is most pools decided to use way too high of a difficulty for IceRiver ASICs, which prevents reliable short term hashrate measurements - with a high diff, the share rate is low, which means wild swings in hashrate.  As a result, IceRiver released a firmware update which started using a completely different, lower internal difficulty for hashrate measurements on their own dashboard.  

Therefore, even for the same exact timeframe, you cannot reliably compare a pool hashrate measurement to the ASIC UI hashrate - they are not using the same data.  To further exacerbate this, since IceRiver machines were generating a large number of invalid shares early on, a number of pools decided to stop reporting rejected shares back to the ASIC so users would stop complaining (or switching pools), and instead report them as accepted, while still silently rejecting them on their end.  Depending on the true reject rate, this can mean a significant divergence between the ASIC hashrate and the pool hashrate, even if they were measured using the same timeframe and difficulty.

Regardless of the diff selected, hashrate measurements based on shares * difficulty are subject to swings based on luck.  The lower the share count (higher the diff), the more luck affects the hashrate, and the wilder the swings.  Thus, to have a statistically meaningful hashrate measurement, you need enough shares to reduce the effect of luck as much as possible.  The 5m reading on the ASIC are not suitable for this, especially when trying to verify the result of single digit OC changes, and short term pool readings are even worse.

You need 1200 shares just to get to an expected variance of +/- 10% with 99% confidence.  E.g. for an expected hashrate of 1TH/s, in 99/100 measurements after 1200 shares, you will have a reading between 0.9TH/s and 1.1TH/s.  You need 4800 shares to reduce that variance to +/- 5%.  Many pools are using difficulties that produce share rates in the ~5 shares/min range.  Therefore, just to get a hashrate reading with an expected variance of <= +/- 10%, you would need a 1200 / 5 = 240 minute, or 4 hour reading.  If you want a reading with an expected variance +/- 5%, you would need over 16 hours of data.  You will never be able to confirm the results of an OC level below the expected variance of a given timeframe.  For example, you cannot possibly determine whether a 5% OC is working properly in a 4 hr / 1200 share window having 10% expected variance.  Even at 16hrs / 4800 shares, the expected variance can completely cancel out a 5% OC.  

And this leads to the crux of the issue - most pools do not provide anything higher than a 24hr measurement, which at ~5 shares/minute means roughly 7200 shares, which is still a 4% expected variance.  You need 10K shares just for 3.3% variance, and about 100K shares for a 1% variance.  The 30m reading in the ASIC UI should have around a 2% variance, and the new 2hr reading should have less than 1% variance, but neither reflect the pool rejects.  Therefore, the only solution then, is to find a pool that lets you set your own difficulty, so that you can generate a statistically relevant number of shares for their available timeframes.  While Herominers seems to have this functionality, my recent tests seem to indicate it is not working, at least for a KS3.  

The only option I know of which reliably allows setting your own diff is solo mining to your own node and the [kaspa-stratum-bridge](https://github.com/rdugan/kaspa-stratum-bridge). The default vardiff settings will produce a minimum 20 shares/min, which is enough to have <= +/- 5% variance in 4hrs, and the dashboard (grafana) allows measurements in any timeframe/resolution you want, including signficantly longer timeframes than 24hrs.  

As a concrete example of the difference between valid and invalid measurements (as well as how kaspa-stratum-bridge can help), here's the hashrate readings of 3 machines using diffs producing >= 30 shares/min, a KS0 at 51% OC, a KS1 at 37% OC, and a KS3M at 1% OC.  The measurements are, from top to bottom, 24hrs (>= 43K shares), 1hr (>= 1800 shares), and 30m (> 900 shares).  You can see how divergent the measurements can be from expected for the shorter timeframes:

![KS0, KS1, KS3M OC Hashrates](/docs/images/hashrates.png)


In short, if you are trying to confirm the effects of a small OC on the ASIC UI, you will need to use the 2hr reading, but you won't know whether you're generating shares that would be rejected.  To get the full picture, you will need a long term measurement from a pool that allows high share rates - and there are no options I can point to that can do this at this time, other than mining to your own node + kaspa-stratum-bridge.
