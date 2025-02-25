This is the working directory for the server container.

When you launch the docker container for the first time, the configuration files will appear in this directory.

After modifying the configuration files you can restart the server container to have the new settings take effect. For some settings it is enough to write `.reload config` in the game chat.

Configure the Auction House in `ahbot.conf`. For some settings it is enough to write `.ahbot reload` in the game chat to reload the configuration.

The commands that write and read from files, like `.pdump`, also use this directory.
