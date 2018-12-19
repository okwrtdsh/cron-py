FROM python:3-alpine

RUN touch /requirements.txt \
 && touch /var/log/cron.log \
 && mkdir -p /etc/cron.d/ \
 && echo -e "* * * * * root /main.sh\n" > /etc/cron.d/main_cron \
 && echo -e '#!/bin/sh\n. /env.sh\necho "$(date)" >> /var/log/cron.log 2>&1' > /main.sh

CMD pip --no-cache-dir install -r /requirements.txt \
 && echo "#!/bin/sh" > /env.sh \
 && printenv | awk '{print "export " $1}' >> /env.sh \
 && chown -R root:root /etc/cron.d/ \
 && chmod -R 0600 /etc/cron.d/ \
 && chmod +x /main.sh \
 && cron \
 && touch /etc/cron.d/main_cron \
 && tail -f /dev/null
