# List available targets
default:
    @just --list


# =============================================================================
# Development Servers
# =============================================================================

## Start uvicorn development server (port 8111)
serve:
    uv run uvicorn main:app --port 8111 --log-level warning & echo $! > server.pid

## Start gunicorn production server (port 8222)
serve-gunicorn:
    uv run gunicorn -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:8222 --log-level critical --daemon --pid gunicorn.pid
    


## Stop uvicorn development server
serve-stop:
    kill $(cat server.pid) && rm server.pid

## Stop gunicorn production server
stop-gunicorn:
    kill $(cat gunicorn.pid) && rm gunicorn.pid

## Start litestar development server in background (port 8444)
serve-litestar:
    nohup uv run uvicorn app:app --port 8444 --no-access-log --log-level warning > litestar.log 2>&1 & echo $! > litestar.pid

## Stop litestar development server
stop-litestar:
    kill $(cat litestar.pid) && rm litestar.pid

# =============================================================================
# Benchmarks
# =============================================================================

## Benchmark Python uvicorn server (10k requests, 10 concurrency)
bench-python-unit:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/items

## Benchmark Python gunicorn server (10k requests, 10 concurrency)
bench-python-gunicorn:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8222/items

## Benchmark Python uvicorn server (10k requests, 10 concurrency)
bench-python-uvicorn:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8111/items

## Benchmark Python uvicorn server (10k requests, 10 concurrency)
bench-litestar-uvicorn:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8444/items

## Benchmark Litestar unit server (10k requests, 10 concurrency)
bench-litestar-unit:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/litestar/items

## Benchmark Go Unit server (10k requests, 10 concurrency)
bench-go-unit:
    hey -n 10000 -c 10 -m POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/go/items


# =============================================================================
# Testing
# =============================================================================

## Test Python uvicorn endpoint with curl
test-python-curl:
    curl -X POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8111/items

## Test Unit nginx endpoint with curl
test-unit-curl:
    curl -X POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/items

## Test Litestar Unit nginx endpoint with curl
test-unit-litestar-curl:
    curl -X POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/litestar/items

## Test Go Unit endpoint with curl
test-go-curl:
    curl -X POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8333/go/items

## Test Litestar + Uvicorn with curl
test-litestar-curl:
    curl -X POST -H "Content-Type: application/json" -d '{"name": "Test Item", "price": 9.99}' http://localhost:8444/items


# =============================================================================
# Unit Configuration
# =============================================================================

## Check if GIL is disabled in Python
check-gil:
    uv run python -c "import sys; print(f'GIL Disabled: {not sys._is_gil_enabled()}')"

## Update Unit nginx configuration
unit-config:
    sudo curl -X PUT --data-binary @config.json --unix-socket /run/unit/control.sock http://localhost/config/

## Get current Unit nginx configuration
get-unit-config:
    sudo curl -s --unix-socket /run/unit/control.sock http://localhost/config/
