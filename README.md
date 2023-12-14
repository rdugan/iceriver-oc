# IceRiver Overclocking Firmware
Modified firmware for IceRiver ASICs, adding overclocking, voltage control and other goodies

Customizable OC/OV, small fee benefitting the community, no unnecessary changes to your device.

# Fee
* 1% fee directed to the official Kaspa Development Fund.
* Current agreement with fund treasurers that half will be sent back to myself until further notice, in order to recoup development/maintenance costs.

# Issues
* If you find that the ASIC has stopped hashing, it is most likely the dev fee process cannot connect to a pool.  This problem can possibly manifest after some indeterminate length of normal mining operation, simply due to network interruptions.  If you use K1 Pool, the probability if higher, as this pool uses a different connection method that is not currently supported by the dev fee.  This will be fixed shortly, but in the meantime, I would recommend using a different pool (K1 should not be used as a backup either.)

# Features
### Configurable clock and voltage offset on 'Mining setting' page
Clock can be increased to any value you want, in positive multiples of 10Mhz.  Increases will take effect without restarting, but decreases will require a restart.

Voltage can be increased or decreased to any integer value, but will be rounded down to the nearest 6.25mV internally.  E.g. a value of 7-12mV will result in an actual increase of 6.25mV, while a decrease of -1 to -6mV will result in an actual decrease of -6.25mV.  A simple model to keep in mind is that for every 25mv increase, the proper increments are 7mv-6mv-6mv-6mv.

Please note, clock is increased gradually from the base clock in 25Mhz increments by the hardware, so it may take some time to get to full speed, possibly even ~30 minutes, depending on how large of an offset you choose.

IMPORTANT: There are currently no guardrails, and no software defined limits on either clocks or voltage, so use with care.

### Chip temperature monitoring
The per-board max temp of the actual asic chips is added to the 'Home' page for monitoring effects of overclocking.  No guidance has been provided by IceRiver as to safe limits, but at least following general guidance from G/CPUs is probably prudent (e.g. >80C warning zone, >90C danger zone, >100C critical zone).

### Fan settings reapplied at startup
Fixed/manual fan speeds will now be reapplied at startup, after a ~1m delay.

### Primary pool health monitor
Health-check loop run on primary pool availability.  If miner has switched to one of the secondary pools for any reason, you will be switched back to your primary pool as soon as it becomes available again.

### General UI improvements

# Installation
This is a standard firmware update package, including/improving on the latest IceRiver firmware, and applied just as official firmware would be.  Applying over any previous updates should work.

However, if you run into problems, I have found the following process provides the best/most consistent results.
* Restore factory settings
* Restart the machine if it does not do so automatically
* Upload this firmware
* Once again, restart the machine if it does not do so automatically
* Force refresh the web page in your browser and/or clear the cache

Also, make sure to redo your pool settings, as they will have been reset to the default Kaspa Dev Fund address.

# Usage Tips
Clock offset percentage and hashrate increase percentage should be equal on a healthy machine.  E.g. if your clock offset is 30% on a KS1, then your hashrate should be 30% more than the default 1 TH/s, or 1.3 TH/s.  If this is not the case (over an appropriate measurement window,) then it means your chips are starved for voltage.

Proper tuning is a process that takes time.  Using other peoplse settings is generally not a great idea, as every machine is different.  Best practice is to start at a conservative clock offset that results a matching hashrate increase with no voltage changes.  As you further raise your clocks in small increments (e.g. 20mhz), once you no longer see hashrate respond 1:1 (or maybe even start dropping), it is an indication that more voltage is needed.  At that point, increase voltage by a single increment, then see if hashrate responds.  If it does, and once again equals clock offset on a percentage basis, go back to raising clock.  Continue this back and forth between clock and voltage offsets until you reach your desired hashrate, while being mindful of temperature and power limits.
