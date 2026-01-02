```mermaid
flowchart LR
    title[Content Creation\nState is synced across platforms]

    User((User))
    
    subgraph Clients
        Mobile[Joplin Client\n(Mobile)]
        Desktop[Joplin Client\n(desktop)]
    end

    Server[Joplin Server]

    User --> Mobile
    User --> Desktop
    
    Mobile --> Server
    Desktop --> Server
```