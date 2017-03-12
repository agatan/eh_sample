#include <unwind.h>
#include <cstdint>
#include <cassert>
#include <iostream>
#include "dwarf.hpp"

namespace minc {
    namespace runtime {
        struct exception_object {
            _Unwind_Exception unwind_info;
            int value;
        };

        _Unwind_Reason_Code my_personality(
                int version,
                _Unwind_Action actions,
                std::uint64_t exception_class,
                struct _Unwind_Exception* exception_object,
                struct _Unwind_Context* context) {
            std::cerr << "personality called" << std::endl;
            if (version != 1) {
                return _URC_FATAL_PHASE1_ERROR;
            }
            auto start = _Unwind_GetRegionStart(context);
            auto ip = _Unwind_GetIP(context);
            auto throw_offset = ip - 1 - start;
            const std::uint8_t* lsd = (const std::uint8_t*) _Unwind_GetLanguageSpecificData(context);
            auto leb = dwarf::reader{lsd};
            leb.read_u8();
            if (leb.read_u8() != 0xff) {
                leb.read_uleb128();
            }
            leb.read_u8();
            auto cs_table_length = leb.read_uleb128();
            auto cs_table_end = leb.ptr + cs_table_length;

            while (leb.ptr < cs_table_end) {
                auto cs_offset = leb.read_u32();
                auto cs_length = leb.read_u32();
                auto cs_addr = leb.read_u32();
                auto action = leb.read_uleb128();

                if (cs_addr != 0) {
                    if (cs_offset <= throw_offset && throw_offset <= cs_offset + cs_length) {
                        if (actions & _UA_SEARCH_PHASE) {
                            std::cerr << "found!\n";
                            return _URC_HANDLER_FOUND;
                        }

                        if (actions & _UA_HANDLER_FRAME) {
                            _Unwind_SetGR(context, 0, reinterpret_cast<uintptr_t>(exception_object));
                            auto exn = reinterpret_cast<struct exception_object const*>(exception_object);
                            _Unwind_SetGR(context, 1, exn->value);
                            _Unwind_SetIP(context, start + cs_addr);
                            std::cerr << "install\n";
                            return _URC_INSTALL_CONTEXT;
                        }
                    }
                }
            }
            return _URC_CONTINUE_UNWIND;
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

    int select_exception_index() {
        int res;
        std::cin >> res;
        return res;
    }
}

