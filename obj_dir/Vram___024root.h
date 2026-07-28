// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vram.h for the primary calling header

#ifndef VERILATED_VRAM___024ROOT_H_
#define VERILATED_VRAM___024ROOT_H_  // guard

#include "verilated.h"


class Vram__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vram___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(address,7,0);
    VL_IN8(write_enable,0,0);
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN(write_data,31,0);
    VL_OUT(ram_out,31,0);
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 256> ram__DOT__memory;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vram__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vram___024root(Vram__Syms* symsp, const char* namep);
    ~Vram___024root();
    VL_UNCOPYABLE(Vram___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
