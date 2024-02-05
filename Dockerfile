FROM neo4j:4.4-community

COPY . /opt/awspx
WORKDIR /opt/awspx

ENV NEO4J_AUTH=neo4j/password
ENV EXTENSION_SCRIPT=/opt/awspx/INSTALL

RUN apt -y update && apt install -y \
        awscli \
        # nodejs \
        npm \
        python3-pip \
        procps \
        git \ 
        gosu \
    && apt install -y curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash \
    && apt -y update && apt install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade \
        argparse \
        awscli \
        boto3 \
        configparser \
        git-python \
        neo4j \
        rich \
    && npm install -g npm@latest 

RUN cd /opt/awspx/www && npm install 
RUN gosu neo4j wget -q --timeout 300 --tries 30 --output-document=/var/lib/neo4j/plugins/apoc.jar \
        https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.3.0.0/apoc-4.3.0.0-all.jar \
        && chmod 644 /var/lib/neo4j/plugins/apoc.jar

# TODO: Try to integrate neo4j 5
# RUN gosu neo4j wget -q --timeout 300 --tries 30 --output-document=/var/lib/neo4j/plugins/apoc.jar \
#         https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/5.5.0/apoc-5.5.0-extended.jar \
#         && chmod 644 /var/lib/neo4j/plugins/apoc.jar

VOLUME /opt/awspx/data
EXPOSE 7373 7474 7687 80 
