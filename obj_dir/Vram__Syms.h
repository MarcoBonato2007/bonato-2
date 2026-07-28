// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VRAM__SYMS_H_
#define VERILATED_VRAM__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vram.h"

// INCLUDE MODULE CLASSES
#include "Vram___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vram__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vram* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vram___024root                 TOP;

    // CONSTRUCTORS
    Vram__Syms(VerilatedContext* contextp, const char* namep, Vram* modelp);
    ~Vram__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
