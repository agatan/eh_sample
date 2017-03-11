#include <unwind.h>
#include <cstdint>
#include <cassert>
#include "dwarf.hpp"

namespace minc {
    namespace runtime {

        enum class eh_action_type {
            none,
            cleanup,
            catch_,
            terminate
        };

        struct eh_action {
            eh_action_type type;
            unsigned int pad;
        };

        eh_action make_eh_action(std::uint8_t const* lsda, std::uintptr_t ip, std::uintptr_t start) {
            if (!lsda) {
                eh_action ret = { eh_action_type::none, 0 };
                return ret;
            }
            auto reader = dwarf::reader{lsda};
            std::uint8_t start_encoding = reader.read_u8();
            std::uintptr_t lpad_base;
            if (start_encoding != dwarf::DW_EH_PE_omit) {
                assert(0 && "not supported");
            } else {
                lpad_base = start;
            }
            std::uint8_t ttype_encoding = reader.read_u8();
            if (ttype_encoding == dwarf::DW_EH_PE_omit) {
                assert(0 && "not supported");
            } else {
            }
            return {};
        }

        eh_action find_eh_action(struct _Unwind_Context* context) {
            const std::uint8_t* lsda = (const std::uint8_t*) _Unwind_GetLanguageSpecificData(context);
            int ip_before_instr = 0;
            std::uintptr_t ip = _Unwind_GetIPInfo(context, &ip_before_instr);
            if (ip_before_instr == 0) {
                ip--;
            }
            std::uintptr_t start = _Unwind_GetRegionStart(context);
            return make_eh_action(lsda, ip, start);
        }

        _Unwind_Reason_Code my_personality(
                int version,
                _Unwind_Action actions,
                std::uint64_t exception_class,
                struct _Unwind_Exception* exception_object,
                struct _Unwind_Context* context) {
            if (version != 1) {
                return _URC_FATAL_PHASE1_ERROR;
            }
            if (actions & _UA_SEARCH_PHASE) {
            } else {
            }
            return _URC_FATAL_PHASE2_ERROR;
        }
    }
}

extern "C" {
    _Unwind_Reason_Code my_personality(
            int version,
            _Unwind_Action actions,
            std::uint64_t exception_class,
            struct _Unwind_Exception* exception_object,
            struct _Unwind_Context* context) {
        return minc::runtime::my_personality(version, actions, exception_class, exception_object, context);
    }

    void* my_alloc_exception(size_t size) {
        return malloc(size);
    }
}

// # :nodoc:
// fun __crystal_personality(version : Int32, actions : LibUnwind::Action, exception_class : std::uint64, exception_object : LibUnwind::Exception*, context : Void*) : LibUnwind::ReasonCode
//   start = LibUnwind.get_region_start(context)
//   ip = LibUnwind.get_ip(context)
//   throw_offset = ip - 1 - start
//   lsd = LibUnwind.get_language_specific_data(context)
//   #puts "Personality - actions : #{actions}, start: #{start}, ip: #{ip}, throw_offset: #{throw_offset}"
//
//   leb = LEBReader.new(lsd)
//   leb.read_std::uint8               # @LPStart encoding
//   if leb.read_std::uint8 != 0xff_u8 # @TType encoding
//     leb.read_uleb128           # @TType base offset
//   end
//   leb.read_std::uint8                     # CS Encoding
//   cs_table_length = leb.read_uleb128 # CS table length
//   cs_table_end = leb.data + cs_table_length
//
//   while leb.data < cs_table_end
//     cs_offset = leb.read_std::uint32
//     cs_length = leb.read_std::uint32
//     cs_addr = leb.read_std::uint32
//     action = leb.read_uleb128
//     #puts "cs_offset: #{cs_offset}, cs_length: #{cs_length}, cs_addr: #{cs_addr}, action: #{action}"
//
//     if cs_addr != 0
//       if cs_offset <= throw_offset && throw_offset <= cs_offset + cs_length
//         if actions.includes? LibUnwind::Action::SEARCH_PHASE
//           #puts "found"
//           return LibUnwind::ReasonCode::HANDLER_FOUND
//         end
//
//         if actions.includes? LibUnwind::Action::HANDLER_FRAME
//           LibUnwind.set_gr(context, LibUnwind::EH_REGISTER_0, exception_object.address)
//           LibUnwind.set_gr(context, LibUnwind::EH_REGISTER_1, exception_object.value.exception_type_id)
//           LibUnwind.set_ip(context, start + cs_addr)
//           #puts "install"
//           return LibUnwind::ReasonCode::INSTALL_CONTEXT
//         end
//       end
//     end
//   end
//
//   #puts "continue"
//   return LibUnwind::ReasonCode::CONTINUE_UNWIND
// end
