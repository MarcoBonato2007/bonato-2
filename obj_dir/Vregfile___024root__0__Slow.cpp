// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile.h for the primary calling header

#include "Vregfile__pch.h"

VL_ATTR_COLD void Vregfile___024root___eval_static(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_static\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__reg1_select__0 
        = vlSelfRef.reg1_select;
    vlSelfRef.__Vtrigprevexpr___TOP__reg2_select__0 
        = vlSelfRef.reg2_select;
    vlSelfRef.__Vtrigprevexpr___TOP__write_select__0 
        = vlSelfRef.write_select;
    vlSelfRef.__Vtrigprevexpr___TOP__write_enable__0 
        = vlSelfRef.write_enable;
    vlSelfRef.__Vtrigprevexpr___TOP__write_data__0 
        = vlSelfRef.write_data;
    vlSelfRef.__Vtrigprevexpr___TOP__clk__1 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vregfile___024root___eval_initial(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_initial\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vregfile___024root___eval_final(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_final\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vregfile___024root___eval_phase__stl(Vregfile___024root* vlSelf);

VL_ATTR_COLD void Vregfile___024root___eval_settle(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_settle\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vregfile___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("regfile.sv", 2, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vregfile___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD bool Vregfile___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vregfile___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vregfile___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___trigger_anySet__stl\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

VL_ATTR_COLD bool Vregfile___024root___eval_phase__stl(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_phase__stl\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__stl
        vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                          & vlSelfRef.__VstlTriggered[0U]) 
                                         | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vregfile___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vregfile___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        {
            // Inlined CFunc: _eval_stl
            if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
                {
                    // Inlined CFunc: _stl_sequent__TOP__0
                    vlSelfRef.reg1_out = (vlSelfRef.regfile__DOT__registers
                                          [vlSelfRef.reg1_select] 
                                          & (- (IData)(
                                                       (0U 
                                                        != (IData)(vlSelfRef.reg1_select)))));
                    vlSelfRef.reg2_out = (vlSelfRef.regfile__DOT__registers
                                          [vlSelfRef.reg2_select] 
                                          & (- (IData)(
                                                       (0U 
                                                        != (IData)(vlSelfRef.reg2_select)))));
                }
            }
        }
    }
    return (__VstlExecute);
}

bool Vregfile___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 2> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 2> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(Vregfile___024root___trigger_anySet__ico(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @( clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @( reg1_select)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @( reg2_select)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 3U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 3 is active: @( write_select)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 4U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 4 is active: @( write_enable)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 5U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 5 is active: @( write_data)\n");
    }
    if ((1U & (IData)(triggers[1U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 64 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

bool Vregfile___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vregfile___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vregfile___024root___ctor_var_reset(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___ctor_var_reset\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->reg1_select = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 1050450708220727354ull);
    vlSelf->reg2_select = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 2187838796403550269ull);
    vlSelf->write_select = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 4017750927478801720ull);
    vlSelf->write_enable = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3448544431963303041ull);
    vlSelf->write_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11298066925140600626ull);
    vlSelf->reg1_out = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 168717809132577151ull);
    vlSelf->reg2_out = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16902412014466398849ull);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->regfile__DOT__registers[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15714543938832699633ull);
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__VicoTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__reg1_select__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__reg2_select__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__write_select__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__write_enable__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__write_data__0 = 0;
    vlSelf->__VicoDidInit = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__1 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
}
