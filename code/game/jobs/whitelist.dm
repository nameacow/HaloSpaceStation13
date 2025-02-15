#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	var/list/whitelist_base = file2list(WHITELISTFILE, log_error = 0)
	if(!whitelist_base.len)	whitelist = null
	whitelist = list()
	for(var/value in whitelist_base) //Added some code to handle jobs.
		if(isnull(value) || value == "" || value == " ")
			continue
		var/name_and_job = splittext(value,"=")
		if(isnull(name_and_job) || name_and_job[1] == value)
			whitelist += value
		else
			whitelist[name_and_job[1]] += list(name_and_job[2])

/proc/check_whitelist(mob/M , var/rank)
	if(!whitelist)
		return 0
	if(isnull(rank))
		return ("[M.ckey]" in whitelist)
	else
		for(var/value in whitelist)
			if(lowertext(value) == "[M.ckey]" && "[rank]" in whitelist[value])
				return 1
	return 0

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		if(config.usealienwhitelistSQL)
			if(!load_alienwhitelistSQL())
				world.log << "Could not load alienwhitelist via SQL"
		else
			load_alienwhitelist()
	return 1
/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
		return 0
	else
		alien_whitelist = splittext(text, "\n")
		return 1
/proc/load_alienwhitelistSQL()
	var/DBQuery/query = dbcon.NewQuery("SELECT * FROM whitelist")
	if(!query.Execute())
		world.log << dbcon.ErrorMsg()
		return 0
	else
		alien_whitelist = list()
		while(query.NextRow())
			var/list/row = query.GetRowData()
			if(alien_whitelist[lowertext(row["ckey"])])
				var/list/A = alien_whitelist[lowertext(row["ckey"])]
				A.Add(lowertext(row["race"]))
			else
				alien_whitelist[lowertext(row["ckey"])] = list(lowertext(row["race"]))
	return 1

/proc/is_species_whitelisted(mob/M, var/species_name)
	var/datum/species/S = all_species[species_name]
	return is_alien_whitelisted(M, S)

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, var/species)
	if(!M || !species)
		return 0
	if(!config.usealienwhitelist)
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1

	if(istype(species,/datum/language))
		var/datum/language/L = species
		if(!(L.flags & (WHITELISTED|RESTRICTED)))
			return 1
		return whitelist_lookup(L.name, M.ckey)

	if(istype(species,/datum/species))
		var/datum/species/S = species
		if(!(S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_IS_RESTRICTED)))
			return 1
		return whitelist_lookup(S.get_bodytype(S), M.ckey)

	return 0

/proc/whitelist_lookup(var/item, var/ckey)
	if(!alien_whitelist)
		return 0

	if(config.usealienwhitelistSQL)
		//SQL Whitelist
		if(!(ckey in alien_whitelist))
			return 0;
		var/list/whitelisted = alien_whitelist[ckey]
		if(lowertext(item) in whitelisted)
			return 1
	else
		//Config File Whitelist
		for(var/s in alien_whitelist)
			if(findtext(s,"[ckey] - [item]"))
				return 1
			if(findtext(s,"[ckey] - All"))
				return 1
	return 0

#undef WHITELISTFILE
