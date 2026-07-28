// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vram.h for the primary calling header

#include "Vram__pch.h"

VL_ATTR_COLD void Vram___024root___eval_static(Vram___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___eval_static\n"); );
    Vram__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vram___024root___eval_initial(Vram___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___eval_initial\n"); );
    Vram__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vram___024root___eval_final(Vram___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___eval_final\n"); );
    Vram__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vram___024root___eval_settle(Vram___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___eval_settle\n"); );
    Vram__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

bool Vram___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vram___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vram___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vram___024root___ctor_var_reset(Vram___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram___024root___ctor_var_reset\n"); );
    Vram__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->address = VL_SCOPED_RAND_RESET_I(8, __VscopeHash, 12021632533271657083ull);
    vlSelf->write_enable = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3448544431963303041ull);
    vlSelf->write_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11298066925140600626ull);
    vlSelf->ram_out = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 13120828470432034117ull);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->ram__DOT__memory[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 2207897171895220173ull);
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
}
