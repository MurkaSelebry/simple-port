from flask import Flask, render_template, send_from_directory, redirect, url_for
import os
import markdown
from pathlib import Path

app = Flask(__name__)

# Путь к документации
DOCS_PATH = Path(__file__).parent / 'docs'

@app.route('/')
def index():
    """Главная страница - редирект на /docs"""
    return redirect('/docs')

@app.route('/docs')
def docs_index():
    """Главная страница документации"""
    return render_template('index.html')

@app.route('/docs/<filename>')
def docs_file(filename):
    """Отображение markdown файлов как HTML"""
    if not filename.endswith('.md'):
        filename += '.md'
    
    file_path = DOCS_PATH / filename
    
    if not file_path.exists():
        return f"Файл {filename} не найден", 404
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Конвертируем markdown в HTML
    html_content = markdown.markdown(
        content,
        extensions=['tables', 'fenced_code', 'codehilite', 'toc']
    )
    
    return render_template('markdown.html', 
                         content=html_content, 
                         title=filename.replace('.md', ''),
                         filename=filename)

@app.route('/docs/assets/<path:filename>')
def docs_assets(filename):
    """Статические файлы"""
    return send_from_directory('assets', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True) 