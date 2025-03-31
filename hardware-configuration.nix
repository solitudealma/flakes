{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
    kernelModules = [ "kvm-intel" ];
    supportedFilesystems = [ "ntfs" "btrfs" ];
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "30%";
      useTmpfs = false;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8ab9776a-bcd3-47d4-aade-83aa538a4534";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/8ab9776a-bcd3-47d4-aade-83aa538a4534";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/8ab9776a-bcd3-47d4-aade-83aa538a4534";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8FCD-9EEA";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/330ae20d-2d2a-4ca3-a674-91ac587c9cb6"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
