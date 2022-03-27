# Idle-Game
main Scene file is Level.tscn and script connected to that file is level1.gd which just saves character progroess by calling save function from the script save.gd. level.tscn has multiple child scene/node that makes up that scene! child scene/node connected to main scene(level.tscn) are 
      -map button node which is called in level.gd script, 
      -parallax background node, paralax layer node, and background node which is called in playerStateTest.gd script, 
      -inventory.tscn scene which has multiple child node and scripts of its own to display the inventory of player, upgrade stats and skill, farming simulation, cooking
      simulation. 
          -to display inventory, inventory.tscn scene is connected to  another scene called inveTest.tsc with script called invTest.gd ! 
              -invTest.tsc is connected to other node and scene to display the gui of the inventory(grid container node, textrect node), sell item, equip item, selected
              multiple item and  all these node are connected to multiple script(sortig_Inventory.gd,slotTest.gd, itemOption.gd, equipment.gd, multiSellAmount.gd,etc).
          -to display upgrade and stat skill, inveotry.tscn is connected to statUpgrade.tscn with script statUpgrade.gd.
                -statupgrade.tscn has other node and scene connected to it to show gui of the stat upgrades for the player(panels and button nodes to show each stat and
                its current value) which has their own script( statButtonUp.gd (increases stat),statButtonDown.gd (decreases stat))
          -to display farming,
                -
          -to display cooking,
                -
      -pick.tscn which generate random items and shows images of the item on gui using script ItemDrop.gd.
          -
      -player.tscn
      -spawn&Death_Track.tscn
      -openshop button node which connect to androidShop.tscn
      -androidShop.tscn

          
          
      
