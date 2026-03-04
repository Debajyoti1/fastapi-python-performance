<!-- Docker build -->
docker build -t fastapi-performance:latest .
<!-- Docker single core run -->
docker run -d --cpus="1.0" -p8000:8000 --cpuset-cpus="0" --cpu-shares=1024 fastapi-performance
<!-- Docker dual core run -->
docker run -d --cpus="2.0" -p8000:8000 --cpuset-cpus="0,1" --cpu-shares=1024 fastapi-performance
