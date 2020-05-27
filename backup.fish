#!/bin/fish

# RESTIC_REPOSITORY should be set (using set -x)

read -slx -P "Password: " RESTIC_PASSWORD

if restic snapshots >/dev/null
	# TODO: don't redirect to /dev/null but parse and show last backup date
	# repository opened successfully
	set backup_start_time (date +%s)
	restic backup \
		--verbose \
		--files-from ~/.config/restic/backup.files \
		--exclude-file ~/.config/restic/exclude.files

	set backup_end_time (date +%s)
	set backup_elapsed_time (math --scale=1 \($backup_end_time - $backup_start_time\) / 60)

	# TODO: error handling of backup command

	echo "Backup finished in $backup_elapsed_time minutes."
	notify-send -i drive-harddisk -c transfer.complete "Backup finished in $backup_elapsed_time minutes."
else
	exit 1
end
