```mermaid
flowchart LR
    subgraph Schedule["Ingesting - Scheduled - 10 min"]
        Joplin[Joplin Client\n(Export Script)]
    end

    Joplin --> ReadDisk[Read from disk]
    ReadDisk --> Hash[MinHash and Md5]
    Hash --> Classify[classify]

    Classify --> NewNote[New Note]
    Classify --> NearDup[Near duplicate]
    Classify --> PerfectDup[perfect duplicate]

    NewNote --> Create[Create]
    NearDup --> Update[Update]
    PerfectDup --> Ignore[Ignore]

    Create --> DB[(Database)]
    Update --> DB
    Ignore --> DB
```