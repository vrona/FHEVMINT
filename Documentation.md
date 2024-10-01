(miscel. sources: [fhevm](https://docs.zama.ai/fhevm/fundamentals),
[fhevm hardhat](https://github.com/zama-ai/fhevm-hardhat-template))

# init

1. in the .env document, this is mandatory.

```
export MNEMONIC="adapt mosquito move limb mobile illegal tree voyage juice mosquito burger raise father hope layer"
export PRIVATE_KEY_GATEWAY_DEPLOYER="717fd99986df414889fd8b51069d4f90a50af72e542c58ee065f5883779099c6"
export PRIVATE_KEY_GATEWAY_OWNER="717fd99986df414889fd8b51069d4f90a50af72e542c58ee065f5883779099c6"
export PRIVATE_KEY_GATEWAY_RELAYER="7ec931411ad75a7c201469a385d6f18a325d4923f9f213bd882bbea87e160b67"
```

2. then `pnpm fhem:start`

3. chainId conflict between Devnet and Local Node, not a problem.

4. FAUCET `docker exec -i zama-dev-fhevm-validator-1 faucet myAddress` instead of `docker exec -i fhevm myAddress`

<br>

# Encryption

- creation of a zero-knowledge proof of all inputs packed into a single ciphertext in a user-defined order. The goal is
  avoid, this prevents the reuse of a ciphertext already stored on the blockchain.
- two types of parameters:
  - einput: is the index of the parameter,
  - bytes: contains the actual ciphertext and zero-knowledge proof.

#### Example: a function with 3 parameters <br>

- **Blockchain (server) side**: <br>

```sol
function myExample(
  address account,
  einput param1,
  uint id,
  einput param2,
  einput param3,
  bool isAllowed,
  bytes calldata inputProof
) {}
```

- **Client side**: <br>

```js
const instance = await createInstance({ networkUrl: "http://localhost:8545" });
const input = instance.createEncryptedInput(contractAddress, userAddress);
const inputs = input.add64(64).addBool(true).add8(4).encrypt(); // Encrypt the three parameters

contract.myExample(
  "0xa5e1defb98EFe38EBb2D958CEe052410247F4c80",
  inputs.handles[0], // param1
  32,
  inputs.handles[1], // param2
  inputs.handles[2], // param3
  true,
  inputs.inputProof,
);
```

- **Validate input**:

A contract can use an encrypted parameter by calling TFHE.asEuintXX(param, proof), TFHE.asEbool or TFHE.asEaddress.<br>
This function will transform the input as a valid encrypted type.

```sol
function transfer(address to, einput encryptedAmount, bytes calldata inputProof) public {
  // Verify the provided encrypted amount
  euint64 amount = TFHE.asEuint64(encryptedAmount, inputProof);
  ...
}
```

# Security Best Practice: isSenderAllowed()

**require(TFHE.isSenderAllowed(encryptedAmount))**

# Decryption

- Gateway.requestDecryption

```sol
function requestDecryption( uint256[] memory ct, bytes4 callbackSelector, uint256 msgValue, uint256 maxTimestamp, bool
passSignaturesToCaller ) returns(uint256 requestID)
```

- callbackSelector is the function selector of the callback function which will be called by the GatewayContract
  contract once the relayer fulfils the decryption request. Notice that the callback function should always follow this
  convention, if passSignaturesToCaller is set to:

  - false:

  ```sol
  function [callbackName](uint256 requestID, XXX x_0, XXX x_1, ..., XXX x_N-1) external onlyGateway if passSignaturesToCaller
  ```

  - true:

  ```sol
    function [callbackName](uint256 requestID, XXX x_0, XXX x_1, ..., XXX x_N-1, bytes[] memory signatures) external
    onlyGateway
  ```

custom callbackName() parameters:

- @requestID: the request id of the decryption (could be commented if not needed in the logic, but must be present) and
  x_0, x_1, ... x_N-1 are the results of the decryption of the ct array.
- @ct: array values, i.e their number should be the size of the ct array.
- @msgValue: the value in native tokens to be sent to the calling contract during fulfilment
- @maxTimestamp is the maximum timestamp after which the callback will not be able to receive the results of decryption,
  i.e the fulfilment transaction will fail in this case. This can be used for time-sensitive applications, where we
  prefer to reject decryption results on too old, out-of-date, values.
- @passSignaturesToCaller determines whether the callback needs to transmit signatures from the KMS or not. This is
  useful if the dApp developer wants to remove trust from the Gateway service and prefers to check the KMS signatures
  directly from within his dApp smart contract.

Sum-Up Decryption

- Request Decryption: The smart contract requests decryption from the GatewayContract.
- GatewayContract: Forwards the request to the Relayer Contract.
- Relayer Contract: Communicates with the KMS to perform the decryption.
- KMS: Decrypts the ciphertext and sends the decrypted data back to the Relayer.
- Callback Function: The relayer calls the specified callback function in the smart contract with the decrypted data,
  where the contract logic (e.g., summing) is performed.

# Access Control List

fhEVM includes an Access Control List (ACL) system that allows you to define which addresses have the right to
manipulate a ciphertext. This feature prevents any address from accessing the contents of any ciphertext.

These ACLs can be adjusted in two ways:

- TFHE.allow(ciphertext, address) Permanently, on the blockchain. This allows a ciphertext to be used by a specific
  address at any time.

- TFHE.allowTransient(ciphertext, address) Temporarily. The ciphertext is then authorized only for the duration of the
  transaction.

Permanent allowance will store the ACL in a dedicated contract, while a temporary allowance will store it in transient
storage, allowing developers to save gas. Transient allowance is particularly useful when calling an external function
using a ciphertext as a parameter.

**ACL for reencryption**:

- If a ciphertext must be reencrypted by a user, then explicit access must be granted to them.
- Due to the reencryption mechanism, a user signs a public key associated with a specific contract; therefore, the
  ciphertext also needs to be allowed for the contract.
