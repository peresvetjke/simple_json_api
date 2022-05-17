# Simple json api

With this simple API application includes CRUD operations with Materials and Tags and more.

Built with
- Ruby 2.7, Rails 6.16;
- DB: postgres;
- Serializers: jsonapi-serializer, ransack;
- Tags: acts-as-taggable-on;
- Tests: RSpec, FactoryBot;
    
### Goals
Develop a simple JSON API.

### When
17.05.22

### Key features
#### perform all CRUD actions with resources
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
You can filter topics by topics_ids, tags or title_query.
Mention that both topics_ids and tags are expected to be an Array.

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
