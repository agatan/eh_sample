#ifndef DWARF_HPP
#define DWARF_HPP

#include <cstdint>

namespace minc {
    namespace runtime {
        namespace dwarf {

            constexpr std::uint8_t const  DW_EH_PE_absptr     = 0x00;

            constexpr std::uint8_t const  DW_EH_PE_omit       = 0xff;
            constexpr std::uint8_t const  DW_EH_PE_uleb128    = 0x01;
            constexpr std::uint8_t const  DW_EH_PE_udata2     = 0x02;
            constexpr std::uint8_t const  DW_EH_PE_udata4     = 0x03;
            constexpr std::uint8_t const  DW_EH_PE_udata8     = 0x04;
            constexpr std::uint8_t const  DW_EH_PE_sleb128    = 0x09;
            constexpr std::uint8_t const  DW_EH_PE_sdata2     = 0x0a;
            constexpr std::uint8_t const  DW_EH_PE_sdata4     = 0x0b;
            constexpr std::uint8_t const  DW_EH_PE_sdata8     = 0x0c;
            constexpr std::uint8_t const  DW_EH_PE_signed     = 0x09;

            constexpr std::uint8_t const  DW_EH_PE_pcrel      = 0x10;
            constexpr std::uint8_t const  DW_EH_PE_textrel    = 0x20;
            constexpr std::uint8_t const  DW_EH_PE_datarel    = 0x30;
            constexpr std::uint8_t const  DW_EH_PE_funcrel    = 0x40;
            constexpr std::uint8_t const  DW_EH_PE_aligned    = 0x50;

            constexpr std::uint8_t const  DW_EH_PE_indirect   = 0x80;

            struct reader {
                std::uint8_t const* ptr;

                uint8_t read_u8();
                uint32_t read_u32();
                uint64_t read_uleb128();
                int64_t read_sleb128();
            };
        }
    }
}

#endif // DWARF_HPP
