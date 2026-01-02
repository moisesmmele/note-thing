# Project Design Document: Note Thing

## 1. Executive Summary
**Note Thing** is an AI-assisted note processing application designed to reduce the friction associated with note-taking, review, summarization, and information delivery. Acting as an intelligent middleware between raw data entry and long-term knowledge management, the application leverages Large Language Models (LLMs) to transform unstructured "brain dumps" into organized, actionable insights.

## 2. Problem Statement
This project addresses specific cognitive challenges related to ADHD (Attention Deficit Hyperactivity Disorder) and deficits in episodic memory.

* **The Organization Bottle-neck:** Neurodivergent brains often struggle to organize thoughts *during* the capture phase. Traditional apps force users to categorize immediately, creating friction.
* **The "Write-and-Forget" Cycle:** Users often generate large volumes of unstructured notes but lack the executive function to review them. This leads to an overwhelming backlog of information that is rarely accessed again.
* **Fragmentation:** Current solutions often require maintaining multiple environments or manual synchronization, lacking a unified, open-source, multi-platform ecosystem.

## 3. The Solution
**Note Thing** solves these issues by decoupling "capture" from "organization." It employs a Zettelkasten-inspired system powered by AI, but significantly, it enforces a **Human-in-the-Loop (HITL)** workflow.

By requiring the user to manually review and approve AI-generated structures, the system creates a "review loop." This interaction serves two purposes:
1.  **Quality Control:** Ensures the AI models are processing data correctly.
2.  **Cognitive Reinforcement:** The act of reviewing the note creates a second exposure to the information, strengthening the memory of the concept.

## 4. Core Capabilities

### 4.1. Structuring the Unstructured
Users can capture raw, stream-of-consciousness "dumps" without worrying about flow or formatting. The system automatically restructures these inputs into coherent, formatted notes.

### 4.2. Automated Taxonomy
The application removes the burden of manual filing. It automatically analyzes content to apply relevant tags and categories, grouping related notes logically.

### 4.3. Review-Driven Engagement
The system enforces a time delay between note creation and note processing. This "distancing" promotes re-engagement, helping the user fixate the idea in their memory while validating the system's output.

### 4.4. Proactive Assistance
Rather than requiring the user to search for information, the app proactively pushes information. It delivers daily briefings, summaries, and reminders via external channels (e.g., Discord, Email) to assist with daily planning.

## 5. Technical Architecture & MVP Constraints

### 5.1. Ingestion Strategy (Headless Processing)
To minimize complexity, the MVP will not include a native text editor.
* **Source:** The system ingests Markdown files. Currently, this leverages **Joplin** (an open-source, multi-platform editor) syncing to the service container directly.
* **Flexibility:** This file-based approach is platform-agnostic. The underlying text editor can easily be swapped for Obsidian or any other Markdown-based tool in the future.

### 5.2. AI Integration
* **Engine:** The system utilizes the Google Gemini ecosystem.

### 5.3. Database & State Management
* **Database:** **MongoDB Community Edition**.
    * *Rationale:* Chosen for its schema-less flexibility (avoiding rigid SQL migrations) and (as of recently) native support for Vector Search.
* **Data Integrity:**
    * **Immutability:** Notes are treated as immutable upon ingestion.
    * **Change Tracking:** The system uses **MinHash** for content-agnostic hashing. If a source file is modified, the AI re-processes the note. If the source is deleted, the processed version is removed.

### 5.4. Infrastructure & Communication
* **Scheduling:** **Cronjobs** handle strict periodic tasks (like ingestion polling and daily debriefs), while the core processing loop is **Event-Driven**.
* **IPC:** Inter-process communication uses **Redis Streams** to update long-living processes.
* **Notifications (v1):** Output is strictly via **Discord Webhooks**. Future versions may support Email or Telegram through abstraction layers.

## 6. Frontend Interface
The frontend is strictly for visualization and the feedback loop, not for content creation.

### 6.1. The Review Interface (Feedback Loop)
A streamlined UI designed for rapid processing:
* **Left Panel:** Original raw note (with context if applicable).
* **Right Panel:** The AI-restructured version.
* **Controls:** Three distinct actions—*Accept*, *Modify*, or *Skip*.

### 6.2. The Dashboard
A centralized view for knowledge retrieval:
* **Navigation:** Top-level filtering, search bar, and tag cloud.
* **Content:** A clickable list of processed notes displaying titles, metadata, and AI-generated summaries.