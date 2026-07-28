// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregfile.h for the primary calling header

#include "Vregfile__pch.h"

void Vregfile___024root___ctor_var_reset(Vregfile___024root* vlSelf);

Vregfile___024root::Vregfile___024root(Vregfile__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vregfile___024root___ctor_var_reset(this);
}

void Vregfile___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vregfile___024root::~Vregfile___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
