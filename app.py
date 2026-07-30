import os
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import yt_dlp

app = Flask(__name__)
CORS(app)

DOWNLOAD_FOLDER = os.path.join(os.getcwd(), 'downloads')
if not os.path.exists(DOWNLOAD_FOLDER):
    os.makedirs(DOWNLOAD_FOLDER)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/indir', methods=['POST'])  # <-- İsim '/indir' olarak düzeltildi
def download_audio():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'Geçersiz veri gönderildi.'}), 400

    url = data.get('url')

    if not url:
        return jsonify({'error': 'Lütfen geçerli bir URL girin.'}), 400

   ydl_opts = {
    'format': 'bestaudio/best',
    'postprocessors': [{
        'key': 'FFmpegExtractAudio',
        'preferredcodec': 'mp3',
        'preferredquality': '192',
    }],
    # --- YENİ EKLENEN KISIM (Bot engelini aşmak için) ---
    'extractor_args': {
        'youtube': {
            'player_client': ['ios', 'android']
        }
    }
}

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            title = info.get('title', 'Şarkı')

        # JS tarafının beklediği JSON yanıtı dönüyoruz
        return jsonify({
            'message': 'İndirme başarılı!',
            'title': title
        }), 200

    except Exception as e:
        return jsonify({'error': f'İndirme hatası: {str(e)}'}), 400

if __name__ == '__main__':
    app.run(debug=True, port=5000)
