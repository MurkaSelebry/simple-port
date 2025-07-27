from flask import Flask, render_template, request, jsonify
import requests
import threading
import time
import json
from datetime import datetime
import os

app = Flask(__name__)

# Конфигурация
API_URL = os.getenv('API_URL', 'http://localhost:6000')
TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN', '')
TELEGRAM_CHANNEL_ID = os.getenv('TELEGRAM_CHANNEL_ID', '')

# Глобальные переменные для управления нагрузкой
load_config = {
    'rps': 10,
    'duration': 60,
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
    endpoints = [
        '/api/auth/health',
        '/api/info',
        '/api/orders',
        '/api/orders/statistics'
    ]
    
    import random
    endpoint = random.choice(endpoints)
    
    start_time = time.time()
    try:
        response = requests.get(f"{API_URL}{endpoint}", timeout=10)
        response_time = (time.time() - start_time) * 1000  # в миллисекундах
        
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
            'status_code': response.status_code
        }
    except Exception as e:
        return {
            'success': False,
            'response_time': (time.time() - start_time) * 1000,
            'status_code': 0,
            'error': str(e)
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
    
    if load_config['is_running']:
        return jsonify({'error': 'Load test is already running'}), 400
    
    load_config['rps'] = rps
    load_config['duration'] = duration
    load_config['is_running'] = True
    
    # Запускаем нагрузочный тест в отдельном потоке
    thread = threading.Thread(target=load_test_worker)
    thread.daemon = True
    thread.start()
    
    send_telegram_alert(
        f"🚀 <b>Нагрузочный тест запущен</b>\n"
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
            'duration': load_config['duration']
        },
        'stats': load_config['current_stats']
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True) 