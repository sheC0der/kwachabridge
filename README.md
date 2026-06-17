# KwachaBridge
The Problem
In Malawi and many similar African markets, the only way for ordinary people to access Bitcoin or convert local currency to digital assets is through informal agents. These agents operate through personal trust networks. A customer finds an agent through word of mouth, sends them mobile money, and receives Bitcoin in return. There is no price transparency. There is no transaction record. There is no way to compare rates. The agent sets whatever price they want and the customer has no choice but to accept it or find someone else through their personal network.

The result is that Malawians pay up to 150% above market rate just to access Bitcoin. And people who do not know the right person cannot access it at all.
There is also a second problem that compounds the first. Bitcoin settled onchain is slow and expensive. Transaction fees can sometimes cost more than the amount being sent, making it completely impractical for small everyday transactions in low income markets.

These two problems together make Bitcoin effectively inaccessible for the average Malawian.

The Solution
KwachaBridge is a mobile-first tool for mobile money agents that allows them to publish their swap rates publicly, manage incoming customer requests, and settle transactions using the Pontmore protocol on Nostr rails, with every Bitcoin delivery happening via Lightning Network.
By settling via Lightning instead of onchain, users receive Bitcoin instantly for fractions of a cent in fees. By publishing rates publicly through Pontmore, agents compete on price and the premium drops naturally through market competition. Together these two design decisions solve both problems at once. Access and cost.

This turns an informal, trust-based, opaque market into an open, competitive, transparent one. The same agents continue doing what they already do. They just do it with better tools, a public reputation, and access to a wider customer base.

How It Works
There are two sides to the product. The agent side and the customer side.

Agent side
An agent opens the app and creates a Nostr identity, which is just a cryptographic keypair that takes seconds to generate. They set their current swap rate for kwacha to Bitcoin and publish that rate as a Pontmore offer on the Nostr network. When a customer initiates a swap request, the agent sees it in the app, confirms the mobile money payment they receive on their phone, and generates a Lightning invoice for the equivalent Bitcoin amount. That invoice is delivered to the customer through Pontmore. When the customer pays the Lightning invoice, the swap is complete. The agent's transaction history builds over time into a public reputation score that future customers can see.

Customer side
A customer opens the app and sees a list of available agents with their current rates and reputation scores. They select an agent, initiate a swap request through Pontmore, send their kwacha via mobile money on their phone, and receive a Lightning invoice. They pay the invoice and receive their Bitcoin instantly. No onchain fees. No waiting for block confirmations. No needing to know the right person.
Every swap settles via Lightning which means instant delivery and fees so small they are essentially free.

Tech Stack
Frontend: Flutter, Android first, designed for low-end smartphones
Backend: TypeScript with Firebase for real-time data and transaction history
Protocol: Pontmore on Nostr for agent discovery, swap coordination, and swap state
Settlement: Lightning Network for instant, low-fee Bitcoin delivery
Nostr Library: NDK, Nostr Development Kit

Status
This project was built during the bitcoin++ Nairobi 2026 hackathon as a proof of concept. The current demo demonstrates one complete flow. An agent publishes a swap offer via Pontmore, a customer discovers the offer and initiates a swap request, the agent generates a Lightning invoice, and the customer receives it through Pontmore.

Future work includes full reputation scoring, dispute resolution, multi-agent comparison, and real mobile money API integration for Airtel Money and TNM Mpamba.

Why This Matters
This project was built by a Malawian developer who has personally experienced the problem it solves. Being stranded abroad with every Malawian card failing and no way to access money except through an informal dealer charging 150% above market rate is not an edge case. It is the daily reality for Malawians trying to participate in the global digital economy.

KwachaBridge is the missing infrastructure layer. Open, competitive, and built on protocols that nobody controls.

Built At
bitcoin++ Nairobi 2026, Open Source Edition


