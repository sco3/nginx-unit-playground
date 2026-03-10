# Free Thread Web Benchmarks

Benchmark results comparing different server configurations for handling HTTP POST requests.

## Test Configuration

- **Requests:** 10,000 per benchmark
- **Concurrency:** 10 simultaneous connections
- **Endpoint:** POST `/items` with JSON payload `{"name": "Test Item", "price": 9.99}`
- **Tool:** [`hey`](https://github.com/rakyll/hey) load generator

## Results Summary

| Server | Requests/sec | Avg Latency | P50 Latency | P99 Latency | Total Time |
|--------|-------------:|------------:|------------:|------------:|------------:|-----------:|
| **Go Unit** | 43,230.28 | 0.0002s | 0.0002s | 0.0007s | 0.2313s |
| **Python Unit** | 14,799.43 | 0.0007s | 0.0006s | 0.0017s | 0.6757s |
| **Litestar + Uvicorn** | 7,006.27 | 0.0014s | 0.0014s | 0.0021s | 1.4273s |
| **FastAPI + Uvicorn** | 6,069.20 | 0.0016s | 0.0016s | 0.0020s | 1.6477s |
| **FastAPI + Gunicorn** | 5,994.52 | 0.0017s | 0.0016s | 0.0021s | 1.6682s |

## Performance Comparison

### Throughput (Requests/sec)
```
Go Unit              █████████████████████████████████████████████ 43,230 req/s
Python Unit          ███████████████ 14,799 req/s
Litestar + Uvicorn   ███████ 7,006 req/s
FastAPI + Uvicorn    ██████ 6,069 req/s
FastAPI + Gunicorn   ██████ 5,995 req/s
```

### Key Findings

1. **Go Unit** is the fastest, handling **2.9x more requests** than Python Unit and **7.2x more** than FastAPI + Gunicorn
2. **Python Unit** (free-threaded) performs **2.4x better** than FastAPI + Uvicorn
3. **Litestar + Uvicorn** performs **15.5% better** than FastAPI + Uvicorn
4. **FastAPI + Uvicorn** and **FastAPI + Gunicorn** have similar performance, with Uvicorn slightly ahead

## Detailed Results

### Go Unit Server
- **Endpoint:** `http://localhost:8333/go/items`
- **Total:** 0.2313 secs
- **Fastest:** 0.0000 secs | **Slowest:** 0.0039 secs
- **Status:** 10,000 × 200 responses

### Python Unit Server
- **Endpoint:** `http://localhost:8333/items`
- **Total:** 0.6757 secs
- **Fastest:** 0.0001 secs | **Slowest:** 0.0033 secs
- **Status:** 10,000 × 200 responses

### Litestar + Uvicorn Server
- **Endpoint:** `http://localhost:8444/items`
- **Total:** 1.4273 secs
- **Fastest:** 0.0010 secs | **Slowest:** 0.0044 secs
- **Status:** 10,000 × 201 responses

### FastAPI + Uvicorn Server
- **Endpoint:** `http://localhost:8111/items`
- **Total:** 1.6477 secs
- **Fastest:** 0.0010 secs | **Slowest:** 0.0045 secs
- **Status:** 10,000 × 200 responses

### FastAPI + Gunicorn Server
- **Endpoint:** `http://localhost:8222/items`
- **Total:** 1.6682 secs
- **Fastest:** 0.0012 secs | **Slowest:** 0.0050 secs
- **Status:** 10,000 × 200 responses

## Running Benchmarks

```bash
# Run all benchmarks
just bench-go-unit
just bench-python-unit
just bench-litestar-uvicorn
just bench-fastapi-uvicorn
just bench-fastapi-gunicorn
```

## Server Setup

```bash
# Start FastAPI + uvicorn server
uv run uvicorn main:app --port 8111

# Start Litestar + uvicorn server
uv run uvicorn app:app --port 8444 --no-access-log --log-level warning

# Start FastAPI + gunicorn server
uv run gunicorn -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:8222 --daemon

# Start Unit nginx (requires unit service)
sudo curl -X PUT --data-binary @config.json --unix-socket /run/unit/control.sock http://localhost/config/
```
