# Limnoria

[![](https://badge.imagelayers.io/libcrack/limnoria:latest.svg)](https://imagelayers.io/?images=libcrack/limnoria:latest 'imagelayers.io')

Limnoria IRC bot docker container.

Example run:

```bash
docker run -d --name mybot \
       -e SUPYBOT_CHANNELS="#mychannel" \
       -e SUPYBOT_IDENT=mybot \
       -e SUPYBOT_NETWORK=freenode \
       -e SUPYBOT_NICK=mybot \
       -e SUPYBOT_PORT=6697 \
       -e SUPYBOT_PREFIXES='@&' \
       -e SUPYBOT_PREFIX_STRINGS="HEY" \
       -e SUPYBOT_SERVER=irc.freenode.net \
       -e SUPYBOT_USER=bot \
       -e SUPYBOT_USE_SSL=True \
       -e SUPYBOT_OWNER=supyadmin \
       -e SUPYBOT_OWNER_PASS=adminpass \
       libcrack/limnoria
```

This will build and run an initial config and start limnoria in a detached
container called "limnoria".  Further configuration can be done from a query
window with your bot in your IRC client.

If you already have a configuration situated at /var/lib/mybot, make sure
your configuration directory is owned by the limnoria user
and run the following command:

```bash
docker run -d --name mybot \
       -v /var/lib/mybot \
       -d SUPYBOT_HOME /var/lib/mybot \
       libcrack/limnoria \
       supybot mybot.conf
```

or:

```bash
docker run -d --name mybot \
       -v /var/lib/mybot:/var/supybot \
       libcrack/limnoria \
       supybot mybot.conf
```

The environment values are:

```
SUPYBOT_CHANNELS       # Channels to join (default: empty)
SUPYBOT_HOME           # Where to put the config files (default: /var/supybot)
SUPYBOT_IDENT          # Identity of bot (default: supybot)
SUPYBOT_NETWORK        # Network name (default: freenode)
SUPYBOT_NICK           # Nick of bot (default: supybot)
SUPYBOT_PASSWORD       # Network Password (default: empty)
SUPYBOT_PORT           # Network Port (default: 6697)
SUPYBOT_PREFIXES       # Single character command prefixes, can specify multiple (default: '!')
SUPYBOT_PREFIX_STRINGS # Multi-character command prefixes, space delimited (default: empty)
SUPYBOT_SERVER         # Network address (default: irc.freenode.net)
SUPYBOT_USER           # Bot Username (default: supybot)
SUPYBOT_USE_SSL        # Use SSL? (default: True)
SUPYBOT_OWNER          # Owner identity for !identify (default: owner)
SUPYBOT_OWNER_PASS     # Owner password for !identify (default: owner)
```
