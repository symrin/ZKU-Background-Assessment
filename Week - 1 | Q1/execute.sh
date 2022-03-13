rm public.json
rm verifier.sol
rm verification_key.json
rm witness.wtns

# compile the circuit which will generate three types of files
circom merkleTree.circom --r1cs --wasm --sym --c

cp input.json ./merkleTree_js/input.json
# enter into this directory that will contain wasm code 
cd merkleTree_js

node generate_witness.js merkleTree.wasm input.json witness.wtns
# copy the generated witness to the root directory
cp witness.wtns ../witness.wtns
# return to root directory
cd ..

# Start a new "powers of tau" ceremony
snarkjs powersoftau new bn128 16 pot16_0000.ptau -v

# This contributes to the ceremony
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="First contribution" -v -e="random text"

# The generation of phase 2
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau -v

# To generate a .zkey file that will contain the proving and verification keys together with all phase 2 contributions
snarkjs groth16 setup merkleTree.r1cs pot16_final.ptau merkleTree_0000.zkey

# Contribute to the phase 2 of the ceremony
snarkjs zkey contribute merkleTree_0000.zkey merkleTree_0001.zkey --name="1st Contributor Name" -v -e="random text"

# Export verification key
snarkjs zkey export verificationkey merkleTree_0001.zkey verification_key.json

# Generates a zero knowledge proof using the zkey and witness
# This command generates a Groth16 proof and outputs two files:
# proof.json: will contain the proof.
# public.json: will contain the public input/output values.
snarkjs groth16 prove merkleTree_0001.zkey witness.wtns proof.json public.json

# Verify the proof, if the proof is valid, the command outputs OK.
snarkjs groth16 verify verification_key.json public.json proof.json

# Creates a solidity verifier
snarkjs zkey export solidityverifier merkleTree_0001.zkey verifier.sol

# Generates and prints parameters of thecall
snarkjs generatecall | tee parameters.txt
