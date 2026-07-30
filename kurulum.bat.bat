```bat
@echo off
chcp 65001 > nul
echo Proje dosyalari olusturuluyor...

mkdir SarkiIndirici
cd SarkiIndirici
mkdir templates

(
echo import os
echo from flask import Flask, render_template, request, send_file, jsonify
echo import yt_dlp
echo.
echo app = Flask(__name__)
echo.
echo DOWNLOAD_FOLDER = os.path.join(os.getcwd(), 'downloads')
echo if not os.path.exists(DOWNLOAD_FOLDER):
echo     os.makedirs(DOWNLOAD_FOLDER)
echo.
echo @app.route('/')
echo def index():
echo     return render_template('index.html')
echo.
echo @app.route('/download', methods=['POST'])
echo def download_audio():
echo     data = request.get_json()
echo     url = data.get('url')
echo     if not url:
echo         return jsonify({'error': 'Lutfen gecerli bir URL girin.'}), 400
echo     ydl_opts = {
echo         'format': 'bestaudio/best',
echo         'outtmpl': os.path.join(DOWNLOAD_FOLDER, '%%(title)s.%%(ext)s'),
echo         'quiet': True
echo     }
echo     try:
echo         with yt_dlp.YoutubeDL(ydl_opts) as ydl:
echo             info = ydl.extract_info(url, download=True)
echo             filename = ydl.prepare_filename(info)
echo         return send_file(filename, as_attachment=True)
echo     except Exception as e:
echo         return jsonify({'error': f'Indirme hatasi: {str(e)}'}), 500
echo.
echo if __name__ == '__main__':
echo     app.run(debug=True, port=5000)
) > app.py

(
echo ^<!DOCTYPE html^>
echo ^<html lang="tr"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<title^>MP3 Indirici^</title^>
echo     ^<style^>
echo         body { font-family: sans-serif; background: #0f172a; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
echo         .card { background: #1e293b; padding: 30px; border-radius: 12px; width: 400px; text-align: center; }
echo         input { width: 100%%; padding: 10px; margin-bottom: 10px; box-sizing: border-box; background: #0f172a; border: 1px solid #334155; color: #fff; border-radius: 6px; }
echo         button { width: 100%%; padding: 10px; background: #0284c7; border: none; color: #fff; font-weight: bold; border-radius: 6px; cursor: pointer; }
echo         #status { margin-top: 15px; font-size: 0.9em; color: #94a3b8; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="card"^>
echo         ^<h2^>🎵 Muzik Indirici^</h2^>
echo         ^<input type="text" id="urlInput" placeholder="YouTube Linki Yapistirin..."^>
echo         ^<button onclick="downloadMusic()"^>Muzigi Indir^</button^>
echo         ^<div id="status"^>^</div^>
echo     ^</div^>
echo     ^<script^>
echo         async function downloadMusic() {
echo             const url = document.getElementById('urlInput').value;
echo             const status = document.getElementById('status');
echo             if(!url) { status.innerText = "Link girin!"; return; }
echo             status.innerText = "Indiriliyor, lutfen bekleyin...";
echo             try {
echo                 const res = await fetch('/download', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({url}) });
echo                 if(!res.ok) throw new Error("Hata olustu");
echo                 const blob = await res.blob();
echo                 const a = document.createElement('a');
echo                 a.href = window.URL.createObjectURL(blob);
echo                 a.download = "sarki.mp3";
echo                 a.click();
echo                 status.innerText = "Tamamlandi! 🎉";
echo             } catch(e) { status.innerText = "Hata oluştu!"; }
echo         }
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > templates\index.html

echo Kütüphaneler yukleniyor...
pip install flask yt-dlp

echo Uygulama baslatiliyor...
python app.py
pause
```