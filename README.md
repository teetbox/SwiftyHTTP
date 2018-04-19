# SwiftyHTTP
A Swift RESTfull HTTP framework

## Features
- HTTP GET, POST, PUT, DELETE request
- HTTP Download and Upload request
- Custom HTTP request header
- Basic authentication
- Group download and upload request in Sequence or Parallel model

## Examples
For default URLSession:
```swift
let http = HTTP(base: "https://jsonplaceholder.typicode.com")
```

For ephemeral URLSession:
```swift
let http = HTTP(base: "https://jsonplaceholder.typicode.com", config: .ephemeral)
```

For background URLSession:
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
```swift
http.post("/path") { response in 
    // Response
}

http.post("/post", params: ["key": "value"]) { response in
    // Response
}

http.post("/path", headers: ["key": "value"]) { response in 
    // Response
}

http.post("/path", params: ["key": "value"], headers: ["key": "value"]) { response in 
    // Response
}
```
### PUT
```swift
http.put("/path") { response in
    // Response
}
        
http.put("/path", params: ["key": "value"]) { response in
    // Response
}
        
http.put("/path", headers: ["key": "value"]) { response in
    // Response
}

http.put("/path", params: ["key": "value"], headers: ["key": "value"]) { response in
    // Response
}
```
### DELETE
```swift
http.delete("/path") { response in
    // Response
}
        
http.delete("/path", params: ["key": "value"]) { response in
    // Response
}
        
http.delete("/path", headers: ["key": "value"]) { response in
    // Response
}
        
http.delete("/path", params: ["key": "value"], headers: ["key": "value"]) { response in
    // Response
}
```
### UPLOAD

### DOWNLOAD

### DATA REQUEST

### FILE REQUEST

### GROUP REQUEST

## Installation

## Requirements

## License
SwiftyHTTP is released under MIT license.
