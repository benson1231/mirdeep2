# 使用 docker

## 方案一: 自行建立 image
```bash
docker build -t benson1231/mirdeep2:latest .
```

```bash
docker run -it \
  -v $(pwd):/work \
  benson1231/mirdeep2:latest
```

## 方案二: 使用docker compose
```bash
docker compose run --rm mirdeep2
```

```bash
which miRDeep2.pl
bowtie --version
RNAfold --version
```

# 執行 workflow

```bash
cd tutorial_dir
./run_tut.sh
```

# 下載序列

[mirbase](https://www.mirbase.org/download/CURRENT/)
