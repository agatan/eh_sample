#ifndef DWARF_H
#define DWARF_H

#include <stdint.h>

#define  DW_EH_PE_absptr     0x00;

#define  DW_EH_PE_omit       0xff;
#define  DW_EH_PE_uleb128    0x01;
#define  DW_EH_PE_udata2     0x02;
#define  DW_EH_PE_udata4     0x03;
#define  DW_EH_PE_udata8     0x04;
#define  DW_EH_PE_sleb128    0x09;
#define  DW_EH_PE_sdata2     0x0a;
#define  DW_EH_PE_sdata4     0x0b;
#define  DW_EH_PE_sdata8     0x0c;
#define  DW_EH_PE_signed     0x09;

#define  DW_EH_PE_pcrel      0x10;
#define  DW_EH_PE_textrel    0x20;
#define  DW_EH_PE_datarel    0x30;
#define  DW_EH_PE_funcrel    0x40;
#define  DW_EH_PE_aligned    0x50;

#define  DW_EH_PE_indirect   0x80;

uint64_t read_uleb128(const uint8_t* ptr);
int64_t read_sleb128(const uint8_t* ptr);

#endif // DWARF_H
