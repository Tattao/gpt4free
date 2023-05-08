FROM python:3.11 as builder

WORKDIR /usr/app
ENV PATH="/usr/app/venv/bin:$PATH"

RUN apt-get update && apt-get install -y git
RUN mkdir -p /usr/app
RUN python -m venv ./venv

COPY requirements.txt .

#RUN pip install -r requirements.txt

# RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
# RUN pip config set global.trusted-host mirrors.aliyun.com

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 config set global.trusted-host pypi.tuna.tsinghua.edu.cn

RUN pip3 --default-timeout=300 install -r requirements.txt

FROM python:3.11-alpine

WORKDIR /usr/app
ENV PATH="/usr/app/venv/bin:$PATH"

COPY --from=builder /usr/app/venv ./venv
COPY . .

RUN cp ./gui/streamlit_app.py .

CMD ["streamlit", "run", "streamlit_app.py"]

EXPOSE 8501
