FROM python:3

ARG USERNAME=bob
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN    groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN pip install jupyter-book

RUN apt-get install -y inotify-tools

USER $USERNAME
WORKDIR /book
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]
CMD nohup ./build-process.sh & sleep infinity

