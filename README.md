docker build -t fastapi-performance:latest .
docker run -d --cpus="1.0" -p8000:8000 --cpuset-cpus="0" --cpu-shares=1024 fastapi-performance