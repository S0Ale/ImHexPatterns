#include <utils.hexpat>
import type.time;

s64 attributeCount in; // Negative if you want to search patterns until the end of the sequence (type 0xffffffff)
u8 entriesCount in;

s64 count = attributeCount; // attribute counter (if positive)

namespace ntfs{

    struct BiosParamBlock{
        u16 bytes_per_sect;
        u8 sect_per_cluster [[format_read("negative_size"), comment("Positive: # of clusters; negative: 2^-n")]];
        u16 reserved [[comment("Must be 0")]];
        u8 unused[5] [[hidden, comment("Always 0")]];
        u8 media_desc [[format_read("hex"), comment("0xF8 if hard disk")]];
        u16 unused2 [[hidden, comment("Always 0")]];
        u16 sect_per_track [[format_read("decimal_hex")]];
        u16 head_number;
        u32 hidden_sect;
        u32 unused3 [[hidden]];
    };

    struct ExtBiosParamBlock{ // TODO: format to handle negative values for cluster sizes
        u32 unused4 [[hidden]];
        u64 tot_sect;
        u64 mft_cluster_num [[comment("Cluster containing MFT")]];
        u64 mft_backup_num;
        u8 mft_entry_size [[format_read("negative_size"), comment("Positive: # of clusters; negative: 2^n bytes")]];
        u24 unused5 [[hidden]];
        u8 index_record_size [[format_read("negative_size"), comment("Positive: # of clusters; negative: amount of bytes, same as mft entry size")]];
        u24 unused6 [[hidden]];
        u64 volume_serial [[comment("random partition number")]];
        u32 checksum [[comment("unused")]];
    };

    struct PBS{
        be u24 jump [[format_read("hex"), name("Jump instruction")]];
        char oem_name[8] [[single_color]];

        BiosParamBlock bpb [[name("Bios parameter block")]];
        ExtBiosParamBlock ebpb [[name("Extended BPB")]];
        u8 bootstrap_code[426] [[single_color, comment("Loading the rest of OS")]];
        u16 end_of_sect [[format_read("hex"), comment("must be 0xAA55")]];
    };

    struct EntryHeader{
        u64 start = $;

        u32 file_magic [[comment("Magic number 'FILE'")]];
        if(file_magic != 0x454c4946) break; 
        u16 update_seq_offset [[comment("Offset in bytes into the MFT table if the fixup array")]];
        u16 update_seq_size [[comment("Number of entries")]];
        u64 seq_number [[comment("Number of LogFile entry tracking updates")]];
        u16 seq_no;
        u16 hard_link_count;
        u16 first_attr_offset [[comment("Offset in bytes of the first attribute")]];
        u16 flags [[format_read("decimal_hex")]];
        u32 used_record_size;
        u32 alloc_record_size [[comment("Allocated entry size")]];
        u64 base_file_ref [[comment("Reference of the first file record describing this file")]];
        u16 next_attr_id;
        u8 unused[2] [[hidden]];
        u32 mft_record_no;
    };

    enum FormCode: u8{
        RESIDENT = 0x0,
        NONRESIDENT = 0x1
    };

    struct AttrHeader{
        if(attributeCount > 0 && count >= attributeCount) break; // if positive, i need to keep track of parsed attributes
        count += 1;

        u64 start = $; //sart offset of header

        u32 type_id [[format_read("hex")]];
        u32 attr_length;
        if(type_id == 0xffffffff) break; // end of entry attributes

        FormCode form_code [[comment("0: resident; 1: not-resident")]];
        u8 name_len;
        u16 name_offset;
        u16 flags [[format_read("decimal_hex")]];
        u16 attr_id;
        u32 content_len;
        u16 content_offset;
        u8 unused[2] [[hidden]];
        
        // End offset to calculate size
        u64 end = $;
        u64 sizeOf = end - start;
    };

    u64 attrLength;
    u64 headerSize;
    struct FileName{
        u64 start = $;

        u64 ref_parent_dir;
        type::FILETIME creation_time;
        type::FILETIME modif_time;
        type::FILETIME mtf_modif_time;
        type::FILETIME access_time;
        u64 alloc_size;
        u64 real_size;
        u32 flags;
        u32 reparse_val;
        u8 name_len;
        u8 namespace_field;
        char16 name[name_len];

        u64 size = $ - start;
        u8 other[attrLength - (size + headerSize)] [[hidden]];
    };

    struct Attribute{
        AttrHeader header;
        
        // need to use them if content does not reach 
        // the full size of the attribute
        attrLength = 0;
        headerSize = 0;
        if(header.type_id == 0x30) {
            attrLength = header.attr_length;
            headerSize = header.sizeOf;
        }

        match(header.type_id){
            (0x30): FileName content [[single_color]];
            (_): u8 content[header.attr_length - header.sizeOf] [[hidden]];
        }
    };

    struct MFTEntry{
        count = 0;
        EntryHeader header;
        $ = (addressof(this)+header.first_attr_offset); 
        Attribute attributes[while(true)];
        // subtract used vs full size
        u8 other[(header.alloc_record_size - header.used_record_size)] [[hidden]];
    };

    struct MFTTable{
        MFTEntry entries[entriesCount];
    };

}
