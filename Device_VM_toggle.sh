#!/bin/bash
# Toggle keyboard passthrough for Boxes

# See vendor:product from lsusb 


DEVICE=046d:c33f


# GET automatically the first VM of user

VENDOR="0x$(echo $DEVICE | cut -d':' -f1)"
PRODUCT="0x$(echo $DEVICE | cut -d':' -f2)"
VM=$(virsh list --state-running | awk 'NR>2 {print $2; exit}')
URI=$(virsh uri)

# set manually if you want

# VENDOR="0x046d"
# PRODUCT="0xc33f"
# VM="win10"
# URI="qemu:///session"

# Check if device is currently attached
if virsh --connect "$URI" dumpxml "$VM" | grep -q "$PRODUCT"; then
    virsh --connect "$URI" detach-device "$VM" --live --file <(echo "
<hostdev mode='subsystem' type='usb'>
  <source>
    <vendor id='$VENDOR'/>
    <product id='$PRODUCT'/>
  </source>
</hostdev>")
else
    virsh --connect "$URI" attach-device "$VM" --live --file <(echo "
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='$VENDOR'/>
    <product id='$PRODUCT'/>
  </source>
</hostdev>")
fi
