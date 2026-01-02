# Service Description Document

Service Name: AI Processor
Version: 1.0.0
Key Technologies: Python, Google Generative AI, MongoDB, Redis

## Overview

This service is responsible for processing notes and revisions and processed versions based on the input data.
It reads state from the database, determining which notes needs to be processed. Each note is binned into an internal queue according to its required processing. After processing, the application will push events to Redis stream (note events), signaling to other services that the note has been processed.

## Responsibilities

- Read database to fech current state of notes and revisions.
- Use Google Generative AI to process the notes.
- Store the responses in the database.
- Push events to Redis stream (note events).