pragma circom 2.0.0;
include "mimcsponge.circom";

template MerkleTree(n) {
signal input leaves[n];
signal output merkleRoot;
component mimc[n-1];
var hash[2*n - 1];

for (var i = 0; i < n; i++) {
    hash[i] = leaves[i];
}

for (var i = 0; i < n - 1; i++) {
mimc[i] = MiMCSponge(2, 220, 1);
mimc[i].k <== 0;
mimc[i].ins[0] <== hash[2*i];
mimc[i].ins[1] <== hash[2*i+1];
hash[i+n] = mimc[i].outs[0];
}

merkleRoot<==hash[2*n - 2];
}

component main{public [leaves]} = MerkleTree(8);