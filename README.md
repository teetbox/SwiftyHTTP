# SwiftyHTTP
A RESTfull HTTP framework written in Swift.

## Features
- HTTP GET, POST, PUT, DELETE request
- HTTP Download and Upload request
- Custom HTTP request header
- Basic authication
- Group download and upload request in Sequence or Parallel model

## Examples
For default session:
```swift
let http = HTTP(base: "https://jsonplaceholder.typicode.com")
```

For ephemeral session:
```swift
let http = HTTP(base: "https://jsonplaceholder.typicode.com", config: .ephemeral)
```

For background session:
```swift
let http = HTTP(base: "https://jsonplaceholder.typicode.com", config: .background("backgroundId"))
```

### GET
Simple GET
```swift
http.get("/posts/1") { response in
    let json = response.json
    /*
    {
      "userId": 1,
      "id": 1,
      "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
    }
    */
}
```
GET with params
```swift
http.get("/comments", params: ["postId": 1]) { response in
    let jsonArray = response.jsonArray
    /*
    [
      {
        "postId": 1,
        "id": 1,
        "name": "id labore ex et quam laborum",
        "email": "Eliseo@gardner.biz"
       },
       {
         "postId": 1,
         "id": 2,
         "name": "quo vero reiciendis velit similique earum",
         "email": "Jayne_Kuhic@sydney.com"
       }
     ]
     */
}
``` 
GET with headers
```swift
http.get("/path", headers: ["key": "value"]) { response in
    // Response
}
```
GET with params and headers
```swift
http.get("/path", params: ["key": "value"], headers: ["key": "value"]) { response in
    // Response
}
```
### POST
