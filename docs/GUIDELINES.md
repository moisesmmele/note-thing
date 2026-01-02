# Architecture Overview: Note Thing

## High-Level System Design
* **Architecture Pattern:** Service-Oriented (Containerized)
* **Data Flow Strategy:** ETL with Human-in-the-Loop (HITL) Validation
* **State Management:** Centralized Document Store (MongoDB)
* **Inter-Service Signaling:** Webhook-based Push Notifications
* **Primary Trigger:** Cron-based Scheduling (Polled execution)
* **External Integration:** Discord (Notifications), Google Gemini (AI), Joplin (Source)

---

## Service Level Architecture

### 1. Ingestion Pipeline
*This layer decouples the extraction of raw data from the logic of detecting changes, ensuring the external source (Joplin) is never directly blocked by database operations.*

#### **Service A: Ingestion Service**
* **Runtime Model:** Ephemeral Batch Job
* **Activation Strategy:** Scheduled Cron (Every 10 min)
* **Input Context:** Joplin Client CLI & Local File System
* **Output / Side Effect:** Database Upsert (Create/Update)
* **Core Responsibility:** Mirroring, Change Detection (MinHash) & Classification
* **Key Technology:** Python Script & Hashing Algorithms (MD5/MinHash)



---

### 2. Enrichment Layer
*The core logic center where unstructured data is converted into structured knowledge using AI.*

#### **Service C: AI Processor**
* **Runtime Model:** Ephemeral Batch Job
* **Activation Strategy:** Scheduled Cron (Every 1 hr)
* **Input Context:** MongoDB (Status: New/Updated)
* **Output / Side Effect:** Database Update & Webhook Emission
* **Core Responsibility:** AI Tagging, Formatting, & Context Retrieval
* **Key Technology:** Google Gemini API



---

### 3. Presentation & Feedback Layer
*The user-facing component that facilitates the "Review Loop" and handles application state visualization.*

#### **Service D: Interaction Server (UI)**
* **Runtime Model:** Long-lived Daemon
* **Activation Strategy:** HTTP Request & Webhook Listener
* **Input Context:** Database State & User Action
* **Output / Side Effect:** JSON/HTML Response & Database Mutation
* **Core Responsibility:** Visualization & State Finalization (Human-in-the-Loop)
* **Key Technology:** Laravel Framework



---

### 4. Notification & Delivery Layer
*The "Personal Secretary" component responsible for outbound communication and summaries.*

#### **Service E: Debrief Dispatcher**
* **Runtime Model:** Ephemeral Batch Job
* **Activation Strategy:** Scheduled Cron (Daily 07:50 AM)
* **Input Context:** Database (Pending items + Historic Context)
* **Output / Side Effect:** External Notification (Discord)
* **Core Responsibility:** RAG Summarization & Daily Planning
* **Key Technology:** Discord Webhooks