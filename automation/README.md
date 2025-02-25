Set `Ra.Enable = 1` in `mangosd.conf` first and restart the server.

Install pre-requisites:

```shell
sudo apt install telnet expect
```

You also need to create the automation user in mangos:

```
account create automationuser automationpass
account set gmlevel automationuser 3
```

Then optionally lock the automation user to your IP:

```
./login.exp
account lock on
quit
```

Install systemd stuff:

```shell
cd mangos-docker/automation

cat << EOF | sudo tee /etc/systemd/system/mangos-maintenance.service
[Unit]
Description="Service that performs maintenance operations on mangos"

[Service]
Type=simple
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/backup-and-restart.sh
EOF

cat << EOF | sudo tee /etc/systemd/system/mangos-daily-maintenance.timer
[Unit]
Description="Timer for mangos-maintenance.service"

[Timer]
Unit=mangos-maintenance.service
# Every day at 4 in the morning:
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now mangos-daily-maintenance.timer

sudo systemctl status mangos-daily-maintenance.timer
sudo systemctl status mangos-maintenance.service
```
