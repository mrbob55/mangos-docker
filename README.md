This fork makes changes to allow everything to run on a Raspberry Pi. This mostly means that the docker images are updated to have upstream images that are multi-arch.

### Backup whole directory

```shell
sudo tar cJf mangos-docker.tar.xz mangos-docker

# restore:
tar xJf /media/usb/mangos/mangos-docker.tar.xz
```
