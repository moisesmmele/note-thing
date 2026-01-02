```mermaid
flowchart LR
    subgraph Schedule["Processing - Scheduled - 1 hr"]
        DB[Database] --> CheckStatus[Check Status]
    end

    CheckStatus --> NewNote[New Note]
    CheckStatus --> UpdatedNote[Updated Note]
    CheckStatus --> PendingReview[Pending Review]
    CheckStatus --> IterationReview[Iteration Review]
    CheckStatus --> ReviewApproved[Review Approved]
    CheckStatus --> Finalized[Finalized]

    %% Logic Branches
    NewNote --> TagAI[Tag (AI)]
    TagAI --> FormatAI[Format (AI)]

    UpdatedNote --> GetContext[Get Context]
    IterationReview --> GetContext
    GetContext --> FormatAI

    PendingReview --> Done

    FormatAI --> SetPending[Pending Review]
    SetPending --> EmitWebhook[Emit Webhook]

    ReviewApproved --> MarkFinal[Mark as Finalized]

    Finalized --> Done((Done))
```