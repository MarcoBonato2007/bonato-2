// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vram__pch.h"

//============================================================
// Constructors

Vram::Vram(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vram__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , address{vlSymsp->TOP.address}
    , write_enable{vlSymsp->TOP.write_enable}
    , write_data{vlSymsp->TOP.write_data}
    , ram_out{vlSymsp->TOP.ram_out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vram::Vram(const char* _vcname__)
    : Vram(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vram::~Vram() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vram___024root___eval_debug_assertions(Vram___024root* vlSelf);
#endif  // VL_DEBUG
void Vram___024root___eval_static(Vram___024root* vlSelf);
void Vram___024root___eval_initial(Vram___024root* vlSelf);
void Vram___024root___eval_settle(Vram___024root* vlSelf);
void Vram___024root___eval(Vram___024root* vlSelf);

void Vram::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vram::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vram___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vram___024root___eval_static(&(vlSymsp->TOP));
        Vram___024root___eval_initial(&(vlSymsp->TOP));
        Vram___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vram___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vram::eventsPending() { return false; }

uint64_t Vram::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vram::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vram___024root___eval_final(Vram___024root* vlSelf);

VL_ATTR_COLD void Vram::final() {
    contextp()->executingFinal(true);
    Vram___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vram::hierName() const { return vlSymsp->name(); }
const char* Vram::modelName() const { return "Vram"; }
unsigned Vram::threads() const { return 1; }
void Vram::prepareClone() const { contextp()->prepareClone(); }
void Vram::atClone() const {
    contextp()->threadPoolpOnClone();
}
