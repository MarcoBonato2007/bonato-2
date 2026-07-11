// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vhello.h for the primary calling header

#ifndef VERILATED_VHELLO___024ROOT_H_
#define VERILATED_VHELLO___024ROOT_H_  // guard

#include "verilated.h"


class Vhello__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vhello___024root final {
  public:

    // INTERNAL VARIABLES
    Vhello__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vhello___024root(Vhello__Syms* symsp, const char* namep);
    ~Vhello___024root();
    VL_UNCOPYABLE(Vhello___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
