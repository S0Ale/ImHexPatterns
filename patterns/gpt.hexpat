#include <mbr_def>
#include <gpt_def>
#include <gpt_table>

mbr::MBR protective @ 0;
gpt::GPT header @ 0x200;
gpt_table::TABLE table @ 0x400;
