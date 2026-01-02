# Service Description Document

Service Name: Interaction
Version: 1.0.0
Key Technologies: PHP, FrankenPHP, MongoDB, Redis

## Overview

This service is responsible for handling user interactions with the application.
It reads state from the database, retrieving notes pending revisions and dinamically generating pages for them,
including the input note and the processed version. The user can then interact with the application, approving, asking for revisions or skipping the note.
After interaction, it will change database state to reflect the user's decision, to be reprocessed or marked as finalized. Although no consumers are currently implemented, this service can publish events to Redis stream (note events), maybe for push notifications or triggering post processing.
It also handles displaying of finalized notes, with a simple interface to view the note in its final form, filter by category, tags, etc.

## Responsibilities

- Read database to fech current state of notes and revisions.
- Generate pages for notes pending revisions.
- Display finalized notes.
- Push events to Redis stream (note events).