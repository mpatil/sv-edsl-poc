# sv-edsl-poc
Proof of concept of embedding a DSL into SystemVerilog

stack build --stack-yaml stack-9.10.yaml BNFC --force-dirty --copy-bins
~/.local/bin/bnfc -m --sv -o src C.cf
