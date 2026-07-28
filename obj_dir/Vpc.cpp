// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vpc__pch.h"

//============================================================
// Constructors

Vpc::Vpc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vpc__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , nextpc{vlSymsp->TOP.nextpc}
    , currentpc{vlSymsp->TOP.currentpc}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vpc::Vpc(const char* _vcname__)
    : Vpc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vpc::~Vpc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vpc___024root___eval_debug_assertions(Vpc___024root* vlSelf);
#endif  // VL_DEBUG
void Vpc___024root___eval_static(Vpc___024root* vlSelf);
void Vpc___024root___eval_initial(Vpc___024root* vlSelf);
void Vpc___024root___eval_settle(Vpc___024root* vlSelf);
void Vpc___024root___eval(Vpc___024root* vlSelf);

void Vpc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vpc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vpc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vpc___024root___eval_static(&(vlSymsp->TOP));
        Vpc___024root___eval_initial(&(vlSymsp->TOP));
        Vpc___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vpc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vpc::eventsPending() { return false; }

uint64_t Vpc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vpc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vpc___024root___eval_final(Vpc___024root* vlSelf);

VL_ATTR_COLD void Vpc::final() {
    contextp()->executingFinal(true);
    Vpc___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vpc::hierName() const { return vlSymsp->name(); }
const char* Vpc::modelName() const { return "Vpc"; }
unsigned Vpc::threads() const { return 1; }
void Vpc::prepareClone() const { contextp()->prepareClone(); }
void Vpc::atClone() const {
    contextp()->threadPoolpOnClone();
}
