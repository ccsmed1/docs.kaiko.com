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

## Rate limiting

Query limits are based on your API key. Currently, each API key is allowed a maximum of 1000 requests per minute and 10000 requests per hour.


## Timestamps

### Input

All time parameters are in UTC and returned in the following ISO 8601 datetime format:

`YYYY-MM-DD`**T**`hh:mm:ss.sss`**Z**

For example:

`2017-12-17T13:35:24.351Z`

The "T" separates the date from the time. The “Z” at the end indicates that this is a UTC time.

### Output
All timestamps are returned as <a href="https://currentmillis.com/" target="_blank">millisecond Unix timestamps </a>(the number of milliseconds elapsed since 1970-01-01 00:00:00.000 UTC). For metadata fields, times are also returned in millisecond-resulution ISO 8601 datetime strings in the same format as input.


## Market open and close

Digital asset exchanges operate approximately 24x7x365. 

For exchange data, the opening price is calculated as the first trade at or after 00:00:00 UTC. The closing price is calculated as the last trade prior to 00:00:00 UTC.

## Envelope

> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:19:40.303Z",
	"timestamp": 1528996780303,
	"query": {...},
	"data": [...]
}

```

All API responses are in JSON format. A `result` field, with a value of `success` or `error` is returned with each request. In the event of an error, a `message` field will provide an error message.

Key | Data type | Description
--------- | -------- | ---------
`result`	| `string` | `success` if query successful, `error` otherwise.
`time`	| `string` | The current time at our endpoint.
`timestamp`	| `long` | The current time at our endpoint.
`message`	| `string` | Error message, if query was not successful.
`query`	| `{}` | All handled query parameters echoed back.
`data`	| <code>[] &#124; {}</code> | Response result data.

## Pagination

> Pagination Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:19:40.303Z",
	"timestamp": 1528996780303,
	"query": {...},
	"data": [...],
	"continuation_token": "ab25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55",
	"next_url": "https://query-api.kaiko.io/bfnx/btc-usd/trades/?continuation_token=ab25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55"
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
	"time": "2018-06-14T17:26:08.901Z",
	"timestamp": 1528997168901,
	"data": [
		{
			"code": "btc",
			"name": "Bitcoin"
		},
		{
			"code": "bch",
			"name": "Bitcoin Cash"
		},
		{
			"code": "jpy",
			"name": "Japanese Yen"
		}
	]
}
```

This endpoint retrieves a list of supported assets.

### HTTP request

`GET https://query-api.kaiko.io/v1/assets`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
none	|



## Asset pairs

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/pairs"
	-H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:27:31.621Z",
	"timestamp": 1528997251621,
	"data": [
		{
			"code": "ada-btc",
			"base_code": "ada",
			"base_name": "Cardano",
			"quote_code": "btc",
			"quote_name": "Bitcoin"
		},
		{
			"code": "ada-eth",
			"base_code": "ada",
			"base_name": "Cardano",
			"quote_code": "eth",
			"quote_name": "Ethereum"
		}
	]
}
```

This endpoint retrieves a list of supported asset pairs.


### HTTP request

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
	"time": "2018-06-14T17:28:42.915Z",
	"timestamp": 1528997322915,
	"data": [
		{
			"code": "bfly",
			"name": "bitFlyer",
			"website": "https://bitflyer.jp",
			"pairs": [
				{
					"code": "btc-usd",
					"base_code": "btc",
					"base_name": "Bitcoin",
					"quote_code": "usd",
					"quote_name": "US Dollar",
					"start_time": "2018-04-18T04:50:15.000Z",
					"start_timestamp": 1524027015000,
					"end_time": null,
					"end_timestamp": null,
					"trade_count": 75463
				},
				// ...
			]
		}
	]
}
```

This endpoint retrieves a list of supported exchanges including (pairs)[#exchange-pairs].


### HTTP request

`GET https://query-api.kaiko.io/v1/exchanges`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
none	| |


## Exchange pairs

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/bfnx"
	-H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:31:07.519Z",
	"timestamp": 1528997467519,
	"data": [
	{
		"code": "btc-usd",
		"base_code": "btc",
		"base_name": "Bitcoin",
		"quote_code": "usd",
		"quote_name": "US Dollar",
		"start_time": "2013-04-01T00:07:49.000Z",
		"start_timestamp": 1364774869000,
		"end_time": null,
		"end_timestamp": null,
		"trade_count": 48783086
	},
	{
		"code": "eth-usd",
		"base_code": "eth",
		"base_name": "Ethereum",
		"quote_code": "usd",
		"quote_name": "US Dollar",
		"start_time": "2016-03-09T16:04:35.000Z",
		"start_timestamp": 1457539475000,
		"end_time": null,
		"end_timestamp": null,
		"trade_count": 22507604
	},
	// ....
	],
	"query": {
		"exchange": "bfnx"
	}
}
```

This endpoint retrieves a list of asset pairs for a specific exchange. Times refer to start and end of trade coverage. `trade_count` is the number of trades available. Due to real-time constraints, the actual number of trades available through this API is very likely higher for any actively traded pairs (where `end_time` and `end_timestamp` is null).

### HTTP request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`code` | Yes | See [/v1/exchanges](#exchanges).


## Exchange trades

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/bfnx/btc-usd/trades"
	-H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:37:22.002Z",
	"timestamp": 1528997842002,
	"data": [
		{
			"modified_timestamp": 1524602571000,
			"timestamp": 1417412036761,
			"trade_id": "1",
			"price": "300.0",
			"amount": "0.01",
			"taker_side_sell": true
		},
		{
			"modified_timestamp": 1524602571000,
			"timestamp": 1417412423076,
			"trade_id": "2",
			"price": "300.0",
			"amount": "0.01",
			"taker_side_sell": false
		},
		// ...
	],
	"query": {
		"exchange": "bfnx",
		"pair": "btc-usd",
		"continuation_token": null,
		"start_time": null,
		"end_time": null,
		"page_size": 1000,
		"request_time": "2018-06-14T17:37:21.935Z"
	},
	"continuation_token": "55x1LNBXKETZVDaR43BjMQjkCbandDRx1cKmcqKUgBvoUk7LAPut1HPoK5ATGGx4RhbC1cCcHWqtJtQMFhjXm71oQboUUjZmB3NteZYKVGUf69NsjykHTL4j2W3cpiYEFF91aDTCmbbL1VjkXvf4bn4TmpdSDAVrZDH4pktja3Zxuk4XDdRANCuTU4pvrNew1sUUw29jMSHr",
	"next_url": "http://localhost:9292/v1/exchanges/gdax/btc-usd/trades?continuation_token=55x1LNBXKETZVDaR43BjMQjkCbandDRx1cKmcqKUgBvoUk7LAPut1HPoK5ATGGx4RhbC1cCcHWqtJtQMFhjXm71oQboUUjZmB3NteZYKVGUf69NsjykHTL4j2W3cpiYEFF91aDTCmbbL1VjkXvf4bn4TmpdSDAVrZDH4pktja3Zxuk4XDdRANCuTU4pvrNew1sUUw29jMSHr"
}
```

