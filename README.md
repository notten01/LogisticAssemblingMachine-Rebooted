# LogisticAssemblingMachine-Rebooted
Mod for computer game [Factorio](https://www.factorio.com/), rebooting the [original logistic assembling machine](https://mods.factorio.com/mod/LogisticAssemblingMachine) mod
 
## What does it do
This mod will add two additional buildings to your game that can be unlocked through research. The `logistics assembly machine` and the `logistics chemical plant`.
Both of these have the same function as their non logistical counterparts. But in addition to those the logistical versions will automatically start pulling the items required for the selected recipe from the logistics network.
 
If you change or cancel a recipe the logistics requests will be canceled. And any leftover stock will be thrown on the floor and market for pickup to your drones.
 
## how it works
When you build any of these buildings you actually build 5:
* the assembler
* a logistics request chest
* a logistics provisioning chest
* two inserters
The mod will make those 5 buildings work as one by automatically setting the requests on the chest.
 
## Brave new world integration
When playing the [Brave new world](https://mods.factorio.com/mod/brave-new-world) scenario with this mod loaded you will automatically get 4 `logistics assembly machines` dropped just north of you robo port. Mouse hover over them to pick them up
 
## known issues
 
* drones that are in flight while you cancel a request will not cancel their delivery. This might cause items from the previous recipe to be present in the request chest. A workaround is to reselect your current recipe to get those out
 
## contributing
Feel free to send me any pull requests. I can list you on the mod page if you want.