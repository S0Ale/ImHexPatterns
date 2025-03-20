#include <type/guid.pat>

u8 entries_number in;
// for entries not matching file size

namespace gpt_table{

    struct PartitionEntry{
        type::GUID partition_type_GUID;
        type::GUID unique_partition_GUID;
        le u64 first_lba;
        u64 last_lba;
        u64 partition_attr;
        u16 partition_name[36];
    };

    struct TABLE{
        PartitionEntry entries[entries_number];
    };
}
