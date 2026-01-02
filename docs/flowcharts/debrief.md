```mermaid
flowchart LR
    subgraph Schedule["Daily Debrief - Scheduled - every day, 7:50 AM"]
        FetchDB[Fetch Database]
    end

    subgraph Logic
        ReviewPending[Review Pending]
        ReviewLink[Review Link and\nSummary]
        MsgPending[Message with list of\npending + links]
        WeekSum[Week Summary\n(fetch context by date)]
    end

    subgraph Output
        FinalMsg[Final Message (AI)]
        Discord[Discord Webhook]
    end

    FetchDB --> ReviewPending
    FetchDB --> WeekSum
    
    ReviewPending --> ReviewLink
    ReviewLink --> MsgPending
    
    MsgPending --> FinalMsg
    WeekSum --> FinalMsg
    
    FinalMsg --> Discord
```