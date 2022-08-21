<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
  <a href="https://github.com/DaniloDughetti">
    <img src="https://gateway.pinata.cloud/ipfs/QmXhXLFCVjRvjVyZQZ8QAixPALjPQJq2StjiKNjrs1pzNt" alt="Logo" width="120" height="120">
  </a>

  <h3 align="center">Ticket NFT Generator</h3>

  <p align="center">
    Ethereum smart contract written in Solidity with HardHat that enables users to mint ticket with different random rarity
    <br />
    <a href="https://github.com/DaniloDughetti/ticket-nfts"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/DaniloDughetti/ticket-nfts/issues">Report Bug</a>
    ·
    <a href="https://github.com/DaniloDughetti/ticket-nftsissues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Ticket NFT Generator want to be a dApp that enables users to mint a ticket NFT.
These tickets have different rarity (commmon, rare, super-rare).

This project is composed in 3 component:
- **TicketNFTGenerator**: Solidity smart contract
- **TicketNFTGenerator-fe** React front end interacting to smart contract
- **IPFS**: NFT Metadata decentalized storage

Features:
- Mint random NFT
- View owned NFTs
- Send NFT to another address
- Governance functions like send balance, pause contract, edit supply, mint price ecc

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

Major frameworks/libraries used to bootstrap project:

- **Solidity** v0.8.7
- **Hardhat** v8.5.0
- **Node** v16.14.2

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Getting Started

### Prerequisites

You need to install Node, npm and hardhat
* node
  ```sh
  apt-get install node@16.14.2 -g
  ```
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

_Below the commands list needed to run project locally_

1. Clone the repo
   ```sh
   git clone https://github.com/DaniloDughetti/ticket-nfts.git
   ```
2. Install NPM packages
   ```sh
   npm install
   ```
3. Register a free node endpoint at [QuickNode](https://www.quicknode.com/) and copy/paste API KEY and PRIVATE KEY
4. Edit environment variables in `.env`
   ```js
    GOERLI_QUICKNODE_API_KEY_URL=<Goerli Quicknode API URL>
    GOERLI_PRIVATE_KEY=<Owner address private key>
    MAINNET_QUICKNODE_API_KEY_URL=<Main net Quicknode API URL>
    MAINNET_PRIVATE_KEY=<Owner address private key>
    URL_COMMON=<IPFS id to ERC721 json>
    URL_RARE=<IPFS id to ERC721 json>
    URL_SUPER_RARE=<IPFS id to ERC721 json>
    UPPER_LIMIT_COMMON = <Upper limit common rarity>
    UPPER_LIMIT_RARE = <Upper limmit rare rarity>
    MAX_SUPPLY=<ERC721 token max supply>
    INITIAL_MINT_PRICE=<Initial price to mint>
    CHAINLINK_SUBSCRIPTION_ID=<Chainlink subscription id>
    CHAINLINK_VRF_COORDINATOR=<Chainlink VRF coordinator Goerli value>
    CHAINLINK_KEY_HASH=<Chainlink key hash Goerli value>
   ```
5. Deploy smart contract on localhost (usefull to read logs and develop your smart contract in relax)
   ```sh
   npx hardhat run scripts/deploy.js
   ```
6. Deploy smart contract on Rinkeby netword (usefull test your smart contract in test net)
   ```sh
   npx hardhat run scripts/deploy.js --network rinkeby
   ```
   Don't be afraid if this error occour one or 10.000 times "it's normal", continue to launch command until you get it deployed:
   ```sh
    ProviderError: loading txs from DB: err: rlp parse transaction: invalid chainID, 1 (expected 4), rlp: f867228459682f0982cd2494c510bb7cbddbce9ebc80f4835b904903ccc6d0e380846fe15b4425a0c4187491964d1f6c3d8b37d0a4341e9256a4f606be021b319a41980ab7e66012a03147d24284af0e90e420bd21cdce03c04e7a082b3bcc67c0a3a4b01926e5370c
    at HttpProvider.request (/Users/danilodughetti/Coding/workspace-blockchain/eth/ticket-nfts/node_modules/hardhat/src/internal/core/providers/http.ts:78:19)
    at LocalAccountsProvider.request (/Users/danilodughetti/Coding/workspace-blockchain/eth/ticket-nfts/node_modules/hardhat/src/internal/core/providers/accounts.ts:182:36)
    at processTicksAndRejections (node:internal/process/task_queues:96:5)
    at EthersProviderWrapper.send (/Users/danilodughetti/Coding/workspace-blockchain/eth/ticket-nfts/node_modules/@nomiclabs/hardhat-ethers/src/internal/ethers-provider-wrapper.ts:13:20)
   ```
7. Create a Chainlink subscription and register deployed smart contract as consumer (for more detail visit this (page)[https://docs.chain.link/docs/vrf/v2/introduction/])
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

Once deployed, you can see your smart contract on Etherscan and interact directly. Otherwise you have to install and deplooy Ticket Nft Generator Front End to interact with smart contract through UI.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Roadmap

- [ ] Add Changelog
- [ ] Add unit tests
- [ ] Add asserts
- [ ] Multi-language Support
    - [ ] Italian
    - [ ] Spanish
    - [ ] German

See the [open issues](https://github.com/DaniloDughetti/ticket-nfts/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Danilo Dughetti - [@danilodughetti](https://twitter.com/danilodughetti) - danilo.dughetti@gmail.com

Project Link - [https://github.com/DaniloDughetti/ticket-nfts](https://github.com/DaniloDughetti/ticket-nfts)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

[contributors-shield]: https://img.shields.io/github/contributors/DaniloDughetti/ticket-nfts.svg?style=for-the-badge
[contributors-url]: https://github.com/DaniloDughetti/ticket-nfts/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/DaniloDughetti/ticket-nftssvg?style=for-the-badge
[forks-url]: https://github.com/DaniloDughetti/ticket-nfts/network/members
[stars-shield]: https://img.shields.io/github/stars/DaniloDughetti/ticket-nfts.svg?style=for-the-badge
[stars-url]: https://github.com/DaniloDughetti/ticket-nfts/stargazers
[issues-shield]: https://img.shields.io/github/issues/DaniloDughetti/ticket-nfts.svg?style=for-the-badge
[issues-url]: https://github.com/DaniloDughetti/ticket-nfts/issues
[license-shield]: https://img.shields.io/github/license/DaniloDughetti/ticket-nfts.svg?style=for-the-badge
[license-url]: https://github.com/DaniloDughetti/ticket-nfts/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/danilodughetti