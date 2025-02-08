When you launch the docker container for the first time, the configuration files for realmd and mangosd will appear in this directory.

After modifying the conf files you can restart the appropriate container to have the new settings take effect. For some settings it is enough to write `.reload config` in the game chat.

Enable the Auction House bot by configuring `ahbot.conf`. The minimal settings that need to be configured are `AuctionHouseBot.CharacterName` (to a real character name) and `AuctionHouseBot.Seller.Enabled = 1`. Use a dedicated account for this otherwise you won't be able to bid on the items yourself. For some settings it is enough to write `.ahbot reload` in the game chat.
