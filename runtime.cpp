#include <unwind.h>
#include <cstdint>
#include <cassert>
#include <iostream>
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

        static unsigned int read_encoded_pointer(dwarf::reader& reader, std::uint8_t encoding) {
            assert(encoding != dwarf::DW_EH_PE_omit);
            unsigned int result;
            switch (encoding & 0x0f) {
            case dwarf::DW_EH_PE_udata4:
                result = *reinterpret_cast<std::uint32_t const*>(reader.ptr);
                reader.ptr += 4;
                break;
            default:
                assert(false && "unreachable unknown encoding");
            }
            return result;
        }

        static eh_action make_eh_action(std::uint8_t const* lsda, std::uintptr_t ip, std::uintptr_t start) {
            std::cerr << "start to make eh action\n";
            if (!lsda) {
                std::cerr << "lsda is null" << std::endl;
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
            if (ttype_encoding != dwarf::DW_EH_PE_omit) {
                reader.read_uleb128();
            }else{
                assert(false && "not supported omit ttype");
            }

            std::uint8_t call_site_encoding = reader.read_u8();
            auto call_site_table_length = reader.read_uleb128();
            auto action_table = reader.ptr + static_cast<int>(call_site_table_length);
            while (reader.ptr < action_table) {
                auto cs_start = read_encoded_pointer(reader, call_site_encoding);
                auto cs_len = read_encoded_pointer(reader, call_site_encoding);
                auto cs_lpad = read_encoded_pointer(reader, call_site_encoding);
                auto cs_action = reader.read_uleb128();
                if (ip < start + cs_start) {
                    break;
                }
                if (ip < start + cs_start < cs_len) {
                    if (cs_lpad == 0) {
                        std::cerr << "cs_lpad = " << cs_lpad << "\n";
                        return { eh_action_type::none, 0 };
                    }
                    auto lpad = static_cast<unsigned int>(lpad_base + cs_lpad);
                    if (cs_action == 0) {
                        std::cerr << "cs_action = " << cs_action << "\n";
                        return { eh_action_type::cleanup, lpad };
                    }
                    return { eh_action_type::catch_, lpad };
                }
            }
            std::cerr << "break\n";
            return { eh_action_type::none, 0 };
        }

        static eh_action find_eh_action(struct _Unwind_Context* context) {
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
            std::cerr << "personality called" << std::endl;
            auto eh_act = find_eh_action(context);
            std::cerr << static_cast<int>(eh_act.type) << " : " << eh_act.pad << '\n';
            if (actions & _UA_SEARCH_PHASE) {
                switch (eh_act.type) {
                case eh_action_type::none:
                case eh_action_type::cleanup:
                    return _URC_CONTINUE_UNWIND;
                case eh_action_type::catch_:
                    return _URC_HANDLER_FOUND;
                case eh_action_type::terminate:
                    return _URC_FATAL_PHASE1_ERROR;
                }
            } else {
                switch (eh_act.type) {
                case eh_action_type::none:
                    return _URC_CONTINUE_UNWIND;
                case eh_action_type::cleanup:
                case eh_action_type::catch_:
                    _Unwind_SetGR(context, 0, reinterpret_cast<uintptr_t>(exception_object));
                    _Unwind_SetGR(context, 1, 0);
                    _Unwind_SetIP(context, eh_act.pad);
                    return _URC_INSTALL_CONTEXT;
                case eh_action_type::terminate:
                    return _URC_FATAL_PHASE2_ERROR;
                }
            }
            return _URC_FATAL_PHASE2_ERROR;
        }

        struct exception_object {
            _Unwind_Exception unwind_info;
            int value;
        };
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

    void my_free(void* ptr) {
        free(ptr);
    }

    static void cleanup(_Unwind_Reason_Code _code, _Unwind_Exception* exception) {
        my_free(exception);
    }

    void my_throw_exception(int value) {
        auto exn = static_cast<minc::runtime::exception_object*>(my_alloc_exception(sizeof(minc::runtime::exception_object)));
        exn->unwind_info.exception_class = 0x4d4f519952555354;
        exn->unwind_info.exception_cleanup = cleanup;
        exn->value = value;
        auto ret = _Unwind_RaiseException(&exn->unwind_info);
        if (ret == _URC_END_OF_STACK) {
            std::cerr << "uncaught exception with value " << value << std::endl;
        } else if (ret == _URC_FATAL_PHASE1_ERROR) {
            std::cerr << "fatal error in phase 1 with value " << value << std::endl;
        } else if (ret == _URC_FATAL_PHASE2_ERROR) {
            std::cerr << "fatal error in phase 2 with value " << value << std::endl;
        } else {
            std::cout << "_Unwind_RaiseException failed with " << ret << std::endl;
        }
        abort();
    }

    uint64_t test_type_0 = 0;
    uint64_t test_type_1 = 1;
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
