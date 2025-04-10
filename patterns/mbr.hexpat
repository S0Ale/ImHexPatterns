namespace mbr{
    struct PartitionEntry {
        u8 boot_indicator;
        u8 start_head;
        u8 start_sect;
        u8 start_cylinder;
        u8 partition_type; // sys ID
        u8 end_head;
        u8 end_sect;
        u8 end_cylinder;
        u32 relative_sectors;
        u32 total_sectors;
    };

    struct MBR {
        u8 boot_code[446]; // Boot code
        PartitionEntry partition_table[4]; // Partition table (4 entries)
        u16 signature; // Boot signature (0xAA55)
    };
}
