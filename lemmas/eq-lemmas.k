requires "evm.md"
requires "foundry.md"

module EQ-LEMMAS
    imports BOOL
    imports FOUNDRY
    imports INFINITE-GAS
    imports INT-SYMBOLIC

    rule bool2Word ( X ) => 1 requires X         [simplification]
    rule bool2Word ( X ) => 0 requires notBool X [simplification]

endmodule
