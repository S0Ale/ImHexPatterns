#include <mbr>
#include <gpt>
#include <gpt_table>

//example
mbr::MBR protective @ 0;
gpt::GPT header @ 0x200;
gpt_table::TABLE table @ 0x400;

