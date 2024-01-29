# IceRiver Overclocking Firmware
Modified firmware for all IceRiver ASICs except KS0Pro, adding overclocking, voltage control and other goodies

Customizable OC/OV, small fee benefitting the community, no unnecessary changes to your device.

Firmware files can be downloaded from the Releases section on the right hand side of this page.

If you have any issues, finding me (pbfarmer) in the Kaspa Discord will probably result in the fastest response/resolution.

<br>

# Special Thanks

None of these firmwares would be possible without a number of people's efforts in testing and feedback (as well as specific efforts in pulling the stock firmware from the KS0 Pro - these people are mentioned in the release notes.)  

However, one person in particular has sacrificed his machines from the beginning, granting me direct access for development, allowing me to risk his machines while testing brand new features, and suffering numerous mining interruptions during the frequent updates and restarts.  

This person goes by the Discord handle Onslivion - it would be great if you could drop him a thanks on the Kaspa Discord, and maybe even send him a tip or some of your hashrate ( kaspa:qzh2xglq33clvzm8820xsj7nnvtudaulnewxwl2kn0ydw9epkqgs2cjw6dh3y ).

<br>

# Fee
* 1% fee directed to the official Kaspa Development Fund.
* Current agreement with fund treasurers that half will be sent back to myself until further notice, in order to recoup development/maintenance costs.
* Fee traffic is directed to *.kaspa.pool.pbfarmer.cc, which is currently just an alias for Herominers (e.g. us.kaspa.pool.pbfarmer.cc => us.kaspa.herominers.com).  If the system is unable to connect to one of the 5 closest Herominers pools, OC will be removed until a connection is once again available.  A warning indicator will appear in the UI in such situations.
<br>

# Issues
* A number of people have found that the fee traffic or maybe domain name are tripping spam/ddos/botnet protections in their routers, which commonly target mining traffic.  If your ASIC seems to connect to pools but is not mining, check for these types of settings in your router and try disabling them.  For exmaple, in my ASUS router, I need to disable the AIProtection features called 'Two-Way IPS' and 'Infected Device Prevention and Blocking' to do any sort of crypto mining.
* There may be incompatiblities between HiveOS/AsicHub and this firmware, since I've modified the stock UI.  If you witness strange behavior like wildly fluctuating hashrate, odd temperature readings, or random restarts, try disconnecting from AsicHub to see if the the problem goes away.  If so, please let me know on GitHub or Discord if possible, so I can try to find a solution.

<br>

# Features

## Configuration additions/updates

<br>

### Configurable clock and voltage offset on 'Mining setting' page

![Performance Settings](/docs/images/iceriver-oc_settings.png)

Clock can be increased/decreased to any integer value (within hardware limits).  Changes take effect immediately without restart, but note that clock increases are gradually applied in increments of 25Mhz per 30s (25Mhz per 2m for KS3/M/L and KS0 Pro due to slow feedback from the hardware).  As a result, it may take some time to get to full speed, possibly even ~10 minutes, depending on how large of an offset you choose.  KS3/M/L models seem to have their own internal hardware delay, where clock changes do not register for roughly 2 minutes normally, while taking about 5 minutes after a reboot.

Voltage can be increased/decreased to any integer value (within hardware limits), with changes taking effect immediately.  Settings will be rounded down to the nearest multiple of 6.25mV internally.  A simple model to keep in mind is that for every 25mv increase, the proper increments are 7mv-6mv-6mv-6mv, or for example, 7, 13, 19, 25 for the first 25mv. VOLTAGE CONTROL IS NOT AVAILABLE FOR KS3/M/L AT THIS TIME.

<br>

*IMPORTANT: THERE ARE CURRENTLY NO GUARDRAILS, AND NO LIMITS ENFORCED BY THIS SOFTWARE ON EITHER CLOCKS OR VOLTAGE, SO USE WITH CARE.*

<br>

### Better fan controls

![Performance Settings](/docs/images/iceriver-oc_fan_settings.png)

A new fan mode has been added which automatically adjusts fan speed to maintain a max chip temperature.  Temps are read every 10s for KS0/1/2 and fan speed is adjusted as necessary.  

Unfortunately, chip temps are only updated by the ASIC every 2minutes for KS3/M/L and KS0 Pro, so fan adjustments for these models are much slower.  While the new fan mode may still be used for those models, it is suggested to use a high minimum fan speed (maybe >= 70%), so that periods of highly dynamic temperature ranges (such as startup) do not cause excessive chip temps while the fan control is waiting on feedback.

Please note, this setting does not guarantee the set temperature.  It may overshoot during startup or other dynamic periods, but it should stabilize at or near (within a few degrees) the requested temperature.

Fixed/manual fan speeds will now be reapplied at startup, after a ~1m delay.

<br>

<br>

## Additional telemetry and other changes to home page

<br>

### Graphing of chip temps/clocks/voltages and longer term hashrates

![Home Page](/docs/images/iceriver-oc_home.png)

