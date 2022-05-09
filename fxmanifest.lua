fx_version 'adamant'
game 'gta5'

description 'lp-farmer'

version '1.0.0'

lua54 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua',
	'client/lumberjack.lua',
	'client/tambang.lua',
	'client/cabe.lua',
	'client/coklat.lua',
	'client/garam.lua',
	'client/kopi.lua',
	'client/padi.lua',
	'client/tebu.lua',
	'client/teh.lua'
}

shared_script {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

dependencies {
	'es_extended'
}
