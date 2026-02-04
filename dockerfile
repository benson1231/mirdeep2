FROM mambaorg/micromamba:1.5.6

# 設定工作目錄
WORKDIR /work

# 安裝 miRDeep2 需要的工具
RUN micromamba install -y -n base -c bioconda -c conda-forge \
    mirdeep2=2.0.1.3 \
    bowtie=1.1.2 \
    viennarna \
    samtools \
    perl \
    perl-font-ttf \
    perl-pdf-api2 \
    && micromamba clean --all --yes

# 確保 binary 在 PATH
ENV PATH=/opt/conda/bin:$PATH

# 預設進入 bash
CMD ["/bin/bash"]
