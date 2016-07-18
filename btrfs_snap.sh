#!/bin/bash
shift_weeklies() {
  if [[ -d weekly.8 ]]; then
    echo "Deleting weekly.8"
    btrfs sub del weekly.8
  fi
  for ((i=7;i>=0;i-=1));
  do
    if [[ -d weekly.$i ]]; then
      echo "Moving weekly.$i to weekly.$(($i + 1))"
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
  echo "In directory $PWD"
  if [[ -d nightly.6 ]]; then
    if [[ $day -eq 0 ]]; then
      shift_weeklies
      echo "Moving nightly.6 to weekly.0"
      mv nightly.6 weekly.0
    else
      echo "Deleting nightly.6"
      btrfs sub del nightly.6
    fi
  fi

  for ((i=5;i>=0;i-=1));
  do
    if [[ -d nightly.$i ]]; then
      echo "Moving nightly.$i to nightly.$(($i + 1))"
      mv $dir.snapshot/nightly.$i $dir.snapshot/nightly.$(($i + 1))
    fi
  done

  btrfs sub snap -r ../ nightly.0
  echo ""
done

exit $?
