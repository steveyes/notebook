

# live CD



## create a bootable USB stick on Windows

1. install Rufus
2. launch Rufus
3. Insert your USB stick
4. Rufus will update to set the device within the **Device** field
5. Select the correct **Device** from the device field’s drop-down menu
6. Select **FreeDOS** from the Boot selection field's drop-down menu
7. The default selections for Partition scheme (*MBR*) and Target system (*BIOS (or UEFI-CSM)*) are appropriate (and are the only options available).
8. To select the Ubuntu ISO file, click the **SELECT** to the right of Boot selection.
9. Leave all other parameters with their default values and click **START** to initiate the write process.
10. You may be alerted that Rufus requires additional files to complete writing the ISO. If this dialog box appears, select **Yes** to continue.
11. Keep *Write in ISO Image mode* selected and click on **OK** to continue.
12. Rufus will also warn you that all data on your selected USB device is about to be destroyed. This is a good moment to double check you’ve selected the correct device before clicking **OK** when you’re confident you have.
13. When Rufus has finished writing the USB device, the Status bar will be green filled and the word **READY** will appear in the center. Select **CLOSE** to complete the write process.







## boot from LiveCD and update grub

### mount OS partition

lets say /dev/sda1 is the partition where grub is installed

```
sudo mount /dev/sda1 /mnt
```

### mount dev, sys and proc

```
sudo mount --bind /dev /mnt/dev
sudo mount --bind /sys /mnt/sys
sudo mount --bind /proc /mnt/proc
```

### chroot

```
sudo chroot /mnt
```

### update grub

```
sudo update-grub
```

### exit chroot

```
exit
```

### unmount

```
umount /mnt/dev
umount /mnt/sys
umount /mnt/proc
umount /mnt
```

### reboot

```
sudo init 6
```









