// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Valu.h for the primary calling header

#include "Valu__pch.h"

bool Valu___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 2> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___trigger_anySet__ico\n"); );
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
VL_ATTR_COLD void Valu___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 2> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Valu___024root___eval_phase__ico(Valu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_phase__ico\n"); );
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VicoExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__ico
        vlSelfRef.__VicoTriggered[0U] = (QData)((IData)(
                                                        (((((IData)(vlSelfRef.mod) 
                                                            != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__mod__0)) 
                                                           << 3U) 
                                                          | (((IData)(vlSelfRef.funct3) 
                                                              != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__funct3__0)) 
                                                             << 2U)) 
                                                         | (((vlSelfRef.b 
                                                              != vlSelfRef.__Vtrigprevexpr___TOP__b__0) 
                                                             << 1U) 
                                                            | (vlSelfRef.a 
                                                               != vlSelfRef.__Vtrigprevexpr___TOP__a__0)))));
        vlSelfRef.__Vtrigprevexpr___TOP__a__0 = vlSelfRef.a;
        vlSelfRef.__Vtrigprevexpr___TOP__b__0 = vlSelfRef.b;
        vlSelfRef.__Vtrigprevexpr___TOP__funct3__0 
            = vlSelfRef.funct3;
        vlSelfRef.__Vtrigprevexpr___TOP__mod__0 = vlSelfRef.mod;
        if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VicoDidInit)))))) {
            vlSelfRef.__VicoDidInit = 1U;
            vlSelfRef.__VicoTriggered[0U] = (1ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (2ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (4ULL | vlSelfRef.__VicoTriggered[0U]);
            vlSelfRef.__VicoTriggered[0U] = (8ULL | vlSelfRef.__VicoTriggered[0U]);
        }
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Valu___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    __VicoExecute = Valu___024root___trigger_anySet__ico(vlSelfRef.__VicoTriggered);
    if (__VicoExecute) {
        {
            // Inlined CFunc: _eval_ico
            if ((0x000000000000000fULL & vlSelfRef.__VicoTriggered[0U])) {
                {
                    // Inlined CFunc: _ico_comb__TOP__0
                    vlSelfRef.result = ((4U & (IData)(vlSelfRef.funct3))
                                         ? ((2U & (IData)(vlSelfRef.funct3))
                                             ? ((1U 
                                                 & (IData)(vlSelfRef.funct3))
                                                 ? 
                                                (vlSelfRef.a 
                                                 & vlSelfRef.b)
                                                 : 
                                                (vlSelfRef.a 
                                                 | vlSelfRef.b))
                                             : ((1U 
                                                 & (IData)(vlSelfRef.funct3))
                                                 ? 
                                                (vlSelfRef.a 
                                                 >> 
                                                 (0x0000001fU 
                                                  & vlSelfRef.b))
                                                 : 
                                                (vlSelfRef.a 
                                                 ^ vlSelfRef.b)))
                                         : ((2U & (IData)(vlSelfRef.funct3))
                                             ? ((1U 
                                                 & (IData)(vlSelfRef.funct3))
                                                 ? 
                                                (1U 
                                                 & (- (IData)(
                                                              (vlSelfRef.a 
                                                               < vlSelfRef.b))))
                                                 : 
                                                (1U 
                                                 & (- (IData)(
                                                              VL_LTS_III(32, vlSelfRef.a, vlSelfRef.b)))))
                                             : ((1U 
                                                 & (IData)(vlSelfRef.funct3))
                                                 ? 
                                                (vlSelfRef.a 
                                                 << 
                                                 (0x0000001fU 
                                                  & vlSelfRef.b))
                                                 : 
                                                ((IData)(vlSelfRef.mod)
                                                  ? 
                                                 (vlSelfRef.a 
                                                  - vlSelfRef.b)
                                                  : 
                                                 (vlSelfRef.a 
                                                  + vlSelfRef.b)))));
                }
            }
        }
    }
    return (__VicoExecute);
}

void Valu___024root___eval(Valu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval\n"); );
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VicoIterCount;
    // Body
    __VicoIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Valu___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
            VL_FATAL_MT("alu.sv", 4, "", "DIDNOTCONVERGE: Input combinational region did not converge after '--converge-limit' of 10000 tries");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        vlSelfRef.__VicoPhaseResult = Valu___024root___eval_phase__ico(vlSelf);
    } while (vlSelfRef.__VicoPhaseResult);
}

#ifdef VL_DEBUG
void Valu___024root___eval_debug_assertions(Valu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root___eval_debug_assertions\n"); );
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.funct3 & 0xf8U)))) {
        Verilated::overWidthError("funct3");
    }
    if (VL_UNLIKELY(((vlSelfRef.mod & 0xfeU)))) {
        Verilated::overWidthError("mod");
    }
}
#endif  // VL_DEBUG
