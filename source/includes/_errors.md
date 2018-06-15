# Errors

All API responses are in JSON format. A `result` field, with a value of `success` or `error` is returned with each request. In the event of an error, a `message` field will provide an error message.

## HTTP error codes

The Kaiko Query API uses the following error codes:

Error Code | Meaning
---------- | -------
400 | Bad Request
401 | Unauthorized -- You are not authenticated properly. See [Authentication](#authentication).
403 | Forbidden -- You don't have access to the requested resource
404 | Not Found
405 | Method Not Allowed
406 | Not Acceptable
429 | Too Many Requests -- [Rate limit](#rate-limiting] exceeded. <a href='https://www.kaiko.com/pages/contact'>Contact us</a> if you think you have a need for more.
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance.
