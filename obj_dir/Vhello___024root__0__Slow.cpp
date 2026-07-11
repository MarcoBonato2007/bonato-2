// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhello.h for the primary calling header

#include "Vhello__pch.h"

VL_ATTR_COLD void Vhello___024root___eval_static(Vhello___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhello___024root___eval_static\n"); );
    Vhello__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vhello___024root___eval_initial(Vhello___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhello___024root___eval_initial\n"); );
    Vhello__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    {
        // Inlined CFunc: _eval_initial__TOP
        VL_WRITEF_NX("Hello SystemVerilog!\n",0);
        VL_FINISH_MT("hello.sv", 5, "");
    }
}

VL_ATTR_COLD void Vhello___024root___eval_final(Vhello___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhello___024root___eval_final\n"); );
    Vhello__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vhello___024root___eval_settle(Vhello___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhello___024root___eval_settle\n"); );
    Vhello__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
