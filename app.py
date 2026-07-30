import os
from flask import Flask, render_template, request, jsonify
import yt_dlp

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/indir', methods=['POST'])
def indir():
    data = request.get_json()
    if not data or 'url' not in data:
        return jsonify({'error': 'Geçerli bir URL girmediniz.'}), 400

    url = data.get('url').strip()

    ydl_opts = {
        'format': 'bestaudio/best',
        'quiet': True,
        'no_warnings': True,
        'extractor_args': {
            'youtube': {
                'player_client': ['tv', 'mweb', 'ios', 'android'],
                'player_skip': ['configs', 'webpage']
            }
        },
        'http_headers': {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept-Language': 'en-US,en;q=0.9',
        }
    }

    # Çerez dosyası varsa ve boyutu 0'dan büyükse dene
    cookie_path = 'cookies.txt'
    if os.path.exists(cookie_path) and os.path.getsize(cookie_path) > 0:
        ydl_opts['cookiefile'] = cookie_path

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
