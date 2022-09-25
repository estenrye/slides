#!/usr/bin/dumb-init /bin/sh

sniffer=$(fluent-gem contents fluent-plugin-elasticsearch|grep elasticsearch_simple_sniffer.rb)

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/fluent.conf
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi

    if ! echo $@ | grep '\-r'; then
      set -- "$@" -r $sniffer
    fi
fi

echo $@
exec su-exec fluent "$@"
