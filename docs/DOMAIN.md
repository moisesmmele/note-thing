# Domain Model: Note Thing

## 1. Core Domain Concept
**Note Thing** is an automated cognitive support system designed to bridge the gap between **Ephemeral Capture** (short-term memory/brain dumps) and **Long-term Knowledge** (structured storage).

The core value proposition is **Cognitive Offloading** via a **Human-in-the-Loop (HITL)** workflow. The system assumes the user has deficits in executive function (organization/review) and enforces a workflow that decouples content creation from content organization.

---

## 2. Ubiquitous Language
*The shared vocabulary used to describe the business logic.*

* **Brain Dump:** The raw, unstructured input created by the user. It is treated as messy and potentially incoherent.
* **Secretary:** The system's persona when actively pushing information to the user. It acts proactively rather than reactively.
* **Review Gate:** The mandatory business step where AI-generated structure must be validated by a human before becoming "Knowledge".
* **Debrief:** A scheduled, context-aware summary delivered to the user to assist with daily planning.
* **MinHash Signature:** A content-agnostic fingerprint used to identify if the *substance* of a note has changed, ignoring whitespace or formatting drifts.

---

## 3. Bounded Contexts

### 3.1. Ingestion Context (The "Senses")
*Responsible for detecting signals from the outside world.*
* **Responsibility:** Mirroring external state (Joplin) and detecting meaningful changes to upsert into the database.
* **Invariants:**
    * A file is only considered "New" or "Updated" if its content hash differs from the stored state.
    * Perfect duplicates are strictly ignored to prevent processing noise.
    * Metadata (frontmatter) in the source file is ignored; only the body content constitutes the "Note".

### 3.2. Enrichment Context (The "Brain")
*Responsible for structuring and connecting information.*
* **Responsibility:** converting raw Markdown into structured entities with tags, summaries, and formatting.
* **Business Rules:**
    * **Automated Taxonomy:** The user does not file notes; the system must apply tags based on semantic analysis.
    * **Context Awareness:** When processing an update, the system must retrieve the previous context of the note to understand the evolution of the idea.

### 3.3. Interaction Context (The "Conscience")
*Responsible for validation and memory reinforcement.*
* **Responsibility:** Presenting the "Review Loop" to the user.
* **Invariants:**
    * **The HITL Rule:** No note can transition to `FINALIZED` status without explicit user approval (`REVIEW_APPROVED`).
    * **Feedback Loop:** User modifications during review trigger a re-processing event (`ITERATION_REVIEW`), not a direct save, ensuring the AI model "learns" or corrects the structure.

---

## 4. Aggregates & Entities

### 4.1. The Note (Aggregate Root)
The primary unit of consistency. It encapsulates the content, metadata, and processing history.

* **Identity:** Defined by a UUID v4.
* **Lifecycle:**
    1.  **Drafting:** Exists only in Joplin.
    2.  **Ingested:** Exists in DB with status `NEW` or `UPDATED`.
    3.  **Enriched:** Status `PENDING_REVIEW` with AI-generated tags/summary.
    4.  **Approved:** Status `REVIEW_APPROVED`, user has validated the structure.
    5.  **Finalized:** Status `FINALIZED`, ready for read-only access.

### 4.2. The Revision (Value Object)
Represents a snapshot of a note at a specific point in time.

* **Immutability:** Once created, a revision cannot be changed.
* **Traceability:** Linked to a parent Note UUID and versioned sequentially.
* **Change Detection:** Uses `min_hash` (array of integers) and `md5` to mathematically prove difference from previous versions.

---

## 5. Domain Services

### 5.1. The Ingestion Service
* **Role:** Ensures the system has an up-to-date view of the user's external editor (Joplin) and persists changes to the database.
* **Frequency:** High (approx. 10 mins) to capture thoughts near real-time.

### 5.2. The Dispatcher (The "Secretary")
* **Role:** Aggregates pending tasks and summaries into a human-readable "Daily Debrief."
* **Schedule:** Fixed domain event at **07:50 AM**.
* **Logic:**
    * Fetches pending reviews.
    * Fetches context (Weekly Summary).
    * Constructs a Discord Embed payload.

---

## 6. Business Logic & Rules Summary
1.  **Separation of Concerns:** The "Capture" interface (Joplin) is distinct from the "Organization" interface (Review UI).
2.  **Proactive Delivery:** The system must not wait for the user to log in; it must push the "Daily Debrief" to an external channel (Discord) to prompt engagement.
3.  **Idempotency:** Re-ingesting the same file multiple times must result in zero side effects unless the `MinHash` changes.
4.  **Immutable History:** Every change to a note creates a new `Revision` entry; history is never overwritten, only appended.