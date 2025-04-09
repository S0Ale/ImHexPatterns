#include <fat_def>

FAT16::FAT_BootSector bootSect @ 0;

u64 rootDirStart = (bootSect.ReservedSectors + (bootSect.FATCount * bootSect.SectorsPerFAT16)) * bootSect.BytesPerSector;
FAT16::FAT_DirectoryEntry root_entries[bootSect.RootEntryCount] @ rootDirStart;
