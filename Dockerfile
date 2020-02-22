FROM registry.fedoraproject.org/fedora:31

ENV LANG C.UTF-8

RUN dnf -y update && \
    dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-31.noarch.rpm \
                   http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-31.noarch.rpm && \
    dnf -y install bind-utils \
                   gcc \
                   git \
                   iproute \
                   iputils \
                   libffi-devel \
                   openssl-devel \
                   p7zip \
                   par2cmdline \
                   python3-devel \
                   redhat-rpm-config \
                   tar \
                   traceroute \
                   unrar \
                   unzip && \
    /usr/bin/python3 -m venv /opt/sabnzbd && \
    /usr/bin/git clone --single-branch --branch develop https://github.com/sabnzbd/sabnzbd.git /opt/sabnzbd/src && \
    /opt/sabnzbd/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/sabnzbd/bin/pip install --no-cache-dir --upgrade setuptools && \
    /opt/sabnzbd/bin/pip install --no-cache-dir --upgrade --requirement /opt/sabnzbd/src/requirements.txt && \
    mkdir /media /usenet /opt/sabnzbd/etc /opt/sabnzbd/data /opt/sabnzbd/logs && \
    groupadd -g 5000 media && \
    useradd -u 5000 -g 5000 -d /opt/sabnzbd -M media && \
    rm -rf /usr/share/doc /usr/share/man /var/cache/dnf

EXPOSE 8080

ENV PYTHONPATH /opt/sabnzbd/src

VOLUME /media
VOLUME /usenet
VOLUME /opt/sabnzbd/etc
VOLUME /opt/sabnzbd/data
VOLUME /opt/sabnzbd/logs

USER media

ENTRYPOINT ["/opt/sabnzbd/bin/python", "-OO", "/opt/sabnzbd/src/SABnzbd.py", "--config-file=/opt/sabnzbd/etc/sabnzbd.ini", "--browser=0", "--weblogging"]
