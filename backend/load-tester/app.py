from flask import Flask, render_template, request, jsonify
import requests
import threading
import time
import json
from datetime import datetime
import os
import uuid

app = Flask(__name__)

# Конфигурация
API_URL = os.getenv('API_URL', 'http://localhost:6500')
TELEGRAM_BOT_TOKEN = "7166498436:AAFsL1mg2o70lpWDqkE5a3xCVKldlSxEZfY"
TELEGRAM_CHANNEL_ID = "-1002789557665"

# Глобальные переменные для управления нагрузкой
load_config = {
    'rps': 10,
    'duration': 60,
    'selected_endpoint': '/api/auth/health',  # По умолчанию health endpoint
    'is_running': False,
    'current_stats': {
        'requests_sent': 0,
        'successful_requests': 0,
        'failed_requests': 0,
        'avg_response_time': 0,
        'start_time': None,
        'end_time': None
    }
}

# Доступные endpoints
AVAILABLE_ENDPOINTS = [
    {'value': '/api/auth/health', 'label': 'Health Check'},
    {'value': '/api/info', 'label': 'Info Items'},
    {'value': '/api/orders', 'label': 'Orders'},
    {'value': '/api/orders/statistics', 'label': 'Order Statistics'},
    {'value': '/api/sqlmetrics/rps', 'label': 'SQL RPS'},
    {'value': '/api/sqlmetrics/health', 'label': 'SQL Health'}
]

def send_telegram_alert(message):
    """Отправка алерта в Telegram"""
    if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHANNEL_ID:
        print(f"Telegram alert: {message}")
        return
    
    try:
        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
        data = {
            'chat_id': TELEGRAM_CHANNEL_ID,
            'text': message,
            'parse_mode': 'HTML'
        }
        response = requests.post(url, json=data, timeout=5)
        if response.status_code == 200:
            print(f"Telegram alert sent: {message}")
        else:
            print(f"Failed to send Telegram alert: {response.text}")
    except Exception as e:
        print(f"Error sending Telegram alert: {e}")

def make_api_request():
    """Выполнение запроса к API"""
    global load_config
    
    endpoint = load_config['selected_endpoint']
    
    # Генерируем уникальные trace headers для связи с Jaeger
    trace_id = uuid.uuid4().hex
    span_id = uuid.uuid4().hex[:16]
    
    headers = {
        'traceparent': f'00-{trace_id}-{span_id}-01',  # W3C Trace Context
        'x-trace-id': trace_id,
        'x-load-test': 'true',
        'x-sql-metrics': 'true',  # Флаг для SQL метрик
        'user-agent': 'CorporatePortal-LoadTester/1.0'
    }
    
    start_time = time.time()
    try:
        response = requests.get(f"{API_URL}{endpoint}", headers=headers, timeout=10)
        response_time = (time.time() - start_time) * 1000  # в миллисекундах
        
        # Добавляем задержку для orders endpoint (600ms) для тестирования p99 > 500ms
        if endpoint == '/api/orders':
            time.sleep(0.6)  # 600ms задержка
            response_time += 600  # Добавляем задержку к времени ответа
        
        # Добавляем случайную задержку для тестирования p99 > 500ms
        import random
        if random.random() < 0.1:  # 10% chance
            time.sleep(0.8)  # 800ms дополнительная задержка
            response_time += 800
        
        # Проверка на медленные запросы (p99 > 500ms)
        if response_time > 500:
            send_telegram_alert(
                f"🚨 <b>Медленный ответ API</b>\n"
                f"Endpoint: {endpoint}\n"
                f"Response time: {response_time:.2f}ms\n"
                f"Status: {response.status_code}\n"
                f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            )
        
        return {
            'success': response.status_code < 400,
            'response_time': response_time,
            'status_code': response.status_code,
            'trace_id': trace_id
        }
    except Exception as e:
        return {
            'success': False,
            'response_time': (time.time() - start_time) * 1000,
            'status_code': 0,
            'error': str(e),
            'trace_id': trace_id
        }

