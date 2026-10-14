#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

// Collects a runtime trace of IR instruction uses (User <- Operand).
// For every use of an instruction as an operand, a call to the runtime
// useLogger function is inserted before the user instruction.
// Users that are phi instructions are skipped.
struct LogUsesPass : public PassInfoMixin<LogUsesPass> {
  FunctionCallee Logger;

  bool isLogger(Value *V) {
    if (auto *F = dyn_cast<Function>(V))
      return F->getName() == "useLogger";
    return false;
  }

  void addUseLog(IRBuilder<> &builder, Instruction *user, Value *operand) {
    auto *def = dyn_cast<Instruction>(operand);
    if (!def)
      return; // constants, arguments and globals are not IR instructions
    Value *userName = builder.CreateGlobalStringPtr(user->getOpcodeName());
    Value *operandName = builder.CreateGlobalStringPtr(def->getOpcodeName());
    builder.CreateCall(Logger, {userName, operandName});
  }

  bool instrumentFunction(Module &M, Function &F, IRBuilder<> &builder,
                          unsigned &useCount) {
    if (F.isDeclaration() || F.getName() == "useLogger")
      return false;

    unsigned count = 0;
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (isa<PHINode>(&I))
          continue; // skip users that are phi instructions
        builder.SetInsertPoint(&I);
        // Insert in reverse order so that at runtime the records appear
        // in the natural operand order (op0, op1, ..., opN).
        for (unsigned i = I.getNumOperands(); i > 0; --i) {
          Value *operand = I.getOperand(i - 1);
          if (isLogger(operand))
            continue;
          addUseLog(builder, &I, operand);
          ++count;
        }
      }
    }
    useCount += count;
    return count > 0;
  }

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    IRBuilder<> builder(M.getContext());
    FunctionType *logType = FunctionType::get(
        Type::getVoidTy(M.getContext()),
        {PointerType::getUnqual(M.getContext()),
         PointerType::getUnqual(M.getContext())},
        false);
    Logger = M.getOrInsertFunction("useLogger", logType);

    unsigned functions = 0;
    unsigned uses = 0;
    for (auto &F : M) {
      if (instrumentFunction(M, F, builder, uses)) {
        ++functions;
        errs() << "[PASS] instrumented function '" << F.getName() << "'\n";
      }
    }
    errs() << "[PASS] instrumented " << functions << " functions, " << uses
           << " use sites\n";
    return PreservedAnalyses::none();
  }
};

} // namespace

static void registerCallbacks(PassBuilder &PB) {
  // Run at the end of the optimization pipeline so the instrumentation
  // reflects the final -O2 IR (with phi instructions created by mem2reg).
  PB.registerOptimizerLastEPCallback(
      [](ModulePassManager &MPM, OptimizationLevel) {
        MPM.addPass(LogUsesPass{});
        return true;
      });
}

PassPluginLibraryInfo getPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "LogUsesPass", "0.0.1",
          registerCallbacks};
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}