This endpoint retrieves trades for an asset pair on a specific exchange. By default returns the 1000 first trades in our dataset. Trades are sorted by time, ascendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange}/{pair}/trades{?start_time,end_time,page_size,continuation_token}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange` | Yes | Exchange `code`. See [/v1/exchanges](#exchanges).
`pair` | Yes | Pair `code`. See [/v1/pairs](#exchange-pairs).
`start_time` | No | Starting time in ISO 8601 (inclusive).
`end_time` | No | Ending time in ISO 8601 (inclusive).
`page_size` | No | See [Pagination](#pagination) (min: 100, default: 100, max: 10000).
`continuation_token` | No | See [Pagination](#pagination).


## Recent trades

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/gdax/btc-usd/trades/recent"
	-H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:44:37.446Z",
	"timestamp": 1528998277446,
	"data": [
		{
			"modified_timestamp": 1528998138222,
			"timestamp": 1528998137627,
			"trade_id": "44840133",
			"price": "6592.22",
			"amount": "0.08741431",
			"taker_side_sell": true
		},
		{
			"modified_timestamp": 1528998138222,
			"timestamp": 1528998137627,
			"trade_id": "44840134",
			"price": "6592.22",
			"amount": "0.01057674",
			"taker_side_sell": true
		},
		// ...
	],
	"query": {
		"limit": 1000,
		"exchange": "bfnx",
		"pair": "btc-usd"
	}
}
```

This endpoint retrieves the most recent trades for an asset pair on a specific exchange. By default returns the 1000 most recent trades. This endpoint does not support pagination. Trades are sorted by time, descendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange}/{pair}/trades/recent{?limit}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange` | Yes | Exchange `code`. See [/v1/exchanges](#exchanges).
`pair` | Yes | Pair `code`. See [/v1/pairs](#exchange-pairs).
`limit` | No | Maximum number of results (min: 1, default: 100, max: 10000)

## Market data aggregations

> Request Example

```curl
curl "https://query-api.kaiko.io/v1/exchanges/gdax/btc-usd/aggregations/ohlcv"
	-H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
	"result": "success",
	"time": "2018-06-14T17:55:49.033Z",
	"timestamp": 1528998949033,
	"data": [
		{
			"modified_timestamp": 1528990180000,
			"timestamp": 1417392000000,
			"open": "300.0",
			"high": "370.0",
			"low": "300.0",
			"close": "370.0",
			"volume": "0.05655554"
		},
		{
			"modified_timestamp": 1528990180000,
			"timestamp": 1417478400000,
			"open": "377.0",
			"high": "378.0",
			"low": "377.0",
			"close": "378.0",
			"volume": "15.0136"
		}
	],
	"query": {
		"continuation_token": null,
		"start_time": null,
		"end_time": null,
		"page_size": 2,
		"exchange": "gdax",
		"pair": "btc-usd",
		"interval": "1d",
		"request_time": "2018-06-14T17:55:48.908Z"
	}
}
```

This endpoint retrieves trade data aggregated history for an asset pair on a specific exchange. Returns the earliest available OHLCV by default. The `interval` parameter can be suffixed with `s`, `m`, `h` or `d` to specify seconds, minutes, hours or days, respectively. Values are sorted by time, ascendingly.


### HTTP request

`GET https://query-api.kaiko.io/v1/exchanges/{exchange}/{pair}/aggregations/{aggregation_type}{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

Parameter | Required | Description
--------- | -------- | ---------
`exchange` | Yes | Exchange `code`. See [/v1/exchanges](#exchanges).
`pair` | Yes | Pair `code`. See [/v1/pairs](#exchange-pairs).
`aggregation_type` | Yes | Which [aggregation type](#aggregation-types) to get (currently supported: `ohlcv`).
`interval` | No | [Interval](#intervals) period in seconds (max: 1440).
`start_time` | No | Starting time in ISO 8601 (inclusive).
`end_time` | No | Ending time in ISO 8601 (inclusive).
`page_size` | No | See [Pagination](#pagination) (min: 100, default: 100, max: 10000).
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

### Intervals

The following intervals are currently supported: `1m`, `2m`, `3m`, `5m`, `10m`, `15m`, `30m`, `1h`, `2h`, `4h`, `1d`.
