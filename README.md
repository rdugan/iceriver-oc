# IceRiver Overclocking Firmware
Modified firmware for IceRiver ASICs, adding overclocking, voltage control and other goodies

Customizable OC/OV, small fee benefitting the community, no unnecessary changes to your device.

# Fee
* 1% fee directed to the official Kaspa Development Fund.
* Current agreement with fund treasurers that half will be sent back to myself until further notice, in order to recoup development/maintenance costs.

# Features
### Configurable clock and voltage offset on 'Mining setting' page
Clock can be increased to any value you want, in positive multiples of 10Mhz.  Increases will take effect without restarting, but decreases will require a restart.

Voltage can be increased or decreased to any integer value, but will be rounded down to the nearest 6.25mV internally.  E.g. a value of 7-12mV will result in an actual increase of 6.25mV, while a decrease of -1 to -6mV will result in an actual decrease of -6.25mV.

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
