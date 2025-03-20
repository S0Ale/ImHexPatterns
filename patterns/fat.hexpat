#include <fat_def>

bool isVFat in;

FAT16::FAT_BootSector bootSect @ 0;

u64 bootSectorEndAddr = addressof(bootSect) + sizeof(bootSect) + sizeof(u16);
u64 dataAreaStartAddr = bootSectorEndAddr + bootSect.ReservedSectors * bootSect.BytesPerSector + bootSect.FATCount * bootSect.SectorsPerFAT16 * bootSect.BytesPerSector;

// This is wrong fix it
if (isVFat) {
    FAT16::VFAT_LFNEntry entries[] @ dataAreaStartAddr;
} else {
    FAT16::FAT_DirectoryEntry entries[] @ dataAreaStartAddr;
}

