

# Methods To Check If A Linux System Is Physical or Virtual Machine



#### Method-1 : Using dmidecode Command

dmidecode command reads the system DMI (Desktop Management Interface) table to display about your system’s hardware and BIOS information. The table has system manufacturer, model name, serial number, BIOS version, CPU sockets, expansion slots, memory module slots, and the list of I/O ports, etc.



VMware Workstation
```
# dmidecode -s system-manufacturer
VMware, Inc.

# dmidecode -s system-product-name
VMware Virtual Platform
```



VirtualBox

```
$ sudo dmidecode -s system-product-name
VirtualBox
```



OpenStack

```
$ sudo dmidecode -s system-product-name
OpenStack Nova
```



Physical Server

```
# dmidecode -s system-manufacturer
IBM

# dmidecode -s system-product-name
System x3550 M2 -[7284AC1]-
```




#### Method-2 : Using lshw Command

lshw (Hardware Lister) is a small tool to provide detailed information on the hardware configuration of the machine. It can report exact memory configuration, firmware version, mainboard configuration, CPU version and speed, cache configuration, bus speed, etc. on DMI-capable x86 or EFI (IA-64) systems and on some PowerPC machines (PowerMac G4 is known to work).



lshw Command Output in VMware Workstation

```
# lshw -class system
2daygeek
    description: Computer
    product: VMware Virtual Platform ()
    vendor: VMware, Inc.
    version: None
    serial: VMware-42 0a a0 62 85 7e 8d 48-f2 8f 15 5a aa 7f 77 95
    width: 64 bits
    capabilities: smbios-2.4 dmi-2.4 vsyscall32
    configuration: administrator_password=enabled boot=normal frontpanel_password=unknown keyboard_password=unknown power-on_password=disabled uuid=420AA062-857E-8D48-F28F-155AAA7F7795
  *-remoteaccess UNCLAIMED
       vendor: Intel
       physical id: 1
       capabilities: inbound
```



Alternatively use lshw command to print only product

```
# lshw -class system | grep product
product: VMware Virtual Platform ()
```



lshw Command Output in VirtualBox

```
$ sudo lshw -class system
daygeek                     
    description: Computer
    product: VirtualBox
    vendor: innotek GmbH
    version: 1.2
    serial: 0
    width: 64 bits
    capabilities: smbios-2.5 dmi-2.5 smp vsyscall32
    configuration: family=Virtual Machine uuid=762A99BF-6916-450F-80A6-B2E9E78FC9A1
```



Alternatively use lshw command to print only product
```
# lshw -class system | grep product | awk '{print $2}'
VirtualBox
```



lshw Command Output in Physical Server

```
# lshw -class system
2daygeek
    description: Blade
    product: Flex System x240 Compute Node -[7284AC1]-
    vendor: IBM
    version: 06
    serial: KQ3YZ9B
    width: 64 bits
    capabilities: smbios-2.7 dmi-2.7 vsyscall32
    configuration: boot=normal chassis=enclosure family=System X uuid=8B57E5D1-7002-3F3C-8765-
```



Alternatively use lshw command to print only product
```
# lshw -class system | grep product
product: Flex System x240 Compute Node -[7284AC1]-
```



#### Method-3 : Using facter Command

Facter is a standalone tool based on Ruby that provides system information.

```
[VMware Workstation]
# facter virtual
vmware

[VirtualBox]
$ facter virtual
virtualbox

[Physical Server]
# facter virtual
physical
```



#### Method-4 : Using imvirt Command

imvirt is a set of Perl modules which used to detect whether the Linux box is physical or virtual. If it detects that it is a virtualized one, then it tries to find out which virtualization technology is used.

```
[VMware Workstation]
# imvirt
VMware VMware ESX Server

[VirtualBox]
$ imvirt
KVM

[Physical Server]
# imvirt
Physical
```



#### Method-5 : Using virt-what Command

virt-what is a small shell script which can be used to detect if the Linux box is running in a virtual machine. Also its print the virtualization technology is used. If nothing is printed and the script exits with code 0 (no error), then it physical server.

```
[VMware Workstation]
# virt-what
vmware

[VirtualBox]
$ sudo virt-what
virtualbox
kvm

[Physical Server]
# virt-what
```



#### Method-6 : Using systemd-detect-virt Command

systemd-detect-virt detects execution in a virtualized environment. It identifies the virtualization technology and can distinguish full machine virtualization from container virtualization.

```
[VirtualBox]
$ systemd-detect-virt
oracle

[Physical]
$ systemd-detect-virt
None
```



