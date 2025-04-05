#include <fat_def>

bool isVFat in;
u32 entriesCount in;

FAT16::FAT_BootSector bootSect @ 0;

u64 rootDirStart = (bootSect.ReservedSectors + (bootSect.FATCount * bootSect.SectorsPerFAT16)) * bootSect.BytesPerSector;
u64 dataAreaStart = rootDirStart + (bootSect.RootEntryCount * bootSect.BytesPerSector);
FAT16::FAT_DirectoryEntry entries[entriesCount] @ dataAreaStart;