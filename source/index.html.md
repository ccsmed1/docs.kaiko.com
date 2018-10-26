---
title: Kaiko API Platform Reference
language\_tabs:
  - curl
toc\_footers:
  - <a href='https://www.kaiko.com/' target='_blank'>Kaiko</a>
  - <a href='https://www.kaiko.com/pages/contact' target='_blank'>Contact us</a>
search: true
---

# Introduction

Kaiko provides live and historical institutional quality market data for the digital assets. Our service retrieves and validates millions of trades each day from the world's leading cryptocurrency exchanges to deliver robust and reliable market data to financial institutions globally.

Kaiko currently provides two HTTP APIs:

* [Reference Data](#reference-data-api) (Public)
* [Market Data](#market-data-api) (Authenticated)

## Making Requests

When interacting with Kaiko HTTP APIs, you are expected to pass two headers:

* `Accept: application/json`: API responses will be in JSON format.
* `Accept-Encoding: gzip`: All our endpoints benefit from use of compression.

```
curl --compressed -H 'Accept: application/json' 'https://<api_hostname>/<endpoint>'
```

## Timestamps

### Input

All time parameters are in UTC and returned in the following ISO 8601 datetime format:

`YYYY-MM-DD`**T**`hh:mm:ss.sss`**Z**

For example:

`2017-12-17T13:35:24.351Z`

The "T" separates the date from the time. The trailing "Z" indicates UTC time.

### Output

All timestamps are returned as <a href="https://currentmillis.com/" target="_blank">millisecond Unix timestamps</a> (the number of milliseconds elapsed since 1970-01-01 00:00:00.000 UTC). For metadata fields, times are also returned in millisecond-resolution ISO 8601 datetime strings in the same format as input for convenience.

## Market open and close

Digital asset exchanges operate approximately 24x7x365.

For daily aggregated data, the opening price is calculated as the first trade at or after 00:00:00 UTC. The closing price is calculated as the last trade prior to 00:00:00 UTC.

# Reference Data API

<aside class="notice">
The Kaiko Reference Data API is currently in public beta. Endpoints, format and existing fields are stable but during the beta period we might introduce breaking changes in the data returned.
</aside>

## Endpoints

The base URL for the Reference Data Endpoints is: `https://reference-data-api.kaiko.io/`. Authentication is not required.

## Assets

> Request Example

```curl
curl --compressed -H 'Accept: application/json' 'https://reference-data-api.kaiko.io/v1/assets'
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
    /* ... */
  ]
}
```

This endpoint retrieves a list of supported assets.

### HTTP request

`GET https://reference-data-api.kaiko.io/v1/assets`

### Parameters

No parameters supported.

### Fields

| Field         | Description                    |
| ---           | ---                            |
| `code`        | Identifier for the asset.      |
| `name`        |                                |
| `asset_class` | `fiat`,`cryptocurrency`        |

<aside class="notice">
We use the most recent edition of <a href="https://www.iso.org/iso-4217-currency-codes.html" target="_blank">ISO 4217</a>, the international standard for currency codes, for fiat currency asset codes.
</aside>

## Exchanges

> Request Example

```curl
curl --compressed -H 'Accept: application/json' 'https://reference-data-api.kaiko.io/v1/exchanges'
```

> Response Example

```json

{
  "result": "success",
  "data": [
    {
      "code": "bfly",
      "name": "bitFlyer",
      "kaiko_legacy_slug": "bl"
    },
    {
      "code": "bfnx",
      "name": "Bitfinex",
      "kaiko_legacy_slug": "bf"
    }
    /* ... */
  ]
}
```

This endpoint retrieves a list of supported exchanges.

### HTTP request

`GET https://reference-data-api.kaiko.io/v1/exchanges`

### Parameters

No parameters supported.

### Fields

| Field               | Description                                                   |
| ---                 | ---                                                           |
| `code`              | Identifier for the exchange.                                  |
| `name`              |                                                               |
| `kaiko_legacy_slug` | Identifier used in past deliveries of historical market data. |

## Instruments

> Request Example

```curl
curl --compressed -H 'Accept: application/json' 'https://reference-data-api.kaiko.io/v1/instruments'
```

> Response Example

```json
{
  "result": "success",
  "data": [
    {
      "exchange_code": "bfnx",
      "class": "spot",
      "code": "xmr-btc",
      "base_asset": "xmr",
      "quote_asset": "btc",
      "kaiko_legacy_exchange_slug": "bf",
      "kaiko_legacy_symbol": "xmrbtc",
      "exchange_pair_code": "xmrbtc",
      "trade_start_time": "2017-08-09T23:36:33.0000000Z",
      "trade_start_timestamp": 1502321793000,
      "trade_end_time": null,
      "trade_end_timestamp": null,
      "trade_count": 1669022,
      "trade_compressed_size": 22107372
    },
    {
      "exchange_code": "krkn",
      "class": "spot",
      "code": "gno-eth",
      "base_asset": "gno",
      "quote_asset": "eth",
      "kaiko_legacy_exchange_slug": "kk",
      "kaiko_legacy_symbol": "gnoeth",
      "exchange_pair_code": "GNOETH",
      "trade_start_time": "2017-08-08T20:10:04.0000000Z",
      "trade_start_timestamp": 1502223004345,
      "trade_end_time": null,
      "trade_end_timestamp": null,
      "trade_count": 230316,
      "trade_compressed_size": 11588434
    },
    {
      "exchange_code": "krkn",
      "class": "spot",
      "code": "dao-btc",
      "base_asset": "dao",
      "quote_asset": "btc",
      "kaiko_legacy_exchange_slug": "kk",
      "kaiko_legacy_symbol": "daobtc",
      "exchange_pair_code": "xdaoxxbt",
      "trade_start_time": "2016-05-28T10:20:40.0000000Z",
      "trade_start_timestamp": 1464430840433,
      "trade_end_time": "2016-12-18T02:47:47.0000000Z",
      "trade_end_timestamp": 1482029267877,
      "trade_count": 67925,
      "trade_compressed_size": 4194980
    },
    /* ... */
  ]
}
```

This endpoint retrieves a list of supported instruments. There are three possible cases regarding the trading period:

* Trading has started and new trading activity is still being consumed (start time fields will be set, but end time fields will be `null`)
* Trading has been recorded but no recent activity has been seen (both start and end time fields are set)
* No trading has been registered yet (both start and end time fields are `null`)

### HTTP request

`GET https://reference-data-api.kaiko.io/v1/instruments`

### Parameters

No parameters supported.

### Fields

| Field               | Description                                                                            |
| ---                 | ---                                                                                    |
| `exchange_code` | [Exchange](#exchanges) `code`.                                                             |
| `class` | `spot`|`future` |
| `code`<sup>2</sup> | Kaiko identifier for the instrument. Always `base_asset-quote_asset` for `spot` instruments. |
| `base_asset`<sup>1</sup> | <a href="https://www.investopedia.com/terms/b/basecurrency.asp" target="_blank">Base asset</a>.                                                              |
| `quote_asset`<sup>1</sup> | <a href="https://www.investopedia.com/terms/q/quotecurrency.asp" target="_blank">Quote asset</a>.                                                              |
| `kaiko_legacy_exchange_slug` | [Exchange](#exchanges) `kaiko_legacy_slug`. |
| `kaiko_legacy_symbol` | Identifier used in past deliveries of historical market data and Data Feed. |
| `exchange_pair_code`<sup>2</sup> | Identifier for the instrument used by the exchange. |
| `trade_start_time` | [Time](#timestamps) of first available trade in Kaiko's data set. |
| `trade_start_timestamp` | [Timestamp](#timestamps) of first available trade in Kaiko's data set. |
| `trade_end_time` | [Time](#timestamps) of last available trade in Kaiko's data set. `null` if trades  |
| `trade_end_timestamp` | [Timestamp](#timestamps) of first available trade in Kaiko's data set. |
| `trade_count` | Total number of trades available through Kaiko Market Data API and Data Feed. For active pairs, this is an approximation. |
| `trade_compressed_size` | Approximate size in bytes of all available trades in Kaiko Data Feed. |

*<sup>1</sup>: Some exchanges may refer to base and quote currencies differently. Kaiko denotes prices in units of quote and volume in units of base, as reported by exchanges. *
*<sup>2</sup>: Some exchanges reverse the ordering of base/quote in their codes. *

# Market Data API

<aside class="notice">
The Kaiko Market Data API is currently in private beta. Endpoints, format and existing fields are stable but during the beta period we might introduce breaking changes in the data returned.
</aside>

## Endpoints

The base URL for the Market Data Endpoints is regionalized. We are currently offering endpoints in the US and in Europe:

* `https://us-beta.market-api.kaiko.io/`
* `https://eu-beta.market-api.kaiko.io/`

## Usage

### Authentication

> Request Syntax

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<api_hostname>/<endpoint>'
```

Each API lives under its own hostname. Clients must include an API key in the header of every request they make. The format is as follows:

`X-Api-Key: <client-api-key>`

<aside class="notice">
You must replace <code>&lt;client-api-key&gt;</code> with your assigned API key.
</aside>

### Rate limiting

Query limits are based on your API key. Currently, each API key is allowed a maximum of 1000 requests per minute and 10000 requests per hour.

### Data versioning

Kaiko takes transparency and accountability very seriously. Therefore, our provided datasets are versioned. Dataset versioning is orthogonal to API versioning. Any potential breaking changes in results (e.g. semantical changes or corrections of historically incorrect data) will result in a new dataset version - no corrections or adjustments will be done in the dark. Addition of new data will not result in a new dataset version. Data is versioned on a per-base-data level.

The versioning is selected by selecting a base data set and a version. All current Market Data API endpoints take the `commodity` and `data_version` parameters.

By setting this to `latest`, you will get the most recent version. The returned version is always included in the `query` field and can be referred to if you would ever need to compare results, should we ever need to adjust historical data. [Paginating](#pagination) over a request with version set to `latest` will preserve the current version across subsequent pagination requests.

We recommend using the most current version explicitly in production integrations as the `latest` label might move at any time to a breaking change. For the `trades` commodity the latest version is currently `v1`


### Envelope

> Response Example

```json
{
  "result": "success",
  "time": "2018-06-14T17:19:40.303Z",
  "timestamp": 1528996780303,
  "query": { /* ... */ },
  "data": [ /* ... */ ]
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
  "next_url": "https://<eu-beta|us-beta>.market-api.kaiko.io/v1/trades.v1/exchanges/bfnx/spot/btc-usd/trades?continuation_token=ab25lIG1vcmUgYmVlciBpcyBvbmUgbW9yZSBiZWVyIHRvbyBtYW55"
}

```

For queries that result in a larger dataset than can be returned in a single response, a `continuation_token` field is included. Calling the same endpoint again with the `continuation_token` query parameter added will return the next result page. For convenience, a `next_url` field is also included, containing a URL that can be called directly to get the next page. Paginated endpoints also takes a `page_size` parameter that specifies the maximum number of items that should be included in each response. Only the first call should include `page_size`, all subsequent calls should only use `continuation_token`. Paginating over a request with [version](#data-versioning) set to `latest` will preserve the current version across subsequent pagination requests.

#### Parameters

| Parameter            | Required | Description                                          |
| ---                  | ---      | ---                                                  |
| `continuation_token` | No       |                                                      |
| `page_size`          | No       | Maximum  number of records to return in one response |

### Errors

All API responses are in JSON format. A `result` field, with a value of `success` or `error` is returned with each request. In the event of an error, a `message` field will provide an error message.

#### HTTP error codes

The Kaiko platform API uses the following error codes:

| Error Code | Meaning                                                                                                                                                                         |
| ---------- | -------                                                                                                                                                                         |
| 400        | Bad Request                                                                                                                                                                     |
| 401        | Unauthorized -- You are not authenticated properly. See [Authentication](#authentication).                                                                                      |
| 403        | Forbidden -- You don't have access to the requested resource.                                                                                                                   |
| 404        | Not Found                                                                                                                                                                       |
| 405        | Method Not Allowed                                                                                                                                                              |
| 406        | Not Acceptable                                                                                                                                                                  |
| 429        | Too Many Requests -- [Rate limit](#rate-limiting) exceeded. <a href='https://www.kaiko.com/pages/contact' target="_blank">Contact us</a> if you think you have a need for more. |
| 500        | Internal Server Error -- We had a problem with our service. Try again later.                                                                                                    |
| 503        | Service Unavailable -- We're temporarily offline for maintenance.                                                                                                               |

## Historical Trades

> Request Example

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/btc-usd/trades'
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
    /* ... */
  ],
  "query": {
    "commodity": "trades",
    "data_version": "v1",
    "page_size": 100,
    "exchange": "bfnx",
    "instrument_class": "spot",
    "instrument": "btc-usd",
    "request_time": "2018-06-14T17:37:21.935Z"
  },
  "continuation_token": "9TlmYybkMWHnGLeD5csn9bShMGrNWXLiwGw3HiFbozEB6DHGa3532SeG4wjfTqFYVX8TVLbz87Kb9zMvGbjwbafRpkWPmnETeVsXCFyiqDrxNvfw4jNnZPhwQiqtbCWbMsT6N7cLXWXVni8faCDFbtgES49PRwr4VCFXA4NgrqMT6HUnCSEb4U",
  "next_url": "https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/btc-usd/trades?continuation_token=9TlmYybkMWHnGLeD5csn9bShMGrNWXLiwGw3HiFbozEB6DHGa3532SeG4wjfTqFYVX8TVLbz87Kb9zMvGbjwbafRpkWPmnETeVsXCFyiqDrxNvfw4jNnZPhwQiqtbCWbMsT6N7cLXWXVni8faCDFbtgES49PRwr4VCFXA4NgrqMT6HUnCSEb
}
```

This endpoint retrieves trades for an instrument on a specific exchange. By default returns the 100 first trades in our dataset. Trades are sorted by time, ascendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/{commodity}.{data_version}/exchanges/{exchange}/{instrument_class}/{instrument}/trades{?start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                  |
| ---                      | ---      | ---                                                                          |
| `continuation_token`     | No       | See [Pagination](#pagination).                                               |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                         |
| `exchange`               | Yes      | Exchange `code`. See [Exchanges Reference Data Endpoint](#exchanges).        |
| `instrument_class`       | Yes      | Instrument `class`. See [Instruments Reference Data Endpoint](#instruments). |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).  |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 1, default: 100, max: 100000).           |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                       |
| `commodity`              | Yes      | The data commodity.                                                          |
| `data_version`           | Yes      | The data version. (v1, v2 ... or latest)                                     |


*<sup>1</sup>: When paginating, these parameters should only be included in the first request. For subsequent requests, they are encoded in the continuation token.*

## Recent Trades

> Request Example

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/krkn/spot/eth-eur/trades/recent'
```

> Response Example

```json
{
  "query": {
    "commodity": "trades",
    "data_version": "v1",
    "exchange": "krkn",
    "instrument_class": "spot",
    "instrument": "eth-eur",
    "limit": 100
  },
  "time": "2018-10-17T13:08:31.059Z",
  "timestamp": 1539781711059,
  "data": [
    {
      "timestamp": 1539781665641,
      "trade_id": "1a1e635ee192480354126a8f58c64cf63f2ac3a18f12f5988aee87175f627721",
      "price": "176.37000",
      "amount": "0.23696093",
      "taker_side_sell": true
    },
    {
      "timestamp": 1539781626679,
      "trade_id": "4293c3f923fbe8b7b315f9c167f9c5e355cc1d00663a6d5bc9ac0358b086f404",
      "price": "176.37000",
      "amount": "0.23354822",
      "taker_side_sell": true
    },
    /* ... */
  ],
  "result": "success"
}

```

This endpoint retrieves the most recent trades for an instrument on a specific exchange. By default returns the 100 most recent trades. This endpoint does not support pagination. Trades are sorted by time, descendingly. Note that `taker_side_sell` can be null in the cases where this information was not available at collection.

### HTTP request

`GET https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/{commodity}.{data_version}/exchanges/{exchange}/{instrument_class}/{instrument}/trades/recent{?limit}`

### Parameters

| Parameter          | Required | Description                                                                  |
| ---                | ---      | ---                                                                          |
| `exchange`         | Yes      | Exchange `code`. See [Exchanges Reference Data Endpoint](#exchanges).        |
| `instrument_class` | Yes      | Instrument `class`. See [Instruments Reference Data Endpoint](#instruments). |
| `instrument`       | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).  |
| `limit`            | No       | Maximum number of results (min: 1, default: 100, max: 10000).                |
| `commodity`        | Yes      | The data commodity.                                                          |
| `data_version`     | Yes      | The data version. (v1, v2 ... or latest)                                     |


## OHLCV (Candles)

> Request Example

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/cbse/spot/btc-usd/aggregations/ohlcv'
```

> Response Example

```json
{
  "query": {
    "commodity": "trades",
    "data_version": "v1",
    "page_size": 100,
    "exchange": "bfnx",
    "instrument_class": "spot",
    "instrument": "xmr-usd",
    "interval": "1d",
    "aggregation": "ohlcv",
    "request_time": "2018-10-17T13:11:00.639Z"
  },
  "time": "2018-10-17T13:11:00.846Z",
  "timestamp": 1539781860846,
  "data": [
    {
      "timestamp": 1502236800000,
      "open": "50.234",
      "high": "51.28",
      "low": "48.738",
      "close": "50.933",
      "volume": "1318.12560081"
    },
    {
      "timestamp": 1502323200000,
      "open": "51.066",
      "high": "51.304",
      "low": "49.183",
      "close": "49.183",
      "volume": "9085.47277432"
    },
    /* ... */
  ],
  "result": "success",
  "continuation_token": "55QOpMjUTsSBQxZgCLKKvfkh8FcejpPWuA8s23ojTM4j32BQrAWtLFFcTzcRquQYfqtXHGL5CDA9FVkoisYPPprZYz5rxPUuKzjwK6h8oNcGJvZjXWJimSZLZhFd7F8sq5cRyrysJ36C9M9z57mhDKfQVSRsZKEbkw3Vmngsb5smqBxfHUzkdkS11WNnqnS4yRcJ5Sq9JMAX",
  "next_url": "https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/xmr-usd/aggregations/ohlcv?continuation_token=55QOpMjUTsSBQxZgCLKKvfkh8FcejpPWuA8s23ojTM4j32BQrAWtLFFcTzcRquQYfqtXHGL5CDA9FVkoisYPPprZYz5rxPUuKzjwK6h8oNcGJvZjXWJimSZLZhFd7F8sq5cRyrysJ36C9M9z57mhDKfQVSRsZKEbkw3Vmngsb5smqBxfHUzkdkS11WNnqnS4yRcJ5Sq9JMAX"
}

```

This endpoint retrieves aggregated history for an instrument on an exchange. Returns the earliest available intervals by default. The `interval` parameter is suffixed with `s`, `m`, `h` or `d` to specify seconds, minutes, hours or days, respectively. Values are sorted by time, ascendingly.

### HTTP request

`GET https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/{commodity}.{data_version}/exchanges/{exchange}/{instrument_class}/{instrument}/aggregations/ohlcv{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                   |
| ---                      | ---      | ---                                                                           |
| `continuation_token`     | No       | See [Pagination](#pagination).                                                |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                          |
| `exchange`               | Yes      | Exchange `code`.                                                              |
| `instrument_class`       | Yes      | Instrument `class`. See [Instruments Reference Data Endpoint](#instruments).  |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).   |
| `interval`               | No       | [Interval](#intervals) period. Default `1d`.                                  |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 1, default: 100, max: 100000).            |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                        |
| `commodity`              | Yes      | The data commodity.                                                           |
| `data_version`           | Yes      | The data version. (v1, v2 ... or latest)                                      |

*<sup>1</sup>: When paginating, these parameters should only be included in the first request. For subsequent requests, they are encoded in the continuation token.*

### Fields

| Field    | Description                    |
| ---      | ---                            |
| `open`   | Opening price of interval.     |
| `high`   | Highest price during interval. |
| `low`    | Lowest price during interval.  |
| `close`  | Closing price of interval.     |
| `volume` | Volume traded in interval.     |

### Intervals

The following intervals are currently supported: `1m`, `2m`, `3m`, `5m`, `10m`, `15m`, `30m`, `1h`, `2h`, `3h`, `4h`, `1d`.

## VWAP (Prices)

> Request Example

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/cbse/spot/btc-usd/aggregations/vwap'
```

> Response Example

```json
{
  "query": {
    "commodity": "trades",
    "data_version": "v1",
    "page_size": 100,
    "exchange": "cbse",
    "instrument_class": "spot",
    "instrument": "btc-usd",
    "interval": "1d",
    "aggregation": "vwap",
    "request_time": "2018-10-17T12:39:58.365Z"
  },
  "time": "2018-10-17T12:39:58.542Z",
  "timestamp": 1539779998542,
  "data": [
    {
      "timestamp": 1417392000000,
      "price": "345.24557275909663315035096473307477923471334550072"
    },
    {
      "timestamp": 1417478400000,
      "price": "377.99517104491927319230564288378536793307401289498"
    },
    /* ... */
  ],
  "result": "success",
  "continuation_token": "55qoNvASfrVdCIjrF8Ygw6TVJ4yamzUyeL9QXAmvWZZur3iaKoPcVBW1V4unNJi2zMjojbsYr9Pgt9XFCUpnAiuBiECm8X4cedvYc9t2WxHXnHKjgAp2wRAeV8ZPUSj8WNgpWTCBVymGaQZPj3oMDZwVeCPyuTLFdVPfTXVjZA94BtHeBmghoPv92JtWxN3yRvCkrw79hJBu",
  "next_url": "https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/cbse/spot/btc-usd/aggregations/vwap?continuation_token=55qoNvASfrVdCIjrF8Ygw6TVJ4yamzUyeL9QXAmvWZZur3iaKoPcVBW1V4unNJi2zMjojbsYr9Pgt9XFCUpnAiuBiECm8X4cedvYc9t2WxHXnHKjgAp2wRAeV8ZPUSj8WNgpWTCBVymGaQZPj3oMDZwVeCPyuTLFdVPfTXVjZA94BtHeBmghoPv92JtWxN3yRvCkrw79hJBu"
}

```

This endpoint retrieves aggregated price history for an instrument on an exchange. Returns the earliest available intervals by default. The `interval` parameter is suffixed with `s`, `m`, `h` or `d` to specify seconds, minutes, hours or days, respectively. Values are sorted by time, ascendingly.

### HTTP request

`GET https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/{commodity}.{data_version}/exchanges/{exchange}/{instrument_class}/{instrument}/aggregations/vwap{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                                |
| ---                      | ---      | ---                                                                                        |
| `continuation_token`     | No       | See [Pagination](#pagination).                                                             |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                                       |
| `exchange`               | Yes      | Exchange `code`.                                                                           |
| `instrument_class`       | Yes      | Instrument `class`. See [Instruments Reference Data Endpoint](#instruments).               |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).                |
| `interval`               | No       | [Interval](#intervals) period. Default `1d`.                                               |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 1, default: 100, max: 100000).                         |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                                     |
| `commodity`              | Yes      | The data commodity. (`trades`)                                                             |
| `data_version`           | Yes      | The data version. (`v1`, `v2` ... or `latest`)                                             |

*<sup>1</sup>: When paginating, these parameters should only be included in the first request. For subsequent requests, they are encoded in the continuation token.*

### Fields

| Field    | Description                                                                     |
| ---      | ---                                                                             |
| `price`  | <a href="https://www.investopedia.com/terms/v/vwap.asp" target="_blank">Volume-weighted average price</a>. |

### Intervals

The following intervals are currently supported: `1m`, `2m`, `3m`, `5m`, `10m`, `15m`, `30m`, `1h`, `2h`, `3h`, `4h`, `1d`.


## COUNT OHLCV VWAP

> Request Example

```curl
curl --compressed -H 'Accept: application/json' -H 'X-Api-Key: <client-api-key>' \
  'https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/cbse/spot/btc-usd/aggregations/count_ohlcv_vwap'
```

> Response Example

```json
{
  "query": {
    "commodity": "trades",
    "data_version": "v1",
    "page_size": 100,
    "exchange": "bfnx",
    "instrument_class": "spot",
    "instrument": "xmr-usd",
    "interval": "1d",
    "aggregation": "count_ohlcv_vwap",
    "request_time": "2018-10-17T13:11:00.639Z"
  },
  "time": "2018-10-17T13:11:00.846Z",
  "timestamp": 1539781860846,
  "data": [
    {
      "timestamp": 1502236800000,
      "trade_count": 4313113,
      "open": "50.234",
      "high": "51.28",
      "low": "48.738",
      "close": "50.933",
      "volume": "1318.12560081",
      "price": "345.24557275909663315035096473307477923471334550072"
    },
    {
      "timestamp": 1502323200000,
      "trade_count": 4613353,
      "open": "51.066",
      "high": "51.304",
      "low": "49.183",
      "close": "49.183",
      "volume": "9085.47277432",
      "price": "377.99517104491927319230564288378536793307401289498"
    },
    /* ... */
  ],
  "result": "success",
  "continuation_token": "55QOpMjUTsSBQxZgCLKKvfkh8FcejpPWuA8s23ojTM4j32BQrAWtLFFcTzcRquQYfqtXHGL5CDA9FVkoisYPPprZYz5rxPUuKzjwK6h8oNcGJvZjXWJimSZLZhFd7F8sq5cRyrysJ36C9M9z57mhDKfQVSRsZKEbkw3Vmngsb5smqBxfHUzkdkS11WNnqnS4yRcJ5Sq9JMAX",
  "next_url": "https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/trades.v1/exchanges/bfnx/spot/xmr-usd/aggregations/count_ohlcv_vwap?continuation_token=55QOpMjUTsSBQxZgCLKKvfkh8FcejpPWuA8s23ojTM4j32BQrAWtLFFcTzcRquQYfqtXHGL5CDA9FVkoisYPPprZYz5rxPUuKzjwK6h8oNcGJvZjXWJimSZLZhFd7F8sq5cRyrysJ36C9M9z57mhDKfQVSRsZKEbkw3Vmngsb5smqBxfHUzkdkS11WNnqnS4yRcJ5Sq9JMAX"
}

```

This endpoint retrieves aggregated history for an instrument on an exchange. Returns the earliest available intervals by default. The `interval` parameter is suffixed with `s`, `m`, `h` or `d` to specify seconds, minutes, hours or days, respectively. Values are sorted by time, ascendingly.

### HTTP request

`GET https://<eu-beta|us-beta>.market-api.kaiko.io/v1/data/{commodity}.{data_version}/exchanges/{exchange}/{instrument_class}/{instrument}/aggregations/count_ohlcv_vwap{?interval,start_time,end_time,page_size,continuation_token}`

### Parameters

| Parameter                | Required | Description                                                                   |
| ---                      | ---      | ---                                                                           |
| `continuation_token`     | No       | See [Pagination](#pagination).                                                |
| `end_time`<sup>1</sup>   | No       | Ending time in ISO 8601 (exclusive).                                          |
| `exchange`               | Yes      | Exchange `code`.                                                              |
| `instrument_class`       | Yes      | Instrument `class`. See [Instruments Reference Data Endpoint](#instruments).  |
| `instrument`             | Yes      | Instrument `code`. See [Instruments Reference Data Endpoint](#instruments).   |
| `interval`               | No       | [Interval](#intervals) period. Default `1d`.                                  |
| `page_size`<sup>1</sup>  | No       | See [Pagination](#pagination) (min: 1, default: 100, max: 100000).            |
| `start_time`<sup>1</sup> | No       | Starting time in ISO 8601 (inclusive).                                        |
| `commodity`              | Yes      | The data commodity.                                                           |
| `data_version`           | Yes      | The data version. (v1, v2 ... or latest)                                      |

*<sup>1</sup>: When paginating, these parameters should only be included in the first request. For subsequent requests, they are encoded in the continuation token.*

### Fields

| Field          | Description                    |
| ---            | ---                            |
| `trade_count`  | Then number of trades.         |
| `open`         | Opening price of interval.     |
| `high`         | Highest price during interval. |
| `low`          | Lowest price during interval.  |
| `close`        | Closing price of interval.     |
| `volume`       | Volume traded in interval.     |

### Intervals

The following intervals are currently supported: `1m`, `2m`, `3m`, `5m`, `10m`, `15m`, `30m`, `1h`, `2h`, `3h`, `4h`, `1d`.

# Data Feed

Receive historical and on-going [data](https://www.kaiko.com/collections/datafeed) directly to your cloud provider. If you purchased a monthly subscription of Trade Data, 10% Order Books, OHLCV or VWAP, your data will be delivered once a day to your cloud bucket. We support Amazon Web Services S3, Google storage, Azure blob storage, and other providers. Cloud storage services allow us to easily synchronize our data with you once a day.

Cloud providers offer extensive storage services that will help you store large amounts of data. This eases the integration setup to feed whatever system you choose to integrate the data with.

If you do not already have a cloud provider, we suggest working with Amazon Web Services which is a major provider with a strong track record. 

## How to receive our data through AWS S3

1. Open [https://s3.console.aws.amazon.com/s3/buckets/](https://s3.console.aws.amazon.com/s3/buckets/)
2. Create a new bucket in the region of your choice. We suggest calling the bucket **kaiko-delivery-nameofyourcompany**
3. We suggest you use the us-east-1 region unless you already are using a different region as your main presence
4. Leave the properties on the default setting
5. On the **Set permissions** tab press **Add account** and use the following id: **4d6be087cf0b9ee7af2f8d8c51469c81bc711e68ee9c6be386aee2322abc8175**
6. Check all the checkboxes for permissions and press **Save**
7. Ensure that the permissions dialog resembles the following: ![AWS Dialog](/images/S3_Management_Console_large.png)
8. Enter the details into [this form](https://goo.gl/forms/JRJeXU6X0ZBrfgrD2)
9. You should receive a confirmation email within a few working days confirming that the integration was set up correctly

## For other cloud providers

Please contact us at [hello@kaiko.com](mailto:hello@kaiko.com).

# Future development

We are continously extending the feature set across all our products. We are very happy to receive your feedback on our services and documentation. Do you have a proposal on how we can make your day better? <a href='https://www.kaiko.com/pages/contact' target='_blank'>Give us a shout</a>! :)

<div style="margin: 200px">
</div>
