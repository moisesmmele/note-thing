# Data Contracts: Note Thing

## 1. File System Input Interface (Source)
*The input interface for the **Ingestion Service**.*

* **Format:** Plain Text (Markdown)
* **Directory Structure:** Flat
* **Naming Convention:** Ignored

**Expectation:**
The `Ingestion Service` expects valid UTF-8 text files. It does not parse frontmatter metadata from the source; it treats the entire file content as the "body" for hashing purposes.

---

## 2. Shared State Schema (MongoDB)
*The central data model accessed by all services.
This document represents the single source of truth and is shared across all services.

```json
{
// Notes Collection Schema
"$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Note",
  "type": "object",
  "properties": {
    "uuid": {
      "type": "string",
      "format": "uuid-v4"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    },
    "status": {
      "type": "string",
      "enum": ["NEW", "UPDATED", "PENDING_REVIEW", "ITERATION_REVIEW", "REVIEW_APPROVED", "FINALIZED"]
    },
    "contents": {
      "type": "object",
      "additionalProperties": true,
      "description": "Nested object structure for the note content"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "title": {
      "type": "string"
    },
    "summary": {
      "type": "string"
    },
    "current_version": {
      "type": "integer",
      "minimum": 1
    },
  },
  "required": ["uuid", "created_at", "status"]
}


{
  // Revisions Collection Schema
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Revision",
  "type": "object",
  "properties": {
    "parent_uuid": {
      "type": "string",
      "format": "uuid-v4",
      "description": "Foreign key linking to the Note UUID"
    },
    "version": {
      "type": "integer",
      "minimum": 1
    },
    "content": {
      "type": "string"
    },
    "change_reason": {
      "type": "object",
      "additionalProperties": true,
      "description": "Nested object structure for the note content"
    },
    "md5": {
      "type": "string"
    },
    "min_hash": {
      "type": "array",
      "items": {
        "type": "integer"
      }
    },
  },
  "required": ["parent_uuid", "version", "content", "md5", "min_hash"]
}
```

---

## 3. Internal Eventing (Redis Streams)
*The contract for inter-service signaling (Processors $\rightarrow$ UI).*

**Stream Key:** `note_events`

### Event: Review Ready
**Trigger:** **AI Processor** finishes tagging/formatting.
**Consumer:** **Interaction Server**.
**Payload (XADD key-values):**
* `event`: `REVIEW_READY`
* `note_uuid`: `<uuid-v4>`

### Event: Note Finalized
**Trigger:** **Interaction Server** processes user approval.
**Consumer:** **Debrief Dispatcher** (or other subscribers).
**Payload (XADD key-values):**
* `event`: `NOTE_FINALIZED`
* `note_uuid`: `<uuid-v4>`

---

## 4. External Output (Discord)
*The contract for the **Daily Debrief** sent to the user.*

**Trigger:** **Debrief Dispatcher** (Scheduled 07:50 AM).
**Target:** Discord Webhook API.

```json
{
  // Reference only, actual payload has to match Discord webhook payload schema
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Generated Notification Schema",
  "description": "Schema validation for Note Thing Secretary embed messages",
  "type": "object",
  "properties": {
    "username": {
      "type": "string",
      "description": "The display name of the bot or sender",
      "example": "Note Thing Secretary"
    },
    "embeds": {
      "type": "array",
      "description": "List of embedded rich content",
      "items": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "example": "Daily Debrief ☀️"
          },
          "description": {
            "type": "string",
            "example": "Here is your summary for the day."
          },
          "fields": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "name": {
                  "type": "string",
                  "title": "Field Title"
                },
                "value": {
                  "type": "string",
                  "title": "Field Content"
                },
                "inline": {
                  "type": "boolean",
                  "default": false,
                  "description": "Whether to display this field in the same line as the previous one"
                }
              },
              "required": [
                "name",
                "value"
              ]
            }
          },
          "footer": {
            "type": "object",
            "properties": {
              "text": {
                "type": "string"
              }
            },
            "required": [
              "text"
            ]
          }
        },
        "required": [
          "title",
          "description"
        ]
      }
    }
  },
  "required": [
    "username",
    "embeds"
  ]
}
```