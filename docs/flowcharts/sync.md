```mermaid
flowchart TD
    subgraph Schedule["Sync Script - Scheduled - 10 min"]
        Cron[Cron Trigger] --> Script[Script]
    end

    Script --> Client[Joplin Client]
    Client --> Fetch[Fetch State\n(sync)]
    Fetch --> Export[Export --raw]
    Export --> Volume[to Mounted Volume]
```