Two hours of graphing has been added for all chip metrics, with filters for summaries (per board min/max/avg), board, or all chips.  Hashrate graphing (as well as the headline stats) now includes 30m and 2hr tracking, and also includes board level filtering.  

Instantaneous values are shown in the legend, and individual lines can be disabled/enabled by clicking on the labels.  Graph scales are no longer zero based, and adjust depending on which lines are displayed, meaning they are no longer artifically flattend by poor resolution, and you can actually see the variability in each measurement.

*Hopefully this helps clear up how useless 5m readings really are.*

<br>

### Uptime and job rate on pool status

![Home Page](/docs/images/iceriver-oc_pools_fans.png)

The uninterrupted uptime, and job issuance rate are added to the pool stats section.  Job rate is simply an additional health indicator of a pool connection - currently job rates for the Kaspa network should be around 1 per second (soon to be 10/s with Rust deployment) with a variation of roughly +/- 15%.  While job rates consistently higher or lower than this should not technically affect your earnings due to Kaspa's block acceptance policy (assuming the pool is not unnecessarily rejecting 'old' shares), it is a signal that the pool may not be functioning properly, and you may want to alert the pool operator, or possibly find another option.

*It has been communicated by kaspa-pool operators that they intentionally reduce job rate to limit overhead, and that it doesn't affect stale share rates in their case*

<br>

### Chip temperature monitoring
The per-board max temp of the actual asic chips is added to the board stats section.  No guidance has been provided by IceRiver as to safe limits, but their miner software appears to restrict clock raises above 95C, and will actually throttle clocks above 110C.  At least following general guidance from G/CPUs is probably prudent (e.g. >85C warning zone, >95C danger zone, >105C critical zone).

<br>

### Real-time voltage and clock display with clock ramping indicator
The per board real-time average chip voltage and clock values are added to the board stats section.  A spinning indicator is added next to the clocks while they are still ramping, indicating that hashrate has not yet reached the target.  Please note that real-time voltage will never match your setting - drivers under load experience something called 'droop', meaning the running voltage will always be below the set voltage, with more load causing greater droop.

<br>

### Primary pool health monitor
Health-check loop run on primary pool availability.  If miner has switched to one of the secondary pools for any reason, you will be switched back to your primary pool as soon as it becomes available again.

<br>

### General UI improvements

<br>

<br>

## Stability improvements

<br>

### Fix for web server crashes
Replaced stock web server with updated and production environment targeted version, while adding cache/memory control configuration.  This should address the issues seen by users of HiveOS and other external monitoring tools that caused the web server to crash after too many page loads (resulting in the ASIC UI being unavailable.)

<br>

### Healthcheck loop on web server
In addition to the previous change, a healthcheck loop has been added, which will automatically restart the web server should it crash for any other reason.

<br>

# Installation
This is a standard firmware update package, including/improving on the latest IceRiver firmware, and applied just as official firmware would be.  Applying over any previous updates should work.

However, if you run into problems, try the following process:
* Restore factory settings
* Restart the machine if it does not do so automatically
* Upload this firmware
* Once again, restart the machine if it does not do so automatically
* Force refresh the web page in your browser and/or clear the cache

Also, make sure to redo your pool settings, as they will have been reset to the default Kaspa Dev Fund address.

<br>

# Usage Tips
It is highly recommended you have a power meter attached to your machines, to ensure you are within your PSU limits.  This is especially true for KS3M, which has very little PSU headroom even at stock settings.

CLOCK OFFSET PERCENTAGE AND HASHRATE INCREASE PERCENTAGE SHOULD BE EQUAL ON A HEALTHY MACHINE.

E.g. if your clock offset is 30% on a KS1, then your hashrate should be 1.3TH/s, or 30% more than the default 1 TH/s.  If this is not the case (over an appropriate measurement window,) then it means your chips are starved for voltage.

Proper tuning is a process that takes time.  Using other peoples settings is generally not a great idea, as every machine is different.  Best practice is to start at a conservative clock offset that results in a matching hashrate increase with no voltage changes.  As you further raise your clocks in small increments (e.g. 25mhz or less), once you no longer see hashrate respond 1:1 (or maybe even start dropping), it is an indication that more voltage is needed.  

At that point, increase voltage by a single step (7 or 6mv depending on current level), then see if hashrate responds.  If it does, and once again equals clock offset on a percentage basis, go back to raising clock.  Continue this back and forth between clock and voltage offsets until you reach your desired hashrate, while being mindful of temperature and power limits.

While 5m and 30m hashrates in the GUI are useful tools for directional guidance after the machine has had time to ramp up, final hashrate measurements should be done over an extended time period.  5 minute hashrate readings are HIGHLY variable, and even 30 minute hashrate readings aren't great, as you can still have >15% variability.  An average of a couple 30 minute windows (or a 1hr or greater measurement from your pool) is probably the minimum to use for fine tuning, until i have the chance to add better measurements.

