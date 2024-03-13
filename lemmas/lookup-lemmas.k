requires "evm.md"
requires "foundry.md"

module LOOKUP-LEMMAS
    imports BOOL
    imports FOUNDRY
    imports INFINITE-GAS
    imports INT-SYMBOLIC
    imports MAP-SYMBOLIC

    rule M:Map [ KEY <- #lookup(M, KEY) ] => M [simplification]
endmodule