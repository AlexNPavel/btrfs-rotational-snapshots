# btrfs-rotational-snapshots
Simple bash script to do 860-style snapshot in btrfs

In its current form, it will keep 8 weekly snapshots, 6 nightly snapshots, and 
0 hourly snapshots (hence the 860 style). It makes snapshots for / , /boot ,
and /home subvolumes. I may make a config file in the future, but at the moment
I don't see it as important since I only plan to use it on my personal server. If
you wish to use it, contact me and I will implement config file functionality so
we can both use this script in harmony :)