#### Method-7 : Using hostnamectl Command

The hostnamectl tool is provided to administrate the system hostname. There are three separate classes of host names in use on a given system, static, pretty, and transient.



**VirtualBox Output**

```
# hostnamectl
or
# hostnamectl status
   Static hostname: daygeek
         Icon name: computer-vm
           Chassis: vm
        Machine ID: c01b17d61f2542478047952180768c82
           Boot ID: 8be91fafab024c5880581fb3968a22f8
    Virtualization: oracle
  Operating System: Ubuntu 16.10
            Kernel: Linux 4.10.1-041001-generic
      Architecture: x86-64
```



**Physical Output**

```
# hostnamectl
or
# hostnamectl status
   Static hostname: daygeek
         Icon name: computer-laptop
           Chassis: laptop
        Machine ID: bb8348e0f32e495184590f98ce96ee62
           Boot ID: 06ee2c95917744b9b23a2861a0a82abb
  Operating System: Fedora 25 (Workstation Edition)
       CPE OS Name: cpe:/o:fedoraproject:fedora:25
            Kernel: Linux 4.10.14-200.fc25.x86_64
      Architecture: x86-64
```



#### Method-8 : Using dmesg Command

The dmesg command is used to write the kernel messages (boot-time messages) in Linux before syslogd or klogd start. It obtains its data by reading the kernel ring buffer. dmesg can be very useful when troubleshooting or just trying to obtain information about the hardware on a system.

```
[VMware Workstation]
# dmesg |grep DMI
[    0.000000] DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/02/201

[Physical Server]
# dmesg |grep DMI
DMI: IBM System x3650 M4: -[7915AC1]-/00Y8494, BIOS -[VVE134MUS-1.50]- 18/20/2015

[VirtualBox]
# dmesg |grep DMI
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
```



#### Method-9 : Using /proc/cpuinfo file

/proc/cpuinfo is a virtual text file that contains information about the CPUs (central processing units) on a computer. We can get a system machine type by grepping `hypervisor` parameter.

```
[VirtualBox]
# grep hypervisor /proc/cpuinfo
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc up rep_good unfair_spinlock pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm xsaveopt tpr_shadow vnmi flexpriority ept vpid fsgsbase bmi1 avx2 smep bmi2 erms invpcid
```



#### Method-10 : Using /sys file system

The kernel expose some DMI information in the /sys virtual filesystem. So we can easily get the machine type by running grep command with following format.

```
# grep "" /sys/class/dmi/id/[pbs]*
/sys/class/dmi/id/bios_date:12/01/2006
/sys/class/dmi/id/bios_vendor:innotek GmbH
/sys/class/dmi/id/bios_version:VirtualBox
/sys/class/dmi/id/board_asset_tag:
/sys/class/dmi/id/board_name:VirtualBox
/sys/class/dmi/id/board_serial:0
/sys/class/dmi/id/board_vendor:Oracle Corporation
/sys/class/dmi/id/board_version:1.2
grep: /sys/class/dmi/id/power: Is a directory
/sys/class/dmi/id/product_name:VirtualBox
/sys/class/dmi/id/product_serial:0
/sys/class/dmi/id/product_uuid:762A99BF-6916-450F-80A6-B2E9E78FC9A1
/sys/class/dmi/id/product_version:1.2
grep: /sys/class/dmi/id/subsystem: Is a directory
/sys/class/dmi/id/sys_vendor:innotek GmbH
```



Alternatively we can print only product name by using cat command.

```
[VMware]
# cat /sys/class/dmi/id/product_name
VMware Virtual Platform

[Physical Server]
# cat /sys/class/dmi/id/product_name
System x3650 M4: -[7915AC1]-
```



#### Method-11 : Using lspci command

lspci is a utility for displaying information about PCI buses in the system and devices connected to them. By default, it shows a brief list of devices.

```
# lspci | grep "VMware\|VirtualBox"
00:02.0 VGA compatible controller: InnoTek Systemberatung GmbH VirtualBox Graphics Adapter
00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest Service
```



#### Method-12 : Using proc interface

/proc/scsi/scsi display the SCSI devices currently attached (and recognized) by the SCSI subsystem. We can identify the machine type with help of `Vendor` & `Model` name.



**VMware Output**

```
# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: NECVMWar Model: VMware IDE CDR10 Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: VMware   Model: Virtual disk     Rev: 1.0
  Type:   Direct-Access                    ANSI  SCSI revision: 02
```



**VirtualBox Output**

