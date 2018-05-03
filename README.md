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
let http = CEHTTP(base: "https://jsonplaceholder.typicode.com")
```

For ephemeral URLSession:
```swift
let http = CEHTTP(base: "https://jsonplaceholder.typicode.com", config: .ephemeral)
```

For background URLSession:
```swift
let http = CEHTTP(base: "https://jsonplaceholder.typicode.com", config: .background("backgroundId"))
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
Upload with URL
```swift
let path = "/path/to/upload"
let fileURL = URL(string: "/Users/matt/Desktop/swift.jpg")!
let content = MultiPartContent(name: "file", type: .jpg, url: fileURL)
        
http.upload(path, content: content) { response in
    // Response
}
```
Upload with data
```swift
let path = "/path/to/upload"
let params = ["userNo": "test1234"]
        
guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: imageData)

http.upload(path, content: content, params: params) { response in
    // Response
}
```
### DOWNLOAD
```swift
let path = "/path/to/download"

http.download(path) { response in
    // Response
}

http.download(path, params: ["key": "value"], headers: ["key": "value"]) { response in 
    // Response
}
```
### DATA REQUEST
Data request is another way to do GET, POST, PUT and DELETE HTTP request. Firstly, it returns a request, you could continue to do some configuration for it before send it, such as set authorization.

Simple GET data request
```swift
let request = http.dataRequest(path: "/path", method: .get)
request.setAuthorization(username: "username", password: "password")
request.go { response in
    // Response
}
```
Full params POST data request
```swift
let request = http.dataRequest(path: "/path", method: .post, params: ["key": "value"], headers: ["key": "value"])
request.setAuthorization(basicToken: "Basic ABCDEFGHIJKLMN")
request.go { response in
    // Response
}
```
### FILE REQUEST
File request is another way to do upload and download HTTP request. In its parameters, you could pass two closures, one is progress, the other is completed.

Upload file request
```swift
let path = "/path/to/upload"
let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
    // Progress
}
let completed: CompletedClosure = { url, error in
    // URL
}
let fileURL = URL(string: "/Users/matt/Desktop/swift.jpg")!
let content = MultiPartContent(name: "file", type: .jpg, url: fileURL)

let request = http.fileRequest(uploadPath: path, content: content, progress: progress, completed: completed)
request.go()
```
Download file request
```swift
let path = "/path/to/download"
let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
    // Progress
}
let completed: CompletedClosure = { url, error in
    // URL
}

let request = http.fileRequest(downloadPath: path, progress: progress, completed: completed)
request.go()
```
### GROUP REQUEST
Group request is used for grouping file requests. It can run either sequential or concurrent.

Sequential group
```swift
let file = http.fileRequest(downloadPath: "/path1", completed: { _, _ in })
let file2 = http.fileRequest(downloadPath: "/path2", completed: { _, _ in })
let file3 = http.fileRequest(downloadPath: "/path3", completed: { _, _ in })

(file --> file2 --> file3).go()
```
Concurrent group 
```swift
let file = http.fileRequest(downloadPath: "/path1", completed: { _, _ in })
let file2 = http.fileRequest(downloadPath: "/path2", completed: { _, _ in })
let file3 = http.fileRequest(downloadPath: "/path3", completed: { _, _ in })

(file ||| file2 ||| file3).go()
```
## Installation

## Requirements

## License
SwiftyHTTP is released under MIT license.
