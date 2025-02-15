This script can convert characters exported using `.pdump` from the mangoszero format to cmangos-classic. At least the way the formats were in February 2025. It's pretty hacky but it seems to mostly work!

You can execute the `pdump` commands both in game and in the server docker console (by attaching to the docker container). It is more convenient to do many `.pdump` commands in the docker container since you can easily copy and paste.

After importing, check for errors in the output for both the server and the database containers.

If you get an error then update the script to either ignore the table or try to convert the data. Check the documentation for the table in both projects.

Invoke it like this:

```shell
./pdump-converter.py < ../mangoszero/workdir/server/mycharacter.pdump > ../cmangos-classic/workdir/server/mycharacter.pdump
```

Get a list of commands to export characters to files:

```shell
# Get account ids and usernames:
mysql --protocol=tcp --user=mangos -pmangos realmd -e 'select id, username from account order by id'

# Get ".pdump write" commands:
mysql --protocol=tcp --user=mangos -pmangos --raw --silent --skip-column-names character0 -e "select concat('.pdump write ',account,'-',name,'.pdump ',name) from characters where deleteDate is null order by account, name"

# Get ".pdump load" commands: (you have to put the new account name in manually!)
mysql --protocol=tcp --user=mangos -pmangos --raw --silent --skip-column-names character0 -e "select concat('.pdump load ',account,'-',name,'.pdump ACCOUNT_NAME_HERE') from characters where deleteDate is null order by account, name"
```

Convert pdump files:

```shell
cd mangoszero/workdir/server/
mkdir converted
for f in *.pdump; do ../../../../pdump-converter/pdump-converter.py < $f > converted/$f; done
cp -r converted/* ../../../../cmangos-classic/workdir/server/
```

Then run the `.pdump load` commands in cmangos-classic and hope everything went well.
