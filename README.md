# Simple json api

### Goals
Develop a simple JSON API.

### Built with
- Ruby 2.7, Rails 6.16;
- DB: postgres;
- Serializers: jsonapi-serializer, ransack;
- Tags: acts-as-taggable-on;
- Tests: RSpec, FactoryBot;
    
### When
17.05.22

### Key features
#### perform all standard CRUD actions with resources
- /topics
- /tags

The app will allow you to indetify topic both with its "id" or "url". 

#### sort:
```
http://localhost:3000/api/v1/topics.json?topics_ids[]=1&topics_ids[]=2&sort=-id

```

#### filter:
```
http://localhost:3000/api/v1/topics.json?topics_ids[]=1&topics_ids[]=2
```
You can filter topics by "topics_ids", "tags" or "title_query".

Note that both "topics_ids" and "tags" are expected to be an Array.

#### paginate
```
http://localhost:3000/api/v1/topics.json?page[size]=5&page[number]=2
```

#### or mix:
```
http://localhost:3000/api/v1/topics.json?topics_ids[]=1&topics_ids[]=2&sort=-id
```

### ER Diagram
![alt text](https://github.com/peresvetjke/simple_json_api/blob/main/simple_json_api_v0.2.drawio.png?raw=true)
