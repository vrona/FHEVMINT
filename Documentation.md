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
