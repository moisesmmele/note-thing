```mermaid
flowchart TD
    title[Interaction Server - Long Lived - Laravel]

    %% Left Flow: Pending Reviews
    subgraph ReviewFlow
        ReadDB[Read from DB] --> FetchPending[fetch pending review]
        TriggerReview[Webhook Trigger\n/reviews-updated] --> FetchPending
        
        FetchPending --> DynamicReview[Dynamic Web Page\nFrom Contents]
        DynamicReview --> ServeReview[Serve\n/review/pending\n/review/{uuid}]
        
        ServeReview --> UserAction{User Action}
        UserAction -->|Skip| Skip[Skip]
        UserAction -->|Approve| Approve[Approve]
        UserAction -->|Modify| Modify[Modify]
        
        Skip --> PostEnd[POST Endpoint]
        Approve --> PostEnd
        Modify --> PostEnd
        
        PostEnd --> UpdateDB[Update Database]
        UpdateDB --> FetchPending
    end

    %% Right Flow: Notes Display
    subgraph NotesFlow
        TriggerNotes[Webhook Trigger\n/notes-updated] --> FetchDB_Notes[Fetch Database]
        FetchDB_Notes --> Finalized[Finalized]
        Finalized --> DynamicPages[Dynamic Web Pages]
        DynamicPages --> ServeNotes[Serve\n/notes\n/notes/{uuid}]
    end
```