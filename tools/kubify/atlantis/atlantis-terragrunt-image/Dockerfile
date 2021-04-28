ARG ATLANTIS_VERSION

FROM runatlantis/atlantis:v${ATLANTIS_VERSION}

ARG TERRAGRUNT_VERSION
ARG TERRAFORM_VERSION

RUN apk -v --update add \
        python3 \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip3 install --upgrade awscli==1.5.2 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN curl -sL \
  https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
  -o /bin/terragrunt-binary

# Terraform plugin cache set by env variable in task definition
RUN mkdir -p /root/.terraform.d/plugin-cache/

# also installing terraform 0.14.10 until atlantis supports multiple versions
RUN curl -sL \
  -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && \
  unzip -o /tmp/terraform.zip -d /usr/local/bin/ \
  && \
  rm /tmp/terraform.zip

RUN mkdir -p /tmp/.terraform.d/ && chown -R atlantis:atlantis /tmp/.terraform.d/

COPY terragrunt /bin/terragrunt

RUN chmod 755 /bin/terragrunt-binary /bin/terragrunt
