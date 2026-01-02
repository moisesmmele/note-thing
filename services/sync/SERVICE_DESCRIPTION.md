# Service Description Document

Service Name: Sync
Version: 1.0.0
Key Technologies: Cron, Python, MongoDB, Redis, MinHash

## Overview

This service is responsible for syncing notes from Source, whichever it might be (currently joplin) to the database.
It has two stages: sync and ingest. Sync is responsible for fetching notes in raw markdown format from the source.
Ingest is responsible for parsing, deduplication, near-duplication detection, categorization (new, update or delete), and reflecting the changes in the database. 
Since cannot rely either on metadata or filenames, it is necessary to use a more advanced method for content deduplication. It uses md5 hashing for deduplication and MinHash for near-duplication detection. New notes (no entries) are marked as new, near-dupes are marked as updates, dupes are ignored, and notes with database entries but no source entries are marked as deleted.
After ingesting, it will push events to Redis stream (note events), signaling to other services that the note has been ingested.

## Responsibilities

- Sync notes from source to database.
- Ingest notes from database to reflect changes in the database.
- Deduplication and near-duplication detection.
- Categorization (new, update or delete).
- Reflect changes in the database.
- Push events to Redis stream (note events).