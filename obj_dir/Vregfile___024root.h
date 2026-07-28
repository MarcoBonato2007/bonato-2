// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vregfile.h for the primary calling header

#ifndef VERILATED_VREGFILE___024ROOT_H_
#define VERILATED_VREGFILE___024ROOT_H_  // guard

#include "verilated.h"


class Vregfile__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vregfile___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reg1_select,4,0);
    VL_IN8(reg2_select,4,0);
    VL_IN8(write_select,4,0);
    VL_IN8(write_enable,0,0);
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*4:0*/ __Vtrigprevexpr___TOP__reg1_select__0;
    CData/*4:0*/ __Vtrigprevexpr___TOP__reg2_select__0;
    CData/*4:0*/ __Vtrigprevexpr___TOP__write_select__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__write_enable__0;
    CData/*0:0*/ __VicoDidInit;
    CData/*0:0*/ __VicoPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__1;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN(write_data,31,0);
    VL_OUT(reg1_out,31,0);
    VL_OUT(reg2_out,31,0);
    IData/*31:0*/ __Vtrigprevexpr___TOP__write_data__0;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 32> regfile__DOT__registers;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 2> __VicoTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vregfile__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vregfile___024root(Vregfile__Syms* symsp, const char* namep);
    ~Vregfile___024root();
    VL_UNCOPYABLE(Vregfile___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
