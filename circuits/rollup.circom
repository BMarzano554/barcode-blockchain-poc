# Barcode + Bitcoin Sidechain PoC  
A blockchain prototype for barcode integration with Bitcoin, using ZK-Rollups.  

## Setup  
1. Install Python and Node.js.  
2. Run `pip install -r requirements.txt`.  
3. Compile ZK circuits:  
   ```bash  
   cd circuits && circom rollup.circom --r1cs --wasm --sym  
---

#### **File 2: `circuits/rollup.circom`**  
**Code**:  
```circom
pragma circom 2.1.0;
file 2
template Main() {
    signal input initialStateHash;
    signal input txBatchHash;
    signal input finalStateHash;

    component hasher = Poseidon(2);
    hasher.inputs[0] <== initialStateHash;
    hasher.inputs[1] <== txBatchHash;
    finalStateHash === hasher.out;
}

component main = Main();
file 3import hashlib

class Block:
    def __init__(self, transactions, prev_hash):
        self.transactions = transactions
        self.prev_hash = prev_hash
        self.zk_proof = None

    def hash(self):
        return hashlib.sha256(str(self.transactions).encode()).hexdigest()
file 4 from block import Block

class SidechainNode:
    def __init__(self):
        self.chain = [self.create_genesis_block()]
        self.pending_transactions = []

    def create_genesis_block(self):
        return Block(transactions=[], prev_hash="0")

    def add_transaction(self, sender, receiver, amount):
        self.pending_transactions.append({
            "sender": sender,
            "receiver": receiver,
            "amount": amount
        })

    def mine_block(self, zk_proof):
        new_block = Block(
            transactions=self.pending_transactions,
            prev_hash=self.chain[-1].hash()
        )
        new_block.zk_proof = zk_proof
        self.chain.append(new_block)
        self.pending_transactions = []
file5 class Bridge:
    def __init__(self):
        self.locked_btc = 0
        self.wrapped_btc = 0

    def lock_btc(self, amount):
        self.locked_btc += amount
        self.wrapped_btc += amount

    def unlock_btc(self, amount, zk_proof):
        if self.verify_proof(zk_proof):
            self.locked_btc -= amount
            self.wrapped_btc -= amount

    def verify_proof(self, proof):
        return True
file 6  pytest==7.4.0
