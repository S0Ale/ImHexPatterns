#include <fat_def>

FAT16::FAT_BootSector bootSect @ 0;

u64 bootSectorEndAddr = addressof(bootSect) + sizeof(bootSect) + sizeof(u16);
u64 dataAreaStartAddr = bootSectorEndAddr + bootSect.ReservedSectors * bootSect.BytesPerSector + bootSect.FATCount * bootSect.SectorsPerFAT16 * bootSect.BytesPerSector;
FAT16::FAT_DirectoryEntry entries[] @ dataAreaStartAddr;
