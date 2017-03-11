#include <unwind.h>

enum eh_action_type {
	none,
	cleanup,
	catch,
	terminate
};

typedef struct _eh_action {
	enum eh_action_type type;
	unsigned int pad;
} eh_action;

eh_action make_eh_action(uintptr_t lsda, uintptr_t ip, uintptr_t start) {
	if (!lsda) {
		eh_action ret = { none, 0 };
		return ret;
	}
}

eh_action find_eh_action(struct _Unwind_Context* context) {
	uintptr_t lsda = _Unwind_GetLanguageSpecificData(context);
	int ip_before_instr = 0;
	uintptr_t ip = _Unwind_GetIPInfo(context, &ip_before_instr);
	if (ip_before_instr == 0) {
		ip--;
	}
	uintptr_t start = _Unwind_GetRegionStart(context);
	return make_eh_action(lsda, ip, start);
}

_Unwind_Reason_Code my_personality(
		int version,
		_Unwind_Action actions,
		uint64_t exception_class,
		struct _Unwind_Exception* exception_object,
		struct _Unwind_Context* context) {
	if (version != 1) {
		return _URC_FATAL_PHASE1_ERROR;
	}
	if (actions & _UA_SEARCH_PHASE) {
	} else {
	}
	return 0;
}

  // # :nodoc:
  // fun __crystal_personality(version : Int32, actions : LibUnwind::Action, exception_class : UInt64, exception_object : LibUnwind::Exception*, context : Void*) : LibUnwind::ReasonCode
  //   start = LibUnwind.get_region_start(context)
  //   ip = LibUnwind.get_ip(context)
  //   throw_offset = ip - 1 - start
  //   lsd = LibUnwind.get_language_specific_data(context)
  //   #puts "Personality - actions : #{actions}, start: #{start}, ip: #{ip}, throw_offset: #{throw_offset}"
		//
  //   leb = LEBReader.new(lsd)
  //   leb.read_uint8               # @LPStart encoding
  //   if leb.read_uint8 != 0xff_u8 # @TType encoding
  //     leb.read_uleb128           # @TType base offset
  //   end
  //   leb.read_uint8                     # CS Encoding
  //   cs_table_length = leb.read_uleb128 # CS table length
  //   cs_table_end = leb.data + cs_table_length
		//
  //   while leb.data < cs_table_end
  //     cs_offset = leb.read_uint32
  //     cs_length = leb.read_uint32
  //     cs_addr = leb.read_uint32
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
