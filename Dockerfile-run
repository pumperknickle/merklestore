FROM swift:5.1
RUN apt-get update && apt-get install -y wget apt-transport-https software-properties-common && \
wget -q https://repo.vapor.codes/apt/keyring.gpg -O- | apt-key add - && \
echo "deb https://repo.vapor.codes/apt $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/vapor.list && \
apt-get update && \
apt-get install -y libmysqlclient20 libmysqlclient-dev cstack ctls openssl libssl-dev

WORKDIR /app
ADD . ./
RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/Run serve -e prod -b 0.0.0.0
