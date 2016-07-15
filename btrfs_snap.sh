#!/bin/bash
shift_weeklies() {
  if [[ -f weekly.8 ]]; then
    btrfs sub del weekly.8
  fi
  for ((i=7;i>=0;i-=1));
  do
    if [[ -f weekly.$i ]]; then
      mv weekly.$i weekly.$(($i + 1))
    fi 
  done
}

logfile=/snapshots.log
exec > $logfile 2>&1
day=$(perl -le 'my $wday = (localtime)[6]; print $wday')

btrfs_subs=(/ /boot/ /home/)

for dir in  ${btrfs_subs[@]}; do
  cd $dir.snapshot
  if [[ -f nightly.6 ]]; then
    if [[ day -eq 0 ]]; then
      shift_weeklies
      mv nightly.6 weekly.0
    else
      btrfs sub del nightly.6
    fi
  fi

  for ((i=5;i>=0;i-=1));
  do
    if [[ -f nightly.$i ]]; then
      mv nightly.$i nightly.$(($i + 1))
    fi
  done

  btrfs sub snap -r ../ nightly.0
done

exit $?
