#!/bin/bash

# Load testing script for Corporate Portal API

# Default values
RPS=10
DURATION=30
URL="http://localhost:5000"
ENDPOINT="/api/orders"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --rps)
      RPS="$2"
      shift 2
      ;;
    --duration)
      DURATION="$2"
      shift 2
      ;;
    --url)
      URL="$2"
      shift 2
      ;;
    --endpoint)
      ENDPOINT="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --rps RPS           Requests per second (default: 10)"
      echo "  --duration SECONDS  Test duration in seconds (default: 30)"
      echo "  --url URL           Target URL (default: http://localhost:5000)"
      echo "  --endpoint PATH     Target endpoint (default: /api/orders)"
      echo "  --help              Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

echo "Starting load test with parameters:"
echo "  RPS: $RPS"
echo "  Duration: $DURATION seconds"
echo "  Target: $URL$ENDPOINT"
echo ""

# Check if .NET is available
if ! command -v dotnet &> /dev/null; then
    echo "Error: .NET is not installed or not in PATH"
    exit 1
fi

# Run the load test
echo "Running load test..."
dotnet run --project Scripts/LoadTest -- --rps $RPS --duration $DURATION --url $URL --endpoint $ENDPOINT

echo ""
echo "Load test completed!" 