// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vpc.h for the primary calling header

#ifndef VERILATED_VPC___024ROOT_H_
#define VERILATED_VPC___024ROOT_H_  // guard

#include "verilated.h"


class Vpc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vpc___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN(nextpc,31,0);
    VL_OUT(currentpc,31,0);
    IData/*31:0*/ pc__DOT__pc_reg;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vpc__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vpc___024root(Vpc__Syms* symsp, const char* namep);
    ~Vpc___024root();
    VL_UNCOPYABLE(Vpc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
