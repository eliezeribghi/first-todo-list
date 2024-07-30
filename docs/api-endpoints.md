# API endpoints

| Endpoint | HTTP method | Data to send | Description | Parameters |
|--|--|--|--|--|
| `/api/tasks` | GET | - | Get all tasks details | - |
| `/api/tasks/[id]` | GET | - | Get a single task details | `id` - ID of the task to show |
| `/api/tasks` | POST | `title` | Create a new task | - |
| `/api/tasks/[id]` | PUT | `title` | Update a task | `id` - ID of the task to update |
| `/api/tasks/[id]` | DELETE | - | Delete a task | `id` - ID of the task to delete |
