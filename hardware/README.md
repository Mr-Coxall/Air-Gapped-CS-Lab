# Hardware

The servers that were used were 3 x Dell Optiplex 5050s.

Update BIOS to latest version:
  - 1.30 at time

Changes to BIOS:
  - reset to "BIOS Defaults"
  - change "Boot Sequence" to UEFI
  - change "Enable Legacy Option ROMs" to off
  - keep "TMP ON" to true
  - change "Secure Boot Enable" to true
  - change "AC Recovery" to "Power On"
  - ENSURE "Virtualization" is enabled!
  - change "Trusted Execution" to on

# Added Storage

- 2 x 500 Gig SSDs
- 1 x 256 Gig NVME

# Added USB Ethernet

- 1 x USB ethernet -> this is connected to internet, internal nic connected to Air Gapped network
