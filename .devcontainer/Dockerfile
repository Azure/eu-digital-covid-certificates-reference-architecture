FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-20.04

ENV TERRAFORM_VERSION=1.0.4
ENV TERRAFORM_DOCS_VERSION=0.15.0
ENV HUGO_VERSION=0.87.0
ENV KUBETCL_VERSION=1.22.1-00
ENV AZURE_CLI_VERSION=2.27.1-1~focal
ENV AZURE_CLI_SSH_EXTENSION_VERSION=0.1.6
ENV DGC_CLI_VERSION=0.6.1
ENV ANDROID_SDK_CMD_TOOLS_VERSION=6514223_latest

# Install Basic Packages (Stuff needed for other Apt Repos)
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends apt-transport-https ca-certificates curl lsb-release gnupg2 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Additional Apt Repos
RUN export DEBIAN_FRONTEND=noninteractive \
    # Azure CLI Repo
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main" > /etc/apt/sources.list.d/azure-cli.list \
    # Kubernetes Repository
    && curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# Install Additional Packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends bash-completion openssh-client psmisc nano vim wget unzip jq make git npm openjdk-11-jdk azure-cli=${AZURE_CLI_VERSION} kubectl=${KUBETCL_VERSION} \
    && echo 'source /etc/profile.d/bash_completion.sh' >> ~/.bashrc \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Android build tools
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends zipalign apksigner \
    && cd /opt \
	&& wget -O android-sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_CMD_TOOLS_VERSION}.zip \
	&& mkdir -p /opt/android-sdk-linux/cmdline-tools/ \
	&& unzip -q android-sdk-tools.zip -d /opt/android-sdk-linux/cmdline-tools/ \
	&& rm android-sdk-tools.zip \
    && chown -R vscode android-sdk-linux

ENV PATH $PATH:/opt/android-sdk-linux/cmdline-tools/
ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
RUN cd $ANDROID_SDK_ROOT/cmdline-tools/tools/bin \
    && yes | ./sdkmanager --licenses

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Terraform-Docs
RUN curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-$(uname)-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/terraform-docs \
    && rm ./terraform-docs.tar.gz

# Install Hugo
RUN curl -Lo ./hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && tar -xzf hugo.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && rm ./hugo.tar.gz LICENSE

# Install DGC CLI
RUN curl -Lo ./dgc-cli.zip https://github.com/eu-digital-green-certificates/dgc-cli/releases/download/${DGC_CLI_VERSION}/dgc-cli.zip \
    && unzip dgc-cli.zip dgc-cli.jar \
    && mv dgc-cli.jar /usr/local/lib/dgc-cli.jar \
    && rm ./dgc-cli.zip \
    && echo '#!/usr/bin/env bash' > /usr/local/bin/dgc-cli \
    && echo 'exec java -jar /usr/local/lib/dgc-cli.jar "$@"' >> /usr/local/bin/dgc-cli \
    && chmod +x /usr/local/bin/dgc-cli

# From this point on, all RUN commands will be executed as the vscode user
USER vscode

# Install AZ cli ssh extension
RUN az extension add --name ssh --version ${AZURE_CLI_SSH_EXTENSION_VERSION}
