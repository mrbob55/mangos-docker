#!/usr/bin/env python3

# Not sure how to handle itemTextId exactly..

import fileinput, sys, pprint

for line in fileinput.input():

    if line.startswith('DUMPED_WITH:'):
      continue

    elif line.startswith('INSERT INTO `characters`'):
        # Remove `createdDate` from:
        # INSERT INTO `characters` (`guid`,`account`,`name`,`race`,`class`,`gender`,`level`,`xp`,`money`,`playerBytes`,`playerBytes2`,`playerFlags`,`position_x`,`position_y`,`position_z`,`map`,`orientation`,`taximask`,`online`,`cinematic`,`totaltime`,`leveltime`,`logout_time`,`is_logout_resting`,`rest_bonus`,`resettalents_cost`,`resettalents_time`,`trans_x`,`trans_y`,`trans_z`,`trans_o`,`transguid`,`extra_flags`,`stable_slots`,`at_login`,`zone`,`death_expire_time`,`taxi_path`,`honor_highest_rank`,`honor_standing`,`stored_honor_rating`,`stored_dishonorable_kills`,`stored_honorable_kills`,`watchedFaction`,`drunk`,`health`,`power1`,`power2`,`power3`,`power4`,`power5`,`exploredZones`,`equipmentCache`,`ammoId`,`actionBars`,`deleteInfos_Account`,`deleteInfos_Name`,`deleteDate`,`createdDate`) VALUES ('1', '6', 'asdf', '1', '1', '0', '39', '31553', '113767', '84282114', '16908288', '32', '-10524.2', '-1166.94', '27.4765', '0', '6.24828', '3456411898 2147550545 49152 0 0 0 0 0 ', '1', '1', '758443', '24590', '1739023182', '1', '3989.06', '0', '0', '0', '0', '0', '0', '0', '6', '0', '0', '10', '1738965330', '', '0', '0', '0', '5', '0', '4294967295', '0', '2029', '0', '0', '0', '100', '0', '1624901185 2776537047 11023367 4085479424 3783258271 4293933454 4159668219 41943102 4001525856 1743585679 4292804973 460505 2136999648 1825325056 3754884088 809557983 1255689598 604697334 1776174785 54478778 51376044 26943463 1555562244 3880055324 3238306821 67371438 0 3207239808 123731968 33773613 2147484160 8388608 524288 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ', '14753 0 12030 0 6404 0 3342 0 4074 0 10329 0 3842 17 14762 0 15566 0 9868 17 6757 0 2933 0 0 0 0 0 14752 2463 15234 0 14825 0 3037 0 0 0 ', '2515', '7', NULL, NULL, NULL, '1730515705');
        s, sep, line = line.partition(' VALUES ')
        sys.stdout.write("INSERT INTO `characters` (`guid`,`account`,`name`,`race`,`class`,`gender`,`level`,`xp`,`money`,`playerBytes`,`playerBytes2`,`playerFlags`,`position_x`,`position_y`,`position_z`,`map`,`orientation`,`taximask`,`online`,`cinematic`,`totaltime`,`leveltime`,`logout_time`,`is_logout_resting`,`rest_bonus`,`resettalents_cost`,`resettalents_time`,`trans_x`,`trans_y`,`trans_z`,`trans_o`,`transguid`,`extra_flags`,`stable_slots`,`at_login`,`zone`,`death_expire_time`,`taxi_path`,`honor_highest_rank`,`honor_standing`,`stored_honor_rating`,`stored_dishonorable_kills`,`stored_honorable_kills`,`watchedFaction`,`drunk`,`health`,`power1`,`power2`,`power3`,`power4`,`power5`,`exploredZones`,`equipmentCache`,`ammoId`,`actionBars`,`deleteInfos_Account`,`deleteInfos_Name`,`deleteDate`) VALUES ")

        s, sep, line = line.rpartition(',')
        sys.stdout.write(s+");\n")
        # continue

    elif line.startswith('INSERT INTO `character_spell_cooldown`') or line.startswith('INSERT INTO `character_ticket`'):
        # ignore these tables
        continue

    elif line.startswith('INSERT INTO `mail`'):
        # Remove `body` from:
        # INSERT INTO `mail` (`id`,`messageType`,`stationery`,`mailTemplateId`,`sender`,`receiver`,`subject`,`body`,`has_items`,`expire_time`,`deliver_time`,`money`,`cod`,`checked`) VALUES ('195422', '3', '41', '151', '15598', '1', '', '', '1', '1740438585', '1737846585', '0', '0', '16');
        s, sep, line = line.partition(' VALUES ')
        sys.stdout.write("INSERT INTO `mail` (`id`,`messageType`,`stationery`,`mailTemplateId`,`sender`,`receiver`,`subject`,`has_items`,`expire_time`,`deliver_time`,`money`,`cod`,`checked`) VALUES ")
        values = line.split(',')
        values.pop(7)
        sys.stdout.write(','.join(values))

    elif line.startswith('INSERT INTO `item_instance`'):
        # This is the hard one!
        # https://www.getmangos.eu/wiki/referenceinfo/dbinfo/characterdb/mangoszerochardb/item_instance-r1549/
        # Map the bits in the `data` column to the new format:
        # INSERT INTO `item_instance` (`guid`,`owner_guid`,`data`,`text`) VALUES ('246199', '1', '246199 1073741824 3 3860 1065353216 0 1 0 1 0 1 0 0 0 20 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ', '2994');
        # INSERT INTO `item_instance` VALUES ('1520', '2', '21711', '0', '0', '1', '82897', '0 0 0 0 0 ', '1', '0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ', '0', '0', '0');
        s, sep, line = line.partition(' VALUES ')
        sys.stdout.write("INSERT INTO `item_instance` VALUES ")
        s, sep, line = line.partition(',')
        sys.stdout.write(s+sep) # guid
        s, sep, line = line.partition(',')
        sys.stdout.write(s+sep) # owner_guid
        s, sep, line = line.partition("'")
        sys.stdout.write(s)
        s, sep, line = line.partition("'")
        data = s.split(' ')

        sys.stdout.write("'"+data[3]+"', ") # itemEntry
        sys.stdout.write("'"+data[10]+"', ") # creatorGuid
        sys.stdout.write("'"+data[12]+"', ") # giftCreatorGuid
        sys.stdout.write("'"+data[14]+"', ") # count
        sys.stdout.write("'"+data[15]+"', ") # duration
        sys.stdout.write("'"+data[16]+" "+data[17]+" "+data[18]+" "+data[19]+" "+data[20]+" ', ") # charges
        sys.stdout.write("'"+data[21]+"', ") # flags
        sys.stdout.write("'") # enchantments
        for i in range(22, 43):
            sys.stdout.write(data[i]+" ")
        sys.stdout.write("', ") # enchantments
        sys.stdout.write("'0', ") # randomPropertyId
        sys.stdout.write("'"+data[46]+"', ") # durability
        sys.stdout.write("'0');\n") # itemTextId ?????

        # Use to more easily inspect values:
        # data_with_index = [{'index':i, 'data':x} for i,x in enumerate(data)]
        # sys.stderr.write(pprint.pformat(data_with_index))

    elif line.startswith('INSERT INTO `character_honor_cp`'):
        # Remove `used` from:
        # INSERT INTO `character_honor_cp` (`guid`,`victim_type`,`victim`,`honor`,`date`,`type`,`used`) VALUES ('1', '3', '11748', '27', '45695', '2', '0');
        s, sep, line = line.partition(' VALUES ')
        sys.stdout.write("INSERT INTO `character_honor_cp` (`guid`,`victim_type`,`victim`,`honor`,`date`,`type`) VALUES ")
        values = line.split(',')
        values.pop()
        values[len(values)-1] += ');\n'
        sys.stdout.write(','.join(values))

    else:
        sys.stdout.write(line)
