requires "evm.md"
requires "foundry.md"

module KECCAK-LEMMAS
    imports BOOL
    imports FOUNDRY
    imports INFINITE-GAS
    imports INT-SYMBOLIC
    imports MAP-SYMBOLIC
    syntax StepSort ::= Int
                      | Bool
                      | Bytes
                      | Set
 // -------------------------
    syntax KItem ::= runLemma ( StepSort )
                   | doneLemma( StepSort )
    rule <k> runLemma(T) => doneLemma(T) ... </k>
 // ---------------------------------------------
    syntax Bool ::= #notEq ( KItem, KItem )  [function, no-evaluators]
 // ----------------------------------------------------------------------------------------------------

  //
  // keccak assumptions: these assumptions are not sound in principle, but are
  // required for verification - they should be collected at the end of execution
  //
  // ########################
  // Keccak
  // ########################

    //Required for #Ceil(#buf)
    rule 0 <=Int keccak( _ )             => true [simplification]
    rule         keccak( _ ) <Int pow256 => true [simplification]

    // keccak does not equal a concrete value
    rule [keccak-eq-conc-false]: keccak(_A)  ==Int _B => false [symbolic(_A), concrete(_B), simplification]
    rule [keccak-neq-conc-true]: keccak(_A) =/=Int _B => true  [symbolic(_A), concrete(_B), simplification]

    // corollary of `keccak-eq-conc-false`
    rule [keccak-eq-conc-false-extended]:
      ( ( keccak ( _X ) +Int _A ) modInt pow256 ) ==Int _Y => false
      [simplification, symbolic(_X), concrete(_A, _Y)]

    // keccak is injective
    rule [keccak-inj]: keccak(A) ==Int keccak(B) => A ==K B [simplification]

    // keccak has no "fixpoint"
    rule [keccak-no-fix-eq-false]: #buf(32, keccak(X))  ==K X => false [simplification]
    rule [keccak-no-fix-neq-true]: #buf(32, keccak(X)) =/=K X => true  [simplification]

    // disequality of keccak under shifting
    rule ( ( keccak ( _X ) +Int A ) modInt pow256 ) ==Int keccak ( _Y ) => false
      requires 0 <Int A andBool A <Int pow256
      [simplification, symbolic(_X, _Y), concrete(A)]

    // lookup simplification lemma 
    rule M:Map [ KEY <- #lookup(M, KEY) ] => M [simplification]

endmodule
