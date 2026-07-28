// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vpc.h for the primary calling header

#include "Vpc__pch.h"

void Vpc___024root___ctor_var_reset(Vpc___024root* vlSelf);

Vpc___024root::Vpc___024root(Vpc__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vpc___024root___ctor_var_reset(this);
}

void Vpc___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vpc___024root::~Vpc___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
