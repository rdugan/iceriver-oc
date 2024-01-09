# IceRiver Overclocking Firmware
Modified firmware for all IceRiver ASICs except KS0Pro, adding overclocking, voltage control and other goodies

Customizable OC/OV, small fee benefitting the community, no unnecessary changes to your device.

Firmware files can be downloaded from the Releases section on the right hand side of this page.

If you have any issues, finding me (pbfarmer) in the Kaspa Discord will probably result in the fastest response/resolution.

<br>

# Fee
* 1% fee directed to the official Kaspa Development Fund.
* Current agreement with fund treasurers that half will be sent back to myself until further notice, in order to recoup development/maintenance costs.
* Fee traffic is directed to Herominers at this time.  If the system is unable to connect to one of the 5 closest Herominers pools, OC will be removed until a connection is once again available.  A warning indicator will appear in the UI in such situations.
<br>

# Features

## Configuration additions/updates

<br>

### Configurable clock and voltage offset on 'Mining setting' page

![Performance Settings](/docs/images/iceriver-oc_settings.png)

Clock can be increased/decreased to any integer value (within hardware limits).  Changes take effect immediately without restart, but note that clock increases are gradually applied in increments of 25Mhz per 30s.  As a result, it may take some time to get to full speed, possibly even ~10 minutes, depending on how large of an offset you choose.  KS3/M/L models seem to have their own internal hardware delay, where clock changes do not register for roughly 2 minutes normally, while taking about 5 minutes after a reboot.

Voltage can be increased/decreased to any integer value (within hardware limits), with changes taking effect immediately.  Settings will be rounded down to the nearest multiple of 6.25mV internally.  A simple model to keep in mind is that for every 25mv increase, the proper increments are 7mv-6mv-6mv-6mv, or for example, 7, 13, 19, 25 for the first 25mv. VOLTAGE CONTROL IS NOT AVAILABLE FOR KS3/M/L AT THIS TIME.

<br>

*IMPORTANT: THERE ARE CURRENTLY NO GUARDRAILS, AND NO LIMITS ENFORCED BY THIS SOFTWARE ON EITHER CLOCKS OR VOLTAGE, SO USE WITH CARE.*

<br>

### Fan settings reapplied at startup
Fixed/manual fan speeds will now be reapplied at startup, after a ~1m delay.

<br>

<br>

## Additional telemetry and other changes to home page

![Home Page](/docs/images/iceriver-oc_home.png)

<br>

### Chip temperature monitoring
The per-board max temp of the actual asic chips is added to the 'Home' page for monitoring effects of overclocking.  No guidance has been provided by IceRiver as to safe limits, but their miner software appears to restrict clock raises above 95C, and will actually throttle clocks above 110C.  At least following general guidance from G/CPUs is probably prudent (e.g. >80C warning zone, >90C danger zone, >100C critical zone).

<br>

### Real-time voltage and clock display with clock ramping indicator
The per board real-time average chip voltage and clock values are added to the 'Home' page.  A spinning indicator is added next to the clocks while they are still ramping, indicating that hashrate has not yet reached the target.  Please note that real-time voltage will never match your setting - drivers under load experience something called 'droop', meaning the running voltage will always be below the set voltage, with more load causing greater droop.

<br>

### Uptime and job rate on pool status
The uninterrupted uptime, and job issuance rate are added per pool on the 'Home' page.  Job rate is simply an additional health indicator of a pool connection - currently job rates for the Kaspa network should be around 1 per second (soon to be 10/s with Rust deployment) with a variation of roughly +/- 15%.  While job rates consistently higher or lower than this should not technically affect your earnings due to Kaspa's block acceptance policy (assuming the pool is not unnecessarily rejecting 'old' shares), it is a signal that the pool may not be functioning properly, and you may want to alert the pool operator, or possibly find another option.

*It has been communicated by kaspa-pool operators that they intentionally reduce job rate to limit overhead, and that it doesn't affect stale share rates in their case*

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
