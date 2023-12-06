# IceRiver OC
Modified firmware for IceRiver ASICs, adding overclocking and other goodies
Customizable OC, small fee benefitting the community, no unnecessary changes to your device.

# Fee
* 1% fee directed to the official Kaspa Development Fund.
* Current agreement with fund treasurers that half will be sent back to myself until further notice, in order to recoup development/maintenance costs.

# Features
### Configurable clock offset on 'Mining setting' page
Clock can be increased to any value you want, in positive multiples of 10Mhz.  There are currently no guardrails, and no set upper limits, so use with care.

Please note, clock is increased gradually from the base clock in 25Mhz increments by the hardware, so it may take some time to get to full speed, depending on how large of an offset you choose.

### Chip temperature monitoring
The per-board max temp of the actual asic chips is added to the 'Home' page for monitoring effects of overclocking.  No guidance has been provided by IceRiver as to safe limits, but at least following general guidance from G/CPUs is probably prodent (e.g. >80C warning zone, >90C danger zone, >100C critical zone).

### Fan settings reapplied at startup
Fixed/manual fan speeds will now be reapplied at startup, after a ~1m delay.

### General UI improvements

# Installation
This is a standard firmware update package, including/improving on the latest IceRiver firmware, and applied just as official firmware would be.  However, I have found the following process provides the best/most consistent results.
* Restore factory settings
* Restart the machine if it does not do so automatically
* Upload this firmware
* Once again, restart the machine if it does not do so automatically
* Force refresh the web page in your browser and/or clear the cache

Also, make sure to redo your pool settings, as they will have been reset to the default Kaspa Dev Fund address.
