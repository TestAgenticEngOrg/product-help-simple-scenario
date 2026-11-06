import ballerina/http;
import ballerina/os;

// The Products API's base path; it serves its routes under it.
const API_BASE_PATH = "/api/v1";

// The Products API in the same project. On WSO2 Cloud, OpenChoreo injects its address from the
// endpoint dependency in workload.yaml; locally it defaults to the API on localhost.
final string productsApiUrl = apiUrl(os:getEnv("PRODUCTS_API_URL"));

final http:Client productsApi = check new (productsApiUrl, httpVersion = http:HTTP_1_1);

// Accepts the API's address with or without the base path, so http://products-api:8080 and
// http://products-api:8080/api/v1 both work.
isolated function apiUrl(string address) returns string {
    string url = address == "" ? "http://localhost:8080" : address;
    while url.endsWith("/") {
        url = url.substring(0, url.length() - 1);
    }
    return url.endsWith(API_BASE_PATH) ? url : url + API_BASE_PATH;
}
