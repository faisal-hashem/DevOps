FROM jenkins/jenkins:lts

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    curl \
    git \
    gnupg \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip && \
    unzip terraform_1.5.3_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.5.3_linux_amd64.zip

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

USER jenkins

EXPOSE 8080

CMD ["jenkins.sh"]
