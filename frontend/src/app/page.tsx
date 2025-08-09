import Image from "next/image";

export default function Home() {
  return (
    <div className="grid grid-rows-[1fr_auto] items-center justify-items-center min-h-screen p-8 font-[family-name:var(--font-geist-sans)] bg-background">
      <main className="flex flex-col gap-10 items-center">
        <h1 className="text-4xl font-bold mb-2 text-center">AXE</h1>
        <p className="text-lg sm:text-xl text-center max-w-xl font-[family-name:var(--font-geist-mono)]">
          One Universal ID for all your Web3 wallet Address .
        </p>
        <div className="py-8">
          <span className="bg-yellow-200 text-yellow-800 px-4 py-2 rounded-full text-xl font-semibold shadow-lg">
            Coming Soon
          </span>
        </div>
        <p className="text-sm text-gray-500 text-center max-w-md">
          Send and receive anything from any chain — using just one ID.
        </p>
        <section className="mt-6 border border-dashed border-gray-300 rounded-lg p-4 w-full max-w-2xl bg-white/70 dark:bg-black/30">
          <h2 className="text-center text-xl font-semibold mb-3">
            How it works
          </h2>
          <ol className="list-decimal list-inside text-left text-base text-gray-700 dark:text-gray-200 space-y-2 max-w-prose mx-auto">
            <li>
              <span className="font-semibold">Get your unique AxeGate ID:</span>{" "}
              Sign up and 0xAXE assigns you a universal ID that connects all
              your blockchain wallets.
            </li>
            <li>
              <span className="font-semibold">Share your ID:</span> Receive
              crypto from any chain by sharing this single ID—no need for
              multiple wallet addresses.
            </li>
            <li>
              <span className="font-semibold">Universal routing:</span> The
              AxeGate engine automatically detects the asset and blockchain,
              delivering assets to the correct destination wallet.
            </li>
            <li>
              <span className="font-semibold">Send assets easily:</span> Enter a
              recipient’s AxeGate ID or address to send tokens; AxeGate manages
              all cross-chain transfers.
            </li>
          </ol>
          <p className="text-center mt-4 text-sm text-gray-500">
            Organization: <span className="font-semibold">0xAXE</span>
          </p>
        </section>
      </main>
      <footer className="w-full flex justify-center items-center gap-4 py-6 border-t dark:border-white/[.08] text-xs text-gray-500">
        <span>© {new Date().getFullYear()} 0xAXE</span>
        <a
          href="https://github.com/0xAXE/axe/actions/workflows/contract.yml"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            src="https://github.com/0xAXE/axe/actions/workflows/contract.yml/badge.svg"
            alt="Build Status"
            width={80}
            height={20}
          />
        </a>
        <a
          href="https://github.com/0xAXE/axe/actions/workflows/backend.yml"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            src="https://github.com/0xAXE/axe/actions/workflows/backend.yml/badge.svg"
            alt="Nest Status"
            width={80}
            height={20}
          />
        </a>
        <a
          href="https://opensource.org/licenses/MIT"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            src="https://img.shields.io/badge/License-MIT-yellow.svg"
            alt="MIT License"
            width={80}
            height={20}
          />
        </a>
      </footer>
    </div>
  );
}
