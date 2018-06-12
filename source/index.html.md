---
title: Kaiko Query API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - curl

toc_footers:
  - <a href='https://www.kaiko.com/'>Kaiko</a>
  - <a href='https://www.kaiko.com/pages/contact'>Contact us</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Kaiko Query API.

Kaiko provides historical institutional quality market data for the leading digital assets. Our system retrieves and validates millions of trades each day from the world's leading cryptocurrency exchanges to deliver robust and reliable market data to financial firms globally.


## Authentication

> Request Syntax


```curl
curl "https://query-api.kaiko.io/v1"
  -H "x-api-key: <client-api-key>"
```

The base URL for the API is: 

`https://query-api.kaiko.io/v1`

Clients must include an API key in the header of every request they make to the API. The format is as follows:

`x-api-key: <client-api-key>`

<aside class="notice">
You must replace <code>&lt;client-api-key&gt;</code> with your assigned API key.
</aside>


## Timestamps

All timestamps are in UTC and returned in the following ISO 8601 datetime format:

`YYYY-MM-DD`**T**`hh:mm:ss.sss`**Z**

For example:

`2017-12-17T13:35:24.351Z`

The "T" separates the date from the time. The “Z” at the end indicates that this is a UTC time.

Timestamp arguments must also be in this format.


## Market Open and Close

Digital asset exchanges operate approximately 24x7x365. 

For exchange data, the opening price is calculated as the first trade at or after 00:00:00 UTC. The closing price is calculated as the last trade prior to 00:00:00 UTC.

## Envelope

> Response Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"query": {...},
	"data": [...]
}

```

All API responses are in JSON format. A `result` field, with a value of `success` or `error` is returned with each request. Upon an `error` a `message` field will provide an error message.

Key | Data type | Description
--------- | -------- | ---------
`result`	| `string` | `success` if query successful, `error` otherwise.
`time`	| `string` | The current time at our endpoint.
`message`	| `string` | Error message, if query was not successful.
`query`	| `{}` | All handled query parameters echoed back.
`data`	| <code>[] &#124; {}</code> | Response result data.

## Pagination

> Pagination Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"query": {...},
	"continuation_token": "b25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55",
	"next_url": "https://query-api.kaiko.io/bf/BTCUSD/trades/?continuation_token=b25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55",
	"data": [...]
}

```

For queries that result in a larger dataset than can be returned in a single response, a `continuation_token` field is included. Calling the same endpoint again with the `continuation_token` query parameter added will return the next result page. For convenience, a `next_url` field is also included, containing a URL that can be called directly to get the next page. Paginated endpoints also takes a `page_size` parameter that specifies the maximum number of items that should be included in each response.

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`page_size` | No | Maximum number of records to return in one response
`continuation_token` | No |

# Metadata

## Assets

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/assets"
  -H "x-api-key: <client-api-key>"
```

> Response Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"data": [
		{
			"asset_id": "BTC",
			"name": "Bitcoin",
			"type": "crypto"
		},
		{
			"asset_id": "BCH",
			"name": "Bitcoin Cash",
			"type": "crypto"
		},
		{
			"asset_id": "JPY",
			"name": "Japanese Yen",
			"type": "fiat"
		}
	]
}
```

This endpoint retrieves a list of supported assets.

### HTTP Request

`GET https://query-api.kaiko.io/v1/assets`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
none	|



## Asset Pairs

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/pairs"
  -H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"data": [
		{
			"pair_code": "BTC-USD",
			"base_code": "BTC",
			"base_name": "Bitcoin",
			"quote_code": "USD",
			"quote_name": "US Dollar"
		},
		{
			"pair_code": "ETH-USD",
			"base_code": "ETH",
			"base_name": "Ethereum",
			"quote_code": "USD",
			"quote_name": "US Dollar"
		}
	]
}
```

This endpoint retrieves a list of supported asset pairs.


### HTTP Request

`GET https://query-api.kaiko.io/v1/pairs`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
none	| |


# Exchange Data

## Exchanges

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges"
  -H "x-api-key: <client-api-key>"
```

> Response Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"data": [
		{
			"exchange_id": "BFNX",
			"name": "Bitfinex",
			"website": "https://www.bitfinex.com"
		},
		{
			"exchange_id": "BFLY",
			"name": "bitFlyer",
			"website": "https://www.bitflyer.com/"
		}
	]
}
```

This endpoint retrieves a list of supported exchanges.


### HTTP Request