```
# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: VBOX     Model: CD-ROM           Rev: 1.0 
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: VBOX HARDDISK    Rev: 1.0 
  Type:   Direct-Access                    ANSI  SCSI revision: 05
```



**QEMU Output**

```
# cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: QEMU     Model: QEMU HARDDISK    Rev: 2.3.
  Type:   Direct-Access                    ANSI  SCSI revision: 05
```



**Physical Server Output** It’s shows Hard disk vendor name instead of virtual.

```
# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: IBM      Model: ServeRAID M5110e Rev: 3.24
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 02 Id: 01 Lun: 00
  Vendor: IBM      Model: ServeRAID M5110e Rev: 3.24
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM SATA Model:  DEVICE 81Y3672  Rev: SA82
  Type:   CD-ROM                           ANSI  SCSI revision: 05
```



#### Method-13 : Using hwinfo Command

hwinfo is used to probe for the hardware present in the system. It can be used to generate a system overview log which can be later used for support.

```
# hwinfo | grep "Manufacturer"
  <6>[27867.056016] usb 2-1: Manufacturer: VirtualBox
  <6>[31555.965214] usb 2-1: Manufacturer: VirtualBox
  <6>[32123.744633] usb 2-1: Manufacturer: VirtualBox
  <6>[33779.863965] usb 2-1: Manufacturer: VirtualBox
  <6>[34968.587607] usb 2-1: Manufacturer: VirtualBox
  <6>[37364.054145] usb 2-1: Manufacturer: VirtualBox
  <6>[46326.504627] usb 2-1: Manufacturer: VirtualBox
  <6>[54602.872309] usb 2-1: Manufacturer: VirtualBox
    Manufacturer: "innotek GmbH"
    Manufacturer: "Oracle Corporation"
    Manufacturer: "Oracle Corporation"
```



#### Method-14 : Using lscpu Command

lscpu – display information on CPU architecture and gathers CPU architecture information like number of CPUs, threads, cores, sockets, NUMA nodes, information about CPU caches, CPU family, model and prints it in a human-readable format.

```
# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                1
On-line CPU(s) list:   0
Thread(s) per core:    1
Core(s) per socket:    1
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 60
Model name:            Intel Core Processor (Haswell, no TSX)
Stepping:              1
CPU MHz:               2399.996
BogoMIPS:              4799.99
Virtualization:        VT-x
Hypervisor vendor:     KVM
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              4096K
NUMA node0 CPU(s):     0

[Alternatively use lshw command to print only product]
# lscpu | grep Hypervisor
Hypervisor vendor:     KVM
```



#### Method-15 : Using Devices File

With help of block device model we can identify the machine type.

```
[VMware]
# cat /sys/block/sda/device/model
Virtual disk

[VirtualBox]
# cat /sys/block/sda/device/model
VBOX HARDDISK   

[OpenStack]
# cat /sys/block/sda/device/model
QEMU HARDDISK

[Pysical]
# cat /sys/block/sda/device/model
ServeRAID M5110e
```



#### Method-16 : Using inxi Command

inxi is a script that quickly shows system hardware, CPU, drivers, Xorg, Desktop, Kernel, GCC version(s), Processes, RAM usage, and a wide variety of other useful information, also used for forum technical support & debugging tool.

```
$ inxi -b
System:    Host: daygeek Kernel: 4.8.0-32-generic x86_64 (64 bit) Desktop: Unity 7.5.0  Distro: Ubuntu 16.10
Machine:   System: innotek (portable) product: VirtualBox v: 1.2
           Mobo: Oracle model: VirtualBox v: 1.2 BIOS: innotek v: VirtualBox date: 12/01/2006
Battery    BAT0: charge: 31.5 Wh 63.0% condition: 50.0/50.0 Wh (100%)
CPU:       Dual core Intel Core i7-6700HQ (-MCP-) speed: 2591 MHz (max)
Graphics:  Card: InnoTek Systemberatung VirtualBox Graphics Adapter
           Display Server: X.Org 1.18.4 drivers: (unloaded: fbdev,vesa) Resolution: 1920x955@59.89hz
           GLX Renderer: Gallium 0.4 on llvmpipe (LLVM 3.8, 256 bits) GLX Version: 3.0 Mesa 12.0.3
Network:   Card: Intel 82540EM Gigabit Ethernet Controller driver: e1000
Drives:    HDD Total Size: 42.9GB (17.6% used)
Info:      Processes: 197 Uptime: 50 min Memory: 1586.2/1999.8MB Client: Shell (bash) inxi: 2.3.1
```






























```

```

```

```

```

```