FROM docker.elastic.co/beats/filebeat:5.6.16

ARG BUILD_DATE
ARG COMMIT
ARG BRANCH
ARG TAG

USER root
RUN curl -o /tmp/dockerize.tgz https://raw.githubusercontent.com/kbase/dockerize/master/dockerize-linux-amd64-v0.6.1.tar.gz && \
    cd /usr/bin && \
    tar xvzf /tmp/dockerize.tgz && \
    rm /tmp/dockerize.tgz

COPY conf /kb/deployment/conf

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/kbase/filbeat.git" \
      org.label-schema.vcs-ref=$COMMIT \
      org.label-schema.schema-version="1.0.0-rc1" \
      us.kbase.vcs-branch=$BRANCH  \
      maintainer="Steve Chan sychan@lbl.gov"

ENTRYPOINT [ "/usr/bin/dockerize" ]
CMD [ "-template", "/kb/deployment/conf/filebeat.yml.templ:/usr/share/filebeat/filebeat.yml", \
      "filebeat", "-e", "-modules=nginx"]