`GET https://query-api.kaiko.io/v1/exchanges`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
none	| |




## Exchange Pairs

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/BFNX"
  -H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2017-12-22T03:27:30.965Z",
	"data": [
		{
			"pair_code": "BTC-USD",
			"base_code": "BTC",
			"base_name": "Bitcoin",
			"quote_code": "USD",
			"quote_name": "US Dollar"
		},
		{
			"pair_code": "ETH-USD",
			"base_code": "ETH",
			"base_name": "Ethereum",
			"quote_code": "USD",
			"quote_name": "US Dollar"
		}
	]
}
```

This endpoint retrieves a list of asset pairs for a specific exchange.

### HTTP Request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange_id}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange_id` | Yes | See [/v1/exchanges](#exchanges).


## Exchange Trades

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/BFNX/BTC-USD/trades"
  -H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-01-07T14:27:38.171Z",
	"query": {
	},
	"continuation_token": "ABC123",
	"next_url": "https://query-api.kaiko.io/v1/exchanges/BFNX/BTC-USD/trades?continuation_token=ABC123",

	"data": [
		{
			"price": 16565.79,
			"amount": 0.05140238,
			"time": "2018-01-07T14:27:32.329Z"
		},
		{
			"price": 16565.79,
			"amount": 0.03612889,
			"time": "2018-01-07T14:27:23.138Z"
		},
		{
			"price": 16565.78,
			"amount": 0.1352,
			"time": "2018-01-07T14:27:14.149Z"
		}
	]
}
```

This endpoint retrieves trades for an asset pair on a specific exchange. By default returns the 100 most recent trades.


### HTTP Request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange_id}/{pair_id}/trades{?start_time,end_time,page_size,continuation_token}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange_id` | Yes | See [/v1/exchanges](#exchanges).
`pair_id` | Yes | See [/v1/pairs](#exchange-pairs).
`start_time` | No | Starting time in ISO 8601 (inclusive).
`end_time` | No | Ending time in ISO 8601 (inclusive).
`page_size` | No | See [Pagination](#pagination) (default: 100, max: 10000).
`continuation_token` | No | See [Pagination](#pagination).



## Market Data Aggregations

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/BFNX/BTCUSD/aggregation/ohlcv"
  -H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-01-07T14:29:07.592Z",
	"data": [
		{
			"time": "2018-01-07T14:28:00.000Z",
			"open": 16565.79,
			"high": 16565.79,
			"low": 16565.78,
			"close": 16565.78,
			"volume": 3.87739761,
			"count": 15
		},
		{
			"time": "2018-01-07T14:27:00.000Z",
			"open": 16565.79,
			"high": 16565.79,
			"low": 16565.78,
			"close": 16565.78,
			"volume": 0.92360209,
			"count": 9
		},
		{
			"time": "2018-01-07T14:26:00.000Z",
			"open": 16565.79,
			"high": 16565.79,
			"low": 16565.78,
			"close": 16565.78,
			"volume": 0.44495095,
			"count": 7
		}
	]
}
```

This endpoint retrieves trade data aggregated history for an asset pair on a specific exchange. By default returns the most recent OHLCV values. The `interval` parameter can be suffixed with `m`, `h` or `d` to specify minutes, hours or days, respectively.


### HTTP Request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange_id}/{pair_id}/aggregation/{aggregation_type}{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange_id` | Yes | See [/v1/exchanges](#exchanges).
`pair_id` | Yes | See [/v1/pairs](#exchange-pairs).
`aggregation_type` | Yes | Which aggregation to get (currently supported: `ohlcv`).
`interval` | No | Interval period in seconds (max: 1440).
`start_time` | No | Starting time in ISO 8601 (inclusive).
`end_time` | No | Ending time in ISO 8601 (inclusive).
`page_size` | No | See [Pagination](#pagination) (default: 100, max: 10000).
`continuation_token` | No | See [Pagination](#pagination).

### Aggregation types

Aggregation | Fields
--------- |  ---------
`ohlcv` | `open`,`high`,`low`,`close`,`volume`

### Fields

Field | Description
--------- |  ---------
`open` | Opening price of interval.
`high` | Highest price during interval.
`low` | Lowest price during interval.
`close` | Closing price of interval.
`volume` | Volume traded in interval.

[comment]: <> (count | Number of trades in interval.)
[comment]: <> (vwap | <a href="https://www.investopedia.com/terms/v/vwap.asp" target="_blank">Volume-weighted average price</a>.)
