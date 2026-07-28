// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile.h for the primary calling header

#include "Vregfile__pch.h"

bool Vregfile___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 2> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___trigger_anySet__ico\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((2U > n));
    return (0U);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 2> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vregfile___024root___eval_phase__ico(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_phase__ico\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VicoExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__ico
        vlSelfRef.__VicoTriggered[0U] = (QData)((IData)(
                                                        ((((vlSelfRef.write_data 
                                                            != vlSelfRef.__Vtrigprevexpr___TOP__write_data__0) 
                                                           << 5U) 
                                                          | (((IData)(vlSelfRef.write_enable) 
                                                              != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__write_enable__0)) 
                                                             << 4U)) 
                                                         | (((((IData)(vlSelfRef.write_select) 
                                                               != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__write_select__0)) 
                                                              << 3U) 
                                                             | (((IData)(vlSelfRef.reg2_select) 
                                                                 != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__reg2_select__0)) 
                                                                << 2U)) 
                                                            | ((((IData)(vlSelfRef.reg1_select) 
                                                                 != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__reg1_select__0)) 
                                                                << 1U) 
                                                               | ((IData)(vlSelfRef.clk) 
                                                                  != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0)))))));
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
        if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VicoDidInit)))))) {
            vlSelfRef.__VicoDidInit = 1U;
            vlSelfRef.__VicoTriggered[0U] = (1ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (2ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (4ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (8ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (0x0000000000000010ULL 
                                             | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (0x0000000000000020ULL 
                                             | vlSelfRef.__VicoTriggered[0U]);
        }
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vregfile___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    __VicoExecute = Vregfile___024root___trigger_anySet__ico(vlSelfRef.__VicoTriggered);
    if (__VicoExecute) {
        {
            // Inlined CFunc: _eval_ico
            if ((2ULL & vlSelfRef.__VicoTriggered[0U])) {
                {
                    // Inlined CFunc: _ico_sequent__TOP__0
                    vlSelfRef.reg1_out = (vlSelfRef.regfile__DOT__registers
                                          [vlSelfRef.reg1_select] 
                                          & (- (IData)(
                                                       (0U 
                                                        != (IData)(vlSelfRef.reg1_select)))));
                }
            }
            if ((4ULL & vlSelfRef.__VicoTriggered[0U])) {
                {
                    // Inlined CFunc: _ico_sequent__TOP__1
                    vlSelfRef.reg2_out = (vlSelfRef.regfile__DOT__registers
                                          [vlSelfRef.reg2_select] 
                                          & (- (IData)(
                                                       (0U 
                                                        != (IData)(vlSelfRef.reg2_select)))));
                }
            }
        }
    }
    return (__VicoExecute);
}

bool Vregfile___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___trigger_anySet__act\n"); );
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

void Vregfile___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregfile___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vregfile___024root___eval_phase__act(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_phase__act\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                        ((IData)(vlSelfRef.clk) 
                                                         & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__1)))));
        vlSelfRef.__Vtrigprevexpr___TOP__clk__1 = vlSelfRef.clk;
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vregfile___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vregfile___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vregfile___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vregfile___024root___eval_phase__nba(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_phase__nba\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vregfile___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Inlined CFunc: _eval_nba
            if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
                {
                    // Inlined CFunc: _nba_sequent__TOP__0
                    IData/*31:0*/ __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyVal__regfile__DOT__registers__v0;
                    __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyVal__regfile__DOT__registers__v0 = 0;
                    CData/*4:0*/ __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyDim0__regfile__DOT__registers__v0;
                    __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyDim0__regfile__DOT__registers__v0 = 0;
                    CData/*0:0*/ __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlySet__regfile__DOT__registers__v0;
                    __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlySet__regfile__DOT__registers__v0 = 0;
                    __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlySet__regfile__DOT__registers__v0 = 0U;
                    if (((IData)(vlSelfRef.write_enable) 
                         & (0U != (IData)(vlSelfRef.write_select)))) {
                        __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyVal__regfile__DOT__registers__v0 
                            = vlSelfRef.write_data;
                        __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyDim0__regfile__DOT__registers__v0 
                            = vlSelfRef.write_select;
                        __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlySet__regfile__DOT__registers__v0 = 1U;
                    }
                    if (__Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlySet__regfile__DOT__registers__v0) {
                        vlSelfRef.regfile__DOT__registers[__Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyDim0__regfile__DOT__registers__v0] 
                            = __Vinline_0__eval_nba___Vinline_0__nba_sequent__TOP__0___VdlyVal__regfile__DOT__registers__v0;
                    }
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
        Vregfile___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vregfile___024root___eval(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VicoIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vregfile___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
            VL_FATAL_MT("regfile.sv", 2, "", "DIDNOTCONVERGE: Input combinational region did not converge after '--converge-limit' of 10000 tries");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        vlSelfRef.__VicoPhaseResult = Vregfile___024root___eval_phase__ico(vlSelf);
    } while (vlSelfRef.__VicoPhaseResult);
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vregfile___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("regfile.sv", 2, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vregfile___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("regfile.sv", 2, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vregfile___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vregfile___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vregfile___024root___eval_debug_assertions(Vregfile___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregfile___024root___eval_debug_assertions\n"); );
    Vregfile__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.reg1_select & 0xe0U)))) {
        Verilated::overWidthError("reg1_select");
    }
    if (VL_UNLIKELY(((vlSelfRef.reg2_select & 0xe0U)))) {
        Verilated::overWidthError("reg2_select");
    }
    if (VL_UNLIKELY(((vlSelfRef.write_select & 0xe0U)))) {
        Verilated::overWidthError("write_select");
    }
    if (VL_UNLIKELY(((vlSelfRef.write_enable & 0xfeU)))) {
        Verilated::overWidthError("write_enable");
    }
}
#endif  // VL_DEBUG
