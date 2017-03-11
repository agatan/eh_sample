#include "dwarf.hpp"

namespace minc {
    namespace runtime {
        namespace dwarf {

            uint8_t reader::read_u8() {
                return *ptr++;
            }

            uint64_t reader::read_uleb128() {
                unsigned int shift = 0;
                uint64_t result = 0;
                uint8_t byte = 0;
                do {
                    byte = *ptr++;
                    result |= ((uint64_t) (byte & 0x7f)) << shift;
                    shift += 7;
                } while( (byte & 0x80) != 0 );
                return result;
            }

            int64_t reader::read_sleb128() {
                unsigned int shift = 0;
                uint64_t result = 0;
                uint8_t byte = 0;
                do {
                    byte = *ptr++;
                    result |= ((uint64_t) (byte & 0x7f)) << shift;
                    shift += 7;
                } while( (byte & 0x80) != 0 );

                int is_negate = ( byte & 0x40 ) != 0;
                if (is_negate) {
                    result |= ~(1 << shift) + 1;
                }

                return (int64_t)result;
            }
        }
    }
}
