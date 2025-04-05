// hexpat pattern for NTFS File System "Partition Boot Sector"
#include <utils.hexpat>

namespace ntfs{

    struct BiosParamBlock{
        u16 bytes_per_sect;
        u8 sect_per_cluster [[comment("Positive: # of clusters; negative: 2^-n")]];
        u16 reserved [[comment("Must be 0")]];
        u8 unused[5] [[hidden, comment("Always 0")]];
        u8 media_desc [[format_read("format_u8"), comment("0xF8 if hard disk")]];
        u16 unused2 [[hidden, comment("Always 0")]];
        u16 sect_per_track [[format_read("format_u16")]];
        u16 head_number;
        u32 hidden_sect;
        u32 unused3 [[hidden]];
    };

    struct ExtBiosParamBlock{
        u32 unused4 [[hidden]];
        u64 tot_sect;
        u64 mft_cluster_num [[comment("Cluster containing MFT")]];
        u64 mft_backup_num;
        u8 mft_entry_size [[format_read("format_u8"), comment("Positive: # of clusters; negative (-10): 2^10 bytes")]];
        u24 unused5 [[hidden]];
        u8 index_record_size [[format_read("format_u8"), comment("Positive: # of clusters; negative: amount of bytes, same as mft entry size")]];
        u24 unused6 [[hidden]];
        u64 volume_serial [[comment("random partition number")]];
        u32 checksum [[comment("unused")]];
    };

    struct PBS{
        be u24 jump [[format_read("format_u24"), name("Jump instruction")]];
        char oem_name[8] [[single_color]];

        BiosParamBlock bpb [[name("Bios parameter block")]];
        ExtBiosParamBlock ebpb [[name("Extended BPB")]];
        u8 bootstrap_code[426] [[single_color, comment("Loading the rest of OS")]];
        u16 end_of_sect [[format_read("format_u16"), comment("must be 0xAA55")]];
    };
}