And finally, if you are trying to replicate the results of another OC...  
* If you previously got X hashrate on the free OC firmware (where X is at least a 6-24hr average, not a 5m or 30m value from the ASIC UI), then simply set your clock offset such that the percent increase is (X / \<stock hashrate\>) - 1, with no additional voltage.  For example, if you were getting a 24hr average of 160GH/s on a KS0, then simply set your clock so that the percent increase is (160 / 100) - 1 = 0.6 or 60%.  If you want even higher hashrate, you can then proceed to raise clocks/voltages as appropriate.
* If you previously got X hashrate on another paid OC firmware, the clock setting procedure is the same as above.  However, in addition, the other firmware was also almost certainly setting voltage above stock levels, so after setting the appropriate clock, you should increase voltage one step at a time until the hashrate reaches the expected level.

<br>

# Let's Talk About Hashrates
All OC firmware, including this one, only control clocks and voltages.  It is my experience that given the necessary voltage, the hashrate responds linearly on a 1:1 basis to the clock change, percentage-wise.  But in the end, all we can do is change the clock and hope the ASIC responds with the expected hashrate change.

Hashrate readings in the ASIC UI are not like those from CPU/GPU mining.  IceRiver ASICs are not counting actual hashes - they are simply estimating hashrate based on the number of shares produced * difficulty.  This is exactly how a pool measures your hashrate, but the problem is most pools decided to use way too high of a difficulty for IceRiver ASICs, which prevents reliable short term hashrate measurements - with a high diff, the share rate is low, which means wild swings in hashrate.  As a result, IceRiver released a firmware update which started using a completely different, lower internal difficulty for hashrate measurements on their own dashboard.  

Therefore, even for the same exact timeframe, you cannot reliably compare a pool hashrate measurement to the ASIC UI hashrate - they are not using the same data.  To further exacerbate this, since IceRiver machines were generating a large number of invalid shares early on, a number of pools decided to stop reporting rejected shares back to the ASIC so users would stop complaining (or switching pools), and instead report them as accepted, while still silently rejecting them on their end.  Depending on the true reject rate, this can mean a significant divergence between the ASIC hashrate and the pool hashrate, even if they were measured using the same timeframe and difficulty.

Regardless of the diff selected, hashrate measurements based on shares * difficulty are subject to swings based on luck.  The lower the share count (higher the diff), the more luck affects the hashrate, and the wilder the swings.  Thus, to have a statistically meaningful hashrate measurement, you need enough shares to reduce the effect of luck as much as possible.  Neither 5m, nor 30m readings on the ASIC are suitable for this, especially when trying to verify the result of single digit OC changes, and short term pool readings are even worse.

You need 1200 shares just to get to an expected variance of +/- 10% with 99% confidence.  E.g. for an expected hashrate of 1TH/s, in 99/100 measurements after 1200 shares, you will have a reading between 0.9TH/s and 1.1TH/s.  You need 4800 shares to reduce that variance to +/- 5%.  Many pools are using difficulties that produce share rates in the ~5 shares/min range.  Therefore, just to get a hashrate reading with an expected variance of <= +/- 10%, you would need a 1200 / 5 = 240 minute, or 4 hour reading.  If you want a reading with an expected variance +/- 5%, you would need over 16 hours of data.  You will never be able to confirm the results of an OC level below the expected variance of a given timeframe.  For example, you cannot possibly determine whether a 5% OC is working properly in a 4 hr / 1200 share window having 10% expected variance.  Even at 16hrs / 4800 shares, the expected variance can completely cancel out a 5% OC.  

And this leads to the crux of the issue - most pools do not provide anything higher than a 24hr measurement, which at ~5 shares/minute means roughly 7200 shares, which is still a 4% expected variance.  You need 10K shares just for 3.3% variance, and about 100K shares for a 1% variance.  The only solution then, is to find a pool that lets you set your own difficulty, so that you can generate a statistically relevant number of shares for their available timeframes.  While Herominers seems to have this functionality, my recent tests seem to indicate it is not working, at least for a KS3.  

The only option I know of which reliably allows setting your own diff is solo mining to your own node and the [kaspa-stratum-bridge](https://github.com/rdugan/kaspa-stratum-bridge). The default vardiff settings will produce a minimum 20 shares/min, which is enough to have <= +/- 5% variance in 4hrs, and the dashboard (grafana) allows measurements in any timeframe/resolution you want, including signficantly longer timeframes than 24hrs.  

As a concrete example of the difference between valid and invalid measurements (as well as how kaspa-stratum-bridge can help), here's the hashrate readings of 3 machines using diffs producing >= 30 shares/min, a KS0 at 51% OC, a KS1 at 37% OC, and a KS3M at 1% OC.  The measurements are, from top to bottom, 24hrs (>= 43K shares), 1hr (>= 1800 shares), and 30m (> 900 shares).  You can see how divergent the measurements can be from expected for the shorter timeframes:

![KS0, KS1, KS3M OC Hashrates](/docs/images/hashrates.png)


In short, if you are trying to confirm the effects of a small OC on the ASIC UI, it is simply impossible - you will never be able to separate the signal from the noise.  You may be able to do so on your pool (depending which one you use), but you will need to use long term measurements.  5/30m readings will never be enough, even at the minimum difficulty required by the ASIC.
