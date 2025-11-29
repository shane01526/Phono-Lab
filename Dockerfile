# 使用輕量級的 Python 3.9 映像檔
FROM python:3.9-slim

# 設定工作目錄
WORKDIR /app

# 1. 安裝系統級依賴 (最重要的一步)
# espeak-ng: 用於 TTS
# ffmpeg: 用於 pydub 音訊處理
# libsndfile1: 用於音訊讀取
# git: 有些 python 套件安裝需要
RUN apt-get update && apt-get install -y \
    espeak-ng \
    ffmpeg \
    libsndfile1 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 2. 複製依賴清單並安裝 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. 預先下載 Allosaurus 模型 (避免每次啟動時都要下載，節省時間)
RUN python -c "from allosaurus.app import read_recognizer; read_recognizer()"

# 4. 複製主程式碼
COPY app.py .

# 5. 暴露 Streamlit 的預設端口
EXPOSE 8501

# 6. 啟動指令 (設定 Address 為 0.0.0.0 以便外部訪問)
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
