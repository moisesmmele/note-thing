# Service Description Document

Service Name: Delivery
Version: 1.0.0
Key Technologies: Cron, Python, Google Generative AI, MongoDB, Discord Webhook

## Overview

This service is responsible for creating daily summaries and debriefs of finalized notes.
It runs on a cron job, and every day at 7:50AM it creates a summary of the notes and revisions from the previous day.
It reads state from the database, determining which notes needs to be included in the summary.
It uses RAG to retrieve context from notes and revisions, and uses Google Generative AI to create the summary.
After creating the summary, it sends it to a Discord webhook.

## Responsibilities

- Read database to fech current state of notes and revisions.
- Use Google Generative AI to create summaries and debriefs.
- Send summaries and debriefs to Discord webhook.