from flask import Flask, render_template, request, jsonify
import requests
import threading
import time
import json
from datetime import datetime
import os

app = Flask(__name__)

# Configuration
API_BASE_URL = os.getenv('API_BASE_URL', 'http://localhost:5000')
TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN', 'YOUR_BOT_TOKEN')
TELEGRAM_CHANNEL_ID = os.getenv('TELEGRAM_CHANNEL_ID', '@corporate_portal_alerts')

# Global variables for load testing
current_rps = 0
is_running = False
test_thread = None
test_results = []

class LoadTester:
    def __init__(self):
        self.results = []
        self.start_time = None
        self.end_time = None
    
    def run_test(self, rps, duration, endpoint):
        self.results = []
        self.start_time = datetime.now()
        self.end_time = self.start_time.timestamp() + duration
        
        interval = 1.0 / rps
        request_count = 0
        
        while datetime.now().timestamp() < self.end_time:
            start_time = time.time()
            
            try:
                if endpoint == 'ai-chat':
                    response = requests.post(
                        f"{API_BASE_URL}/api/aichat/ask",
                        json={"query": "медленный запрос для тестирования"},
                        timeout=10
                    )
                elif endpoint == 'orders':
                    response = requests.get(
                        f"{API_BASE_URL}/api/orders",
                        timeout=10
                    )
                elif endpoint == 'users':
                    response = requests.get(
                        f"{API_BASE_URL}/api/users",
                        timeout=10
                    )
                else:
                    response = requests.get(
                        f"{API_BASE_URL}/health",
                        timeout=10
                    )
                
                response_time = (time.time() - start_time) * 1000
                
                self.results.append({
                    'timestamp': datetime.now().isoformat(),
                    'response_time': response_time,
                    'status_code': response.status_code,
                    'success': response.status_code < 400
                })
                
            except Exception as e:
                self.results.append({
                    'timestamp': datetime.now().isoformat(),
                    'response_time': 0,
                    'status_code': 0,
                    'success': False,
                    'error': str(e)
                })
            
            request_count += 1
            
            # Sleep to maintain RPS
            elapsed = time.time() - start_time
            if elapsed < interval:
                time.sleep(interval - elapsed)
        
        return self.get_summary()
    
    def get_summary(self):
        if not self.results:
            return {}
        
        successful_requests = [r for r in self.results if r['success']]
        failed_requests = [r for r in self.results if not r['success']]
        
        response_times = [r['response_time'] for r in successful_requests]
        
        summary = {
            'total_requests': len(self.results),
            'successful_requests': len(successful_requests),
            'failed_requests': len(failed_requests),
            'success_rate': len(successful_requests) / len(self.results) * 100 if self.results else 0,
            'avg_response_time': sum(response_times) / len(response_times) if response_times else 0,
            'min_response_time': min(response_times) if response_times else 0,
            'max_response_time': max(response_times) if response_times else 0,
            'p95_response_time': self._percentile(response_times, 95) if response_times else 0,
            'p99_response_time': self._percentile(response_times, 99) if response_times else 0,
            'duration': (datetime.now() - self.start_time).total_seconds() if self.start_time else 0
        }
        
        return summary
    
    def _percentile(self, data, percentile):
        if not data:
            return 0
        sorted_data = sorted(data)
        index = int(len(sorted_data) * percentile / 100)
        return sorted_data[index]

load_tester = LoadTester()

def send_telegram_alert(message):
    """Send alert to Telegram channel"""
    try:
        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
        data = {
            "chat_id": TELEGRAM_CHANNEL_ID,
            "text": message,
            "parse_mode": "HTML"
        }
        requests.post(url, json=data, timeout=5)
    except Exception as e:
        print(f"Failed to send Telegram alert: {e}")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/start-test', methods=['POST'])
def start_test():
    global is_running, test_thread
    
    if is_running:
        return jsonify({'error': 'Test already running'}), 400
    
    data = request.json
    rps = data.get('rps', 10)
    duration = data.get('duration', 60)
    endpoint = data.get('endpoint', 'health')
    
    is_running = True
    
    def run_test():
        global is_running
        try:
            summary = load_tester.run_test(rps, duration, endpoint)
            
            # Check for alerts
            if summary.get('p99_response_time', 0) > 500:
                send_telegram_alert(
                    f"🚨 <b>Performance Alert</b>\n\n"
                    f"p99 response time exceeded 500ms!\n"
                    f"Current p99: {summary['p99_response_time']:.2f}ms\n"
                    f"Endpoint: {endpoint}\n"
                    f"RPS: {rps}\n"
                    f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
                )
            
            if summary.get('total_requests', 0) > 0:
                actual_rps = summary['total_requests'] / summary['duration']
                if actual_rps > 100:
                    send_telegram_alert(
                        f"🚨 <b>Database Load Alert</b>\n\n"
                        f"Database RPS exceeded 100!\n"
                        f"Current RPS: {actual_rps:.2f}\n"
                        f"Endpoint: {endpoint}\n"
                        f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
                    )
            
        except Exception as e:
            print(f"Test error: {e}")
        finally:
            is_running = False
    
    test_thread = threading.Thread(target=run_test)
    test_thread.start()
    
    return jsonify({'message': 'Test started successfully'})

@app.route('/api/stop-test', methods=['POST'])
def stop_test():
    global is_running
    is_running = False
    return jsonify({'message': 'Test stopped'})

@app.route('/api/status')
def status():
    global is_running
    return jsonify({
        'is_running': is_running,
        'summary': load_tester.get_summary() if not is_running else {}
    })

@app.route('/api/results')
def results():
    return jsonify(load_tester.results)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True) 