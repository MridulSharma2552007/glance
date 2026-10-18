# Glance AI service

## Arch Linux setup

Install the compiler tools needed to build InsightFace, if they are not already
installed:

```sh
sudo pacman -S --needed base-devel cmake uv
```

Create a Python 3.12 virtual environment and install the service dependencies:

```sh
cd backend/glance_ai
uv python install 3.12
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python -r requirements.txt
```

Run the API from this directory:

```sh
.venv/bin/uvicorn app:app --host 0.0.0.0 --port 8000
```

The YOLO weights (`yolov8n.pt`) are included. On the first start,
InsightFace downloads its `buffalo_l` face-analysis model. The service needs
internet access for that initial download.
