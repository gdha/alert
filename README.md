# ALERT command

To compile run *make*
The source file `alertc.c` was converted from `alert.sh` bash script.

Be aware, to compile we need the package "libcurl-devel"

## Configuration file

The configuration file `/etc/alert.conf` contains two variable settings (input file for executable `alert`).

E.g. for sandbox systems the content is:

```
#-> cat /etc/alert.conf
ENVIRONMENT=sandbox
WEBHOOK_URL=https://default3ac94{blabla}.35.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/{workflow}/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig={signature}
```

The `WEBHOOK_URL` is copied from the MS Teams workflow you want to receive these alerts. We always use the _Send webhook alerts to a channel_ template in the workflow window to create a channel.

## Usage

```
$ alert -h
Usage: alert [[-c|--config] configuration-file] [[-e|--environment] environment] [[-t|--title] "TITLE line"] [[-b|--body] "body text"] [[-f|--file] file for body text] [[-i|--image] "URL"] [[-w|--webhook] "URL"] [[-h|--help]] [[-v|--version]]
-e, --environment environment value (overrides config ENVIRONMENT and detection)
-c, --config      configuration file (optional - default /etc/alert.conf)
-t, --title       title message (required)
-b, --body        body text (optional when --file is used)
-f, --file        read body text from file or stdin (required when --body is not used)
-i, --image       Logo graph URL (optional)
-w, --webhook     webhook URL (overrides config WEBHOOK_URL)
-h, --help        show usage (optional)
-v, --version     show version (optional)

For all options read the man page "man alert"
```
