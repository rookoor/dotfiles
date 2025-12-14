#!/usr/bin/env python3
"""
Browser-Use CLI wrapper for Claude-assisted browsing.

Usage:
    python browse.py "Search for the best mechanical keyboard under $200"
    python browse.py "Find today's top HN stories"
"""

import asyncio
import os
import sys
from pathlib import Path

# Load environment
from dotenv import load_dotenv
env_file = Path.home() / ".browser-use.env"
if env_file.exists():
    load_dotenv(env_file)

from browser_use import Agent, Browser
from langchain_anthropic import ChatAnthropic


async def run_task(task: str):
    """Run a browser task with Claude."""

    # Initialize browser
    browser = Browser()

    # Initialize Claude (uses ANTHROPIC_API_KEY from env)
    llm = ChatAnthropic(
        model="claude-sonnet-4-20250514",
        temperature=0,
    )

    # Create agent
    agent = Agent(
        task=task,
        llm=llm,
        browser=browser,
    )

    # Run and return result
    print(f"\nTask: {task}\n")
    print("Working...\n")

    result = await agent.run()

    print("\n--- Result ---")
    if result:
        # Print final result
        for item in result:
            if hasattr(item, 'extracted_content') and item.extracted_content:
                print(item.extracted_content)

    await browser.close()
    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: python browse.py \"your task here\"")
        print("\nExamples:")
        print('  python browse.py "Find the weather in San Francisco"')
        print('  python browse.py "Search GitHub for Python CLI tools"')
        sys.exit(1)

    task = " ".join(sys.argv[1:])

    # Check for API key
    if not os.getenv("ANTHROPIC_API_KEY"):
        print("Error: ANTHROPIC_API_KEY not set")
        print("Add it to ~/.browser-use.env")
        sys.exit(1)

    asyncio.run(run_task(task))


if __name__ == "__main__":
    main()
