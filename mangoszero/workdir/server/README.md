This is the working directory for the server container.

When you launch the docker container for the first time, the configuration files will appear in this directory.

After modifying the configuration files you can restart the server container to have the new settings take effect. For some settings it is enough to write `.reload config` in the game chat.

Enable the Auction House bot by configuring `ahbot.conf`. The minimal settings that need to be configured are `AuctionHouseBot.CharacterName` (to a real character name) and `AuctionHouseBot.Seller.Enabled = 1`. Use a dedicated account for this otherwise you won't be able to bid on the items yourself. For some settings it is enough to write `.ahbot reload` in the game chat.

The commands that write and read from files, like `.pdump`, also use this directory.
