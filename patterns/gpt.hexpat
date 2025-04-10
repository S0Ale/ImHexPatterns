#include <type/guid.pat>
u32 table_entries in;

namespace gpt{
    struct PartitionEntry{
        type::GUID partition_type_GUID;
        type::GUID unique_part_GUID;
        u64 first_lba;
        u64 last_lba;
        u64 partition_attr;
        char16 partition_name[36];
    };

    struct GPT{
        u64 signature;
        u32 version;
        le u32 gpt_header_size;
        u32 crc32_checksum_header;
        u32 reserved; // must be zero
        u64 lba_current_header_struct;
        u64 lba_backup_header_struct;
        u64 lba_start_partition;
        u64 lba_end_partition;
        type::GUID disk_guid;
        u64 lba_start_partition_table;
        u32 table_entries_number;
        u32 entry_size;
        u32 crc32_checksum_table;
        char reserved_end_sector[420];
    };

    struct TABLE{
        PartitionEntry entries[table_entries];
    };
}
