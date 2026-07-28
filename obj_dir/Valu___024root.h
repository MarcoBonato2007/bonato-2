// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Valu.h for the primary calling header

#ifndef VERILATED_VALU___024ROOT_H_
#define VERILATED_VALU___024ROOT_H_  // guard

#include "verilated.h"


class Valu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Valu___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(funct3,2,0);
    VL_IN8(mod,0,0);
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*2:0*/ __Vtrigprevexpr___TOP__funct3__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__mod__0;
    CData/*0:0*/ __VicoDidInit;
    CData/*0:0*/ __VicoPhaseResult;
    VL_IN(a,31,0);
    VL_IN(b,31,0);
    VL_OUT(result,31,0);
    IData/*31:0*/ __Vtrigprevexpr___TOP__a__0;
    IData/*31:0*/ __Vtrigprevexpr___TOP__b__0;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 2> __VicoTriggered;

    // INTERNAL VARIABLES
    Valu__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Valu___024root(Valu__Syms* symsp, const char* namep);
    ~Valu___024root();
    VL_UNCOPYABLE(Valu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
