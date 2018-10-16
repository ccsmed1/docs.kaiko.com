---
title: Kaiko API Platform Reference
language\_tabs:
  - curl
toc_footers:
  - <a href='https://www.kaiko.com/'>Kaiko</a>
  - <a href='https://www.kaiko.com/pages/contact'>Contact us</a>
search: true
---

# Introduction

Kaiko provides live and historical institutional quality market data for the digital assets. Our service retrieves and validates millions of trades each day from the world's leading cryptocurrency exchanges to deliver robust and reliable market data to financial institutions globally.

Kaiko currently provides two HTTP APIs:

* [Reference Data](#reference-data-api) (Public)
* [Market Data](#market-data-api) (Authenticated)

## Timestamps

### Input

All time parameters are in UTC and returned in the following ISO 8601 datetime format:

`YYYY-MM-DD`**T**`hh:mm:ss.sss`**Z**

For example:

`2017-12-17T13:35:24.351Z`

The "T" separates the date from the time. The "Z" at the end indicates UTC time.

### Output

All timestamps are returned as <a href="https://currentmillis.com/" target="_blank">millisecond Unix timestamps </a>(the number of milliseconds elapsed since 1970-01-01 00:00:00.000 UTC). For metadata fields, times are also returned in millisecond-resolution ISO 8601 datetime strings in the same format as input for convenience.

## Market open and close

Digital asset exchanges operate approximately 24x7x365.

For daily aggregated data, the opening price is calculated as the first trade at or after 00:00:00 UTC. The closing price is calculated as the last trade prior to 00:00:00 UTC.

# Reference Data API

## Endpoints

The base URL for the Reference Data Endpoints is: `https://reference-api.kaiko.io/`. Authentication is not required.

## Assets

> Request Example

```curl
curl "https://reference-api.kaiko.io/v1/assets"
```

> Response Example

```json
{
    "result": "success",
    "data": [
        {
            "code": "btc",
            "name": "Bitcoin",
            "asset_class": "cryptocurrency"
        },
        {
            "code": "bch",
            "name": "Bitcoin Cash",
            "asset_class": "cryptocurrency"
        },
        {
            "code": "jpy",
            "name": "Japanese Yen",
            "asset_class": "fiat"
        },
        // ...
    ]
}
```

This endpoint retrieves a list of supported assets.

### HTTP request

`GET https://reference-api.kaiko.io/v1/assets`

### Parameters

No parameters supported.

## Exchanges

> Request Example

```curl
curl "https://reference-api.kaiko.io/v1/exchanges"
```

> Response Example

```json

{
    "result": "success",
    "data": [
        {
            "code": "bfly",
            "name": "bitFlyer",
            "kaiko_legacy_slug": "bl",
            "api_name": "bitflyer"
        },
        {
            "code": "bfnx",
            "name": "Bitfinex",
            "kaiko_legacy_slug": "bf",
            "api_name": "bitfinex"
        }
        // ...
    ]
}
```

This endpoint retrieves a list of supported exchanges.

### HTTP request

`GET https://<region>.market-api.kaiko.io/v1/exchanges`

### Parameters

No parameters supported.

## Instruments

> Request Example

```curl
curl "https://reference-api.kaiko.io/v1/instruments"
```

> Response Example

```json

{
    "result": "success",
    "data": [
        {
            "exchange_code": "btcc",
            "code": "btc-cny",
            "base_asset": "btc",
            "quote_asset": "cny",
            "kaiko_legacy_exchange_slug": "bc",
            "kaiko_legacy_symbol": "btccny",
            "exchange_pair_code": "btccny",
            "class": "spot",
            "trade_start_time": "2011-06-13T05:13:24.0000000Z",
            "trade_start_timestamp": 1307942004000,
            "trade_end_time": "2017-09-30T03:59:59.0000000Z",
            "trade_end_timestamp": 1506743999000,
            "trade_count": 124449872,
            "trade_compressed_size": 1073273654
        },
        {
            "exchange_code": "btcc",
            "code": "btc-usd",
            "base_asset": "btc",
            "quote_asset": "usd",
            "kaiko_legacy_exchange_slug": "bc",
            "kaiko_legacy_symbol": "btcusd",
            "exchange_pair_code": "btcusd",
            "class": "spot",
            "trade_start_time": "2018-01-14T04:50:48.0000000Z",
            "trade_start_timestamp": 1515905448542,
            "trade_end_time": null,
            "trade_end_timestamp": null,
            "trade_count": 15320,
            "trade_compressed_size": 183147
        },
        {
            "exchange_code": "wexn",
            "code": "btget-btc",
            "base_asset": "btget",
            "quote_asset": "btc",
            "kaiko_legacy_exchange_slug": "be",
            "kaiko_legacy_symbol": "btgetbtc",
            "exchange_pair_code": "btgetbtc",
            "class": "spot",
            "trade_start_time": null,
            "trade_start_timestamp": null,
            "trade_end_time": null,
            "trade_end_timestamp": null,
            "trade_count": 0,
            "trade_compressed_size": 0
        }
        // ...
    ]
}
```

This endpoint retrieves a list of supported instruments. There are 3 possible cases regarding the trading period:

* It has started but not ended yet (start time fields will be set, but end time fields will be `null`)
* It is done (both start and end time fields are set)
* It has not started yet (both start and end time fields are `null`)

### HTTP request

`GET https://<region>.market-api.kaiko.io/v1/exchanges`

### Parameters

No parameters supported.


# Market Data API

## Endpoints

The base URL for the Market Data Endpoints is regionalized. We are currently offering endpoints in the US and in Europe:

* `https://us-beta.market-api.kaiko.io/`
* `https://eu-beta.market-api.kaiko.io/`

## Usage

### Authentication

> Request Syntax

```curl
curl "https://<api_hostname>/<endpoint>"
    -H "x-api-key: <client-api-key>"
```

Each API lives under its own hostname. Clients must include an API key in the header of every request they make. The format is as follows:

`X-Api-Key: <client-api-key>`

<aside class="notice">
You must replace <code>&lt;client-api-key&gt;</code> with your assigned API key.
</aside>

### Rate limiting

Query limits are based on your API key. Currently, each API key is allowed a maximum of 1000 requests per minute and 10000 requests per hour.

### Envelope

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

| Key         | Data type                 | Description                                       |
| ---         | ---                       | ---                                               |
| `data`      | <code>[] &#124; {}</code> | Response result data.                             |
| `message`   | `string`                  | Error message, if query was not successful.       |
| `query`     | `{}`                      | All handled query parameters echoed back.         |
| `result`    | `string`                  | `success` if query successful, `error` otherwise. |
| `time`      | `string`                  | The current time at our endpoint.                 |
| `timestamp` | `long`                    | The current time at our endpoint.                 |

### Pagination

> Pagination Example

```json
{
    "result": "success",
    "time": "2018-06-14T17:19:40.303Z",
    "timestamp": 1528996780303,
    "query": {...},
    "data": [...],
    "continuation_token": "ab25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55",
    "next_url": "https://<region>.market-api.kaiko.io/bfnx/spot/btc-usd/trades/?continuation_token=ab25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55"
}

```

For queries that result in a larger dataset than can be returned in a single response, a `continuation_token` field is included. Calling the same endpoint again with the `continuation_token` query parameter added will return the next result page. For convenience, a `next_url` field is also included, containing a URL that can be called directly to get the next page. Paginated endpoints also takes a `page_size` parameter that specifies the maximum number of items that should be included in each response. Only the first call should include `page_size`, all subsequent calls should only use `continuation_token`.

#### Parameters

| Parameter            | Required | Description                                          |
| ---                  | ---      | ---                                                  |
| `continuation_token` | No       |                                                      |
| `page_size`          | No       | Maximum  number of records to return in one response |

### Errors

All API responses are in JSON format. A `result` field, with a value of `success` or `error` is returned with each request. In the event of an error, a `message` field will provide an error message.

#### HTTP error codes

The Kaiko platform API uses the following error codes:

| Error Code | Meaning                                                                                                                                                         |
| ---------- | -------                                                                                                                                                         |
| 400        | Bad Request                                                                                                                                                     |
| 401        | Unauthorized -- You are not authenticated properly. See [Authentication](#authentication).                                                                      |
| 403        | Forbidden -- You don't have access to the requested resource                                                                                                    |
| 404        | Not Found                                                                                                                                                       |
| 405        | Method Not Allowed                                                                                                                                              |
| 406        | Not Acceptable                                                                                                                                                  |
| 429        | Too Many Requests -- [Rate limit](#rate-limiting) exceeded. <a href='https://www.kaiko.com/pages/contact'>Contact us</a> if you think you have a need for more. |
| 500        | Internal Server Error -- We had a problem with our server. Try again later.                                                                                     |
| 503        | Service Unavailable -- We're temporarily offline for maintenance.                                                                                               |


## Exchange Trades

> Request Example

```curl
curl "https://<region>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/btc-usd/trades"
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
            "timestamp": 1417412036761,
            "trade_id": "1",
            "price": "300.0",
            "amount": "0.01",
            "taker_side_sell": true
        },
        {
            "timestamp": 1417412423076,
            "trade_id": "2",
            "price": "300.0",
            "amount": "0.01",
            "taker_side_sell": false
        },
        // ...
    ],
    "query": {
        "trades_version": 1,
        "page_size": 100,
        "exchange": "bfnx",
        "instrument_class": "spot",
        "instrument": "btc-usd",
        "request_time": "2018-06-14T17:37:21.935Z"
    },
    "continuation_token": "9TlmYybkMWHnGLeD5csn9bShMGrNWXLiwGw3HiFbozEB6DHGa3532SeG4wjfTqFYVX8TVLbz87Kb9zMvGbjwbafRpkWPmnETeVsXCFyiqDrxNvfw4jNnZPhwQiqtbCWbMsT6N7cLXWXVni8faCDFbtgES49PRwr4VCFXA4NgrqMT6HUnCSEb4U",
  "next_url": "https://<region>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/btc-usd/trades?continuation_token=9TlmYybkMWHnGLeD5csn9bShMGrNWXLiwGw3HiFbozEB6DHGa3532SeG4wjfTqFYVX8TVLbz87Kb9zMvGbjwbafRpkWPmnETeVsXCFyiqDrxNvfw4jNnZPhwQiqtbCWbMsT6N7cLXWXVni8faCDFbtgES49PRwr4VCFXA4NgrqMT6HUnCSEb
}
```

This endpoint retrieves trades for an asset instrument on a specific exchange. By default returns the 100 first trades in our dataset. Trades are sorted by time, ascendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://<region>.market-api.kaiko.io/v1/data/trades.v{trades_version}/exchanges/{exchange}/{instrument_class}/{instrument}/trades{?start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                 |
| ---                      | ---      | ---                                                                         |
| `continuation_token`     | No       | See [Pagination](#pagination).                                              |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                        |
| `exchange`               | Yes      | Exchange `code`. See [Exchanges Reference Data Endpoint](#exchanges).       |
| `instrument_class`       | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments). |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments). |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 100, default: 100, max: 10000).         |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                      |
| `trades_version`         | Yes      | Trade data version.                                                         |

*<sup>1</sup>: When paginating, these parameters are only included in the first request. For subsequent requests, they are encoded in the continuation token.*


## Recent Trades

> Request Example

```curl
curl "https://<region>.market-api.kaiko.io/v1/data/trades.v1/exchanges/gdax/spot/btc-usd/trades/recent"
    -H "x-api-key: <client-api-key>"
```


> Response Example

```json
{
    "query": {
        "trades_version": 1,
        "exchange": "cbse",
        "instrument_class": "spot",
        "instrument": "btc-usd"
    },
    "time": "2018-10-16T16:53:14.861Z",
    "timestamp": 1539708794861,
    "data": [
        {
            "timestamp": 1539708783156,
            "trade_id": "52529942",
            "price": "6410.09000000",
            "amount": "0.00745249",
            "taker_side_sell": false
        },
        {
            "timestamp": 1539708781993,
            "trade_id": "52529941",
            "price": "6410.08000000",
            "amount": "0.00650000",
            "taker_side_sell": true
        }
        // ...
    ],
    "result": "success"
}
```

This endpoint retrieves the most recent trades for an asset instrument on a specific exchange. By default returns the 100 most recent trades. This endpoint does not support pagination. Trades are sorted by time, descendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://<region>.market-api.kaiko.io/v1/data/trades.v{trades_version}/exchanges/{exchange}/{instrument_class}/{instrument}/trades/recent{?limit}`

### Parameters

| Parameter          | Required | Description                                                                 |
| ---                | ---      | ---                                                                         |
| `exchange`         | Yes      | Exchange `code`. See [Exchanges Reference Data Endpoint](#exchanges).       |
| `instrument_class` | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments). |
| `instrument`       | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments). |
| `limit`            | No       | Maximum number of results (min: 1, default: 100, max: 10000).               |
| `trades_version`   | Yes      | Trade data version.                                                         |

## Aggregations (OHLCV / VWAP)

> Request Example

```curl
curl "https://<region>.market-api.kaiko.io/v1/data/trades.v1/exchanges/gdax/spot/btc-usd/aggregations/ohlcv"
    -H "x-api-key: <client-api-key>"
```

> Response Example

```json
{
    "query": {
        "trades_version": 1,
        "page_size": 100,
        "exchange": "cbse",
        "instrument_class": "spot",
        "instrument": "btc-usd",
        "interval": "1d",
        "aggregation": "ohlcv",
        "request_time": "2018-10-16T16:59:40.825Z"
    },
    "time": "2018-10-16T16:59:40.926Z",
    "timestamp": 1539709180926,
    "data": [
        {
          "timestamp": 1417392000000,
          "open": "300.0",
          "high": "370.0",
          "low": "300.0",
          "close": "370.0",
          "volume": "0.05655554"
        },
        {
          "timestamp": 1417478400000,
          "open": "377.0",
          "high": "378.0",
          "low": "377.0",
          "close": "378.0",
          "volume": "15.0136"
        },
        // ...
    ],
    "result": "success",
    "continuation_token": "55QOlJ5fxEj2jkDj8BspExEwGYvRvVSdoqJ7n4XhFrhbbGNrFiEj76ia1aCTw9VT24Fw5txvzt7d4fCfgfZCAFtL8sZ9RP8gmJHyAJxvJauqzLm45tJ7rrcWRe9xTivEQWDTxGVYcZELSCnbhaBRJLGfSLrFdrm9DK2hjPe1WLH3oWmAnbuk95gV8D9xZpYkSKenGTHJb5ZT",
    "next_url": "https://<region>.market-api.kaiko.io/v1/data/trades.v1/exchanges/cbse/spot/btc-usd/aggregations/ohlcv?continuation_token=55QOlJ5fxEj2jkDj8BspExEwGYvRvVSdoqJ7n4XhFrhbbGNrFiEj76ia1aCTw9VT24Fw5txvzt7d4fCfgfZCAFtL8sZ9RP8gmJHyAJxvJauqzLm45tJ7rrcWRe9xTivEQWDTxGVYcZELSCnbhaBRJLGfSLrFdrm9DK2hjPe1WLH3oWmAnbuk95gV8D9xZpYkSKenGTHJb5ZT"
}
```

This endpoint retrieves aggregated history for an asset instrument on an exchange. Returns the earliest available result by default. The `interval` parameter is suffixed with `s`, `m`, `h` or `d` to specify seconds, minutes, hours or days, respectively. Values are sorted by time, ascendingly.

### HTTP request

`GET https://<region>.market-api.kaiko.io/v1/data/trades.v{trades_version}/exchanges/{exchange}/{instrument_class}/{instrument}/aggregations/{aggregation_type}{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                                |
| ---                      | ---      | ---                                                                                        |
| `aggregation_type`       | Yes      | Which [aggregation type](#aggregation-types) to get (currently supported: `ohlcv`,`vwap`). |
| `continuation_token`     | No       | See [Pagination](#pagination).                                                             |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                                       |
| `exchange`               | Yes      | Exchange `code`.                                                                           |
| `instrument_class`       | Yes      | Instrument class. See [Instruments Reference Data Endpoint](#instruments).                 |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).                |
| `interval`               | No       | [Interval](#intervals) period. Default `1d`.                                               |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 100, default: 100, max: 10000).                        |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                                     |
| `trades_version`         | Yes      | Trade data version.                                                                        |

*<sup>1</sup>: When paginating, these parameters are only included in the first request. For subsequent requests, they are encoded in the continuation token.*

### Aggregation types

| Aggregation | Fields                               |
| ---         | ---                                  |
| `ohlcv`     | `open`,`high`,`low`,`close`,`volume` |
| `vwap`      | `price`                              |

### Fields

| Field    | Description                    |
| ---      | ---                            |
| `close`  | Closing price of interval.     |
| `high`   | Highest price during interval. |
| `low`    | Lowest price during interval.  |
| `open`   | Opening price of interval.     |
| `volume` | Volume traded in interval.     |
| `price`  | [Volume-weighted average price](https://www.investopedia.com/terms/v/vwap.asp). |

### Intervals

The following intervals are currently supported: `1m`, `2m`, `3m`, `5m`, `10m`, `15m`, `30m`, `1h`, `2h`, `3h`, `4h`, `1d`.