def load_test_worker():
    """Рабочий поток для нагрузочного тестирования"""
    global load_config
    
    load_config['current_stats']['start_time'] = datetime.now()
    load_config['current_stats']['requests_sent'] = 0
    load_config['current_stats']['successful_requests'] = 0
    load_config['current_stats']['failed_requests'] = 0
    load_config['current_stats']['response_times'] = []
    
    start_time = time.time()
    target_duration = load_config['duration']
    target_rps = load_config['rps']
    
    while load_config['is_running'] and (time.time() - start_time) < target_duration:
        # Вычисляем интервал между запросами для достижения целевого RPS
        interval = 1.0 / target_rps
        
        # Запускаем запросы параллельно для достижения RPS
        threads = []
        for _ in range(target_rps):
            thread = threading.Thread(target=lambda: make_single_request())
            thread.start()
            threads.append(thread)
        
        # Ждем завершения всех запросов
        for thread in threads:
            thread.join()
        
        # Ждем до следующего интервала
        time.sleep(interval)
    
    load_config['current_stats']['end_time'] = datetime.now()
    load_config['is_running'] = False

def make_single_request():
    """Выполнение одного запроса с обновлением статистики"""
    global load_config
    
    result = make_api_request()
    
    load_config['current_stats']['requests_sent'] += 1
    load_config['current_stats']['response_times'].append(result['response_time'])
    
    if result['success']:
        load_config['current_stats']['successful_requests'] += 1
    else:
        load_config['current_stats']['failed_requests'] += 1
    
    # Обновляем среднее время ответа
    response_times = load_config['current_stats']['response_times']
    if response_times:
        load_config['current_stats']['avg_response_time'] = sum(response_times) / len(response_times)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/start', methods=['POST'])
def start_load_test():
    global load_config
    
    data = request.get_json()
    rps = data.get('rps', 10)
    duration = data.get('duration', 60)
    selected_endpoint = data.get('endpoint', '/api/auth/health')
    
    if load_config['is_running']:
        return jsonify({'error': 'Load test is already running'}), 400
    
    load_config['rps'] = rps
    load_config['duration'] = duration
    load_config['selected_endpoint'] = selected_endpoint
    load_config['is_running'] = True
    
    # Запускаем нагрузочный тест в отдельном потоке
    thread = threading.Thread(target=load_test_worker)
    thread.daemon = True
    thread.start()
    
    send_telegram_alert(
        f"🚀 <b>Нагрузочный тест запущен</b>\n"
        f"Endpoint: {selected_endpoint}\n"
        f"RPS: {rps}\n"
        f"Duration: {duration}s\n"
        f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    )
    
    return jsonify({'message': 'Load test started'})

@app.route('/api/stop', methods=['POST'])
def stop_load_test():
    global load_config
    
    if not load_config['is_running']:
        return jsonify({'error': 'No load test is running'}), 400
    
    load_config['is_running'] = False
    
    send_telegram_alert(
        f"⏹️ <b>Нагрузочный тест остановлен</b>\n"
        f"Total requests: {load_config['current_stats']['requests_sent']}\n"
        f"Successful: {load_config['current_stats']['successful_requests']}\n"
        f"Failed: {load_config['current_stats']['failed_requests']}\n"
        f"Avg response time: {load_config['current_stats']['avg_response_time']:.2f}ms\n"
        f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    )
    
    return jsonify({'message': 'Load test stopped'})

@app.route('/api/status')
def get_status():
    return jsonify({
        'is_running': load_config['is_running'],
        'config': {
            'rps': load_config['rps'],
            'duration': load_config['duration'],
            'selected_endpoint': load_config['selected_endpoint']
        },
        'stats': load_config['current_stats']
    })

@app.route('/api/endpoints')
def get_endpoints():
    return jsonify(AVAILABLE_ENDPOINTS)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True) 