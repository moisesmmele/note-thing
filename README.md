# Note Thing

> **Note:** This project is currently a **Work In Progress (WIP)**.

**Note Thing** is an AI-assisted note processing middleware designed to bridge the gap between rapid, unstructured "brain dumps" and organized, actionable knowledge. It leverages Large Language Models (LLMs) to automatically restructure, tag, and summarize notes, preventing the "write-and-forget" cycle often associated with ADHD and information overload.

## core Philosophy

- **Decoupled Capture & Organization:** Capture thoughts freely in **Joplin** (or any Markdown editor) without worrying about structure.
- **Human-in-the-Loop (HITL):** A mandatory review step where users approve AI-generated structures, ensuring quality and reinforcing memory.
- **Proactive Assistant:** The system pushes daily summaries and debriefs to **Discord**, rather than waiting for you to search.

## Architecture Overview

The system follows a service-oriented, containerized architecture.

- **Ingestion:** Monitors file changes from Joplin (Markdown). Uses MinHash for deduplication and change detection.
- **AI Processing:** Google Gemini (API & CLI) handles content restructuring, tagging, and context retrieval.
- **Storage:** **MongoDB Community Edition** serves as the central document store and vector database.
- **User Interface:** A lightweight Interaction Server (Laravel) facilitates the review loop and knowledge visualization.
- **Notifications:** Outbound daily debriefs are sent via Discord Webhooks.
