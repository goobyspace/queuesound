# queuesound
WoW Addon that plays a clip of "Hey Ho Let's Go" by the Ramones when your queue pops.

Queue Sound is a simple addon, meant to add an extra reminder that your arena queue just popped and you should probably click accept if you don't want your arena mates to get mad at you
Right now, it includes functionality for Arenas, Shuffle, BGs, Skirmish, LFR & LFD queues, it plays a 10 second file of "Hey Ho Let's Go" by the Ramones to remind you to join your queue with functionality to turn it off for each seperate queue type

There's a menu, found via /qs config or /qsound config that shows a simple toggle menu, from which you can individually toggle the sound for the queue types currently available

Known bugs/issues: Doing a /reload whilst the confirm screen is up causes the sound to play twice, overlapping each other, the original one doesn't stop until the clip itself is finished.
