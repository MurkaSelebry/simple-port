from flask import Flask, request, jsonify
import requests
import json
import os
from datetime import datetime

app = Flask(__name__)

# Telegram configuration
TELEGRAM_BOT_TOKEN = "7166498436:AAFsL1mg2o70lpWDqkE5a3xCVKldlSxEZfY"
TELEGRAM_CHANNEL_ID = "-1002789557665"

def send_telegram_alert(alert_data):
    """Send alert to Telegram channel"""
    if not TELEGRAM_BOT_TOKEN:
        print(f"Telegram alert (no token): {alert_data}")
        return
    
    try:
        # Format the alert message
        alert = alert_data['alerts'][0]
        status = alert['status']
        labels = alert['labels']
        annotations = alert['annotations']
        
        # Create emoji based on severity
        severity_emoji = {
            'critical': '🚨',
            'warning': '⚠️',
            'info': 'ℹ️'
        }
        
        emoji = severity_emoji.get(labels.get('severity', 'warning'), '⚠️')
        
        # Create the message
        message = f"{emoji} <b>ALERT: {annotations.get('summary', 'Unknown Alert')}</b>\n\n"
        message += f"<b>Status:</b> {status.upper()}\n"
        message += f"<b>Severity:</b> {labels.get('severity', 'unknown')}\n"
        message += f"<b>Description:</b> {annotations.get('description', 'No description')}\n"
        message += f"<b>Time:</b> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
        
        if 'alert_type' in labels:
            message += f"<b>Alert Type:</b> {labels['alert_type']}\n"
        
        # Add service information if available
        if 'service' in labels:
            message += f"<b>Service:</b> {labels['service']}\n"
        
        # Add instance information if available
        if 'instance' in labels:
            message += f"<b>Instance:</b> {labels['instance']}\n"
        
        # Add value information if available
        if 'value' in alert:
            message += f"<b>Value:</b> {alert['value']}\n"
        
        # Send to Telegram
        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
        data = {
            'chat_id': TELEGRAM_CHANNEL_ID,
            'text': message,
            'parse_mode': 'HTML',
            'disable_web_page_preview': True
        }
        
        response = requests.post(url, json=data, timeout=10)
        
        if response.status_code == 200:
            print(f"Telegram alert sent successfully: {annotations.get('summary', 'Unknown Alert')}")
        else:
            print(f"Failed to send Telegram alert: {response.text}")
            
    except Exception as e:
        print(f"Error sending Telegram alert: {e}")

@app.route('/alert', methods=['POST'])
def receive_alert():
    """Receive alert from AlertManager and forward to Telegram"""
    try:
        alert_data = request.get_json()
        
        if not alert_data or 'alerts' not in alert_data:
            return jsonify({'error': 'Invalid alert data'}), 400
        
        # Send each alert to Telegram
        for alert in alert_data['alerts']:
            send_telegram_alert({'alerts': [alert]})
        
        return jsonify({'status': 'success'})
        
    except Exception as e:
        print(f"Error processing alert: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8088, debug=True) 