FROM ubuntu:latest

WORKDIR /work
COPY entrypoint.sh .

# Install basic stuff
RUN apt update
RUN apt install -y git wget curl

# Install Node & CycloneDX for Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install -y nodejs
RUN npm install --global yarn
RUN yarn global add @cyclonedx/bom

# Install Go & CycloneDX for Go
RUN wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
RUN /usr/local/go/bin/go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@latest

# Install Python 3 & CycloneDX for Python/conan and dependencies for formating json/table/csv output
RUN apt install -y python3 python3-pip jq
RUN pip3 install jtbl pip-licenses cyclonedx-conan
RUN pip3 install 'conan==1.47.0' # forcing this because the last version (1.48.x) is broken
RUN curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | grep -v .gz | cut -d\" -f 4)" -L -o dasel && chmod +x dasel
RUN mv ./dasel /usr/local/bin/dasel

CMD ["/work/entrypoint.sh"]
