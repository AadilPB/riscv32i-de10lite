ENTRY(_begin)
SECTIONS
{
    . = 0x00000000;
    .text : { *(.text)}
    _end_of_text = .;

    ASSERT(_end_of_text <= 0x00001000, "Error: program size is larger than instruction memory size.")
}
