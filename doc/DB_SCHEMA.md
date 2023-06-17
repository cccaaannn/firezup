```yaml
[collection]
users:
	id: string
	email: string
	username: string
	timestamp: timestamp
	groups: array <id_name>
```

```yaml
[collection]
groups:
	id: string
	name: string
	timestamp: timestamp
	owner: string <id_name>
	lastMessage: map
		id: string
		content: string
		owner: string <id_name>
		timestamp: timestamp
	members: array <id_name>

    [collection]
	messages:
		id: string
		content: string
		owner: string <id_name>
		timestamp: timestamp
```