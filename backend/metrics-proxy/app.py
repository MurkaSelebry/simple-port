from flask import Flask, Response
import requests
import re

app = Flask(__name__)

API_URL = "http://corporate-api:6500"

@app.route('/metrics')
def proxy_metrics():
    """Proxy metrics from the API, filtering out problematic lines"""
    try:
        response = requests.get(f"{API_URL}/metrics", timeout=10)
        
        if response.status_code != 200:
            return Response("# Error: Unable to fetch metrics from API\n", 
                          mimetype='text/plain'), 500
        
        # Filter out problematic metric lines
        lines = response.text.split('\n')
        filtered_lines = []
        
        skip_next = False
        for line in lines:
            # Skip lines with invalid metric names (containing spaces in TYPE/UNIT/HELP)
            if skip_next:
                skip_next = False
                continue
                
            # Skip TYPE lines with spaces in metric names
            if line.startswith('# TYPE') and (' HTTP requests' in line or ' request duration' in line):
                skip_next = True  # Also skip the next UNIT/HELP line
                continue
                
            # Skip UNIT lines with spaces in metric names
            if line.startswith('# UNIT') and (' HTTP requests' in line or ' request duration' in line):
                continue
                
            # Skip HELP lines with spaces in metric names
            if line.startswith('# HELP') and (' HTTP requests' in line or ' request duration' in line):
                continue
                
            # Skip actual metric lines with invalid names
            if re.match(r'^http_requests_total_.*|^http_request_duration_seconds_.*|^database_queries.*|^errors_total.*', line):
                continue
                
            filtered_lines.append(line)
        
        filtered_content = '\n'.join(filtered_lines)
        
        return Response(filtered_content, mimetype='text/plain')
        
    except Exception as e:
        return Response(f"# Error: {str(e)}\n", mimetype='text/plain'), 500

@app.route('/health')
def health():
    """Health check endpoint"""
    return {"status": "healthy"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8090, debug=True) 