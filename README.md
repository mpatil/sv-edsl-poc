# sv-edsl-poc
Proof of concept of embedding a DSL into SystemVerilog.

## Requirements
1. fusesoc
1. [stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/) -- install using `curl -sSL https://get.haskellstack.org/ | sh` 
1. eda simulator -- only questa is tested right now.

if EDSL_ROOT is where you have checked out this repository, then

```
git submodule update --init --recursive
(cd $EDSL_ROOT/bnfc && stack build --stack-yaml stack-9.10.yaml BNFC --force-dirty --copy-bins)
~/.local/bin/bnfc -m --sv -l -o src C.cf
setenv LEXPATH $EDSL_ROOT/sv-lex/src
setenv YACCPATH $EDSL_ROOT/sv-yacc/src
make -C src
```
