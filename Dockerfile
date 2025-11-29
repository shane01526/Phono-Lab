# 使用 Python 3.9
FROM python:3.9-slim

# 設定工作目錄
WORKDIR /app

# 1. 安裝系統級依賴
# espeak-ng: TTS 需要
# ffmpeg: pydub 需要
# libsndfile1: 音訊讀取需要
# libgl1: matplotlib 繪圖有時需要
# git: 下載某些依賴需要
RUN apt-get update && apt-get install -y \
    espeak-ng \
    ffmpeg \
    libsndfile1 \
    libgl1 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 2. 複製並安裝 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. (已刪除導致錯誤的預下載指令)
# 模型將在 App 首次啟動時由 Streamlit 自動下載

# 4. 複製主程式碼
COPY app.py .

# 5. 暴露端口
EXPOSE 8501

# 6. 啟動指令
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
