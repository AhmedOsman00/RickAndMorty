# Networking Package

A Swift networking package designed to simplify API requests and responses in iOS applications. This package provides a structured way to define endpoints, handle HTTP methods, encode and decode data, and manage errors.

## Features

- **Endpoint Management**: Define endpoints with customizable HTTP methods, headers, body, and query parameters.
- **HTTP Client**: A dedicated HTTP client for making network requests and handling responses.
- **Data Encoding/Decoding**: Support for encoding and decoding JSON data using Swift’s `Encodable` and `Decodable` protocols.
- **Error Handling**: Custom error types for better error management and debugging.

## Usage

### Defining an Endpoint

Create a enum that conforms to the `Endpoint` protocol to define your API endpoints.

```swift
import Networking

enum ProductEndpoint: Endpoint {
    case create(Product)
    case update(Product)
    case delete(id: String)
    case list

    var path: String {
        switch self {
        case let .delete(id):
            "/product/\(id)"
        default:
            "/product"
        }
    }

    var method: HttpMethod {
        switch self {
        case .create:
            .POST
        case .update:
            .PUT
        case .delete:
            .DELETE
        case .list:
            .GET
        }
    }

    var body: HttpBody? {
        switch self {
        case let .create(user), let .update(user):
            try? .json(user)
        default:
            nil
        }
    }
}
```

### Making a Network Request

Use the HttpClient to perform network requests.

```swift
let client = HttpClient(session: URLSession.shared)

do {
    let user: UserModel = try await client.data(ProductEndpoint.list, JSONDecoder())
    print(user)
} catch {
    print("Error: \(error.localizedDescription)")
}
```

### Handling Errors

The package provides custom error types for handling common network-related issues.

```swift
if case let NetworkError.api(apiError) = error {
    print("API Error: \(apiError.error)")
}
```

### Error Types

The NetworkError enum defines various error cases that may occur during network requests, including:

- **decodingFailed**: Indicates a failure to decode the response.
- **invalidUrl**: Indicates that the provided URL is invalid.
- **noResponse**: Indicates that no data was received from the server.
- **api(ApiError)**: Represents an error response from the API.

# Pageable Networking System

This Swift package provides a convenient way to handle paginated API requests using protocols and a flexible paging system. It defines a set of abstractions that allow you to work with endpoints that support pagination, and a pager class to easily request and navigate through pages.

## Features

- **Protocol-based design**: Decouples the paging logic from concrete types.
- **Automatic Page Management**: Handles retrieving the first and subsequent pages, while tracking the current page.
- **Custom Query Parameters**: Supports dynamic page and count query parameter names for API flexibility.
- **Modular & Reusable**: Can be used across different endpoints with minimal configuration.

## Usage

### Define a Pageable Endpoint

Create a struct that conforms to PageableEndpoint:

```swift
struct MyPaginatedEndpoint: PageableEndpoint {
    var baseURL: URL
    var path: String
    var method: HTTPMethod = .get
    var pageQueryParameterName = "page"
    var countQueryParameter = (name: "limit", value: 20)
}
```

### Define a Pageable Response

Create a response model that conforms to Pageable:

```swift
struct PaginatedResponse<T: Decodable>: Pageable {
    var totalPages: UInt
    var items: [T]
}
```

### Fetch Pages

Use the Pager class to manage pagination:

```swift
let pager = Pager(httpClient: httpClient)
let endpoint = MyPaginatedEndpoint(baseURL: URL(string: "https://api.example.com")!, path: "/items")

Task {
    do {
        // Fetch the first page
        let firstPage: PaginatedResponse<Item>? = try await pager.firstPage(endpoint: endpoint, decoder: JSONDecoder())

        // Fetch the next page
        let nextPage: PaginatedResponse<Item>? = try await pager.nextPage(endpoint: endpoint, decoder: JSONDecoder())
    } catch {
        print("Error fetching paginated data: \(error)")
    }
}
```
