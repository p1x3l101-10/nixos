{ eLib, ... }:

eLib.confTemplates.diskoBtrfs {
  disk-id = "nvme-WD_BLACK_SN7100_1TB_255144806416";
  esp-size = "1G";
  swap-size = "50G";
  useLuks = true;
}
