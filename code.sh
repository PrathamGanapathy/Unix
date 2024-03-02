#!/bin/bash
#!/dev/urandom
revolver=()
countbullets=0
count=$(shuf -i 1-5 -n1)
#echo "$faulty"
load_revolver(){
    faulty=$((8-$count))
    for (( i = 0 ; i < faulty ; i++ ));
    do
        revolver+=(0)
    done
    for (( i = 0 ; i < count ; i++ ));
    do
        revolver+=(1)
    done
    
    revolver=($(shuf -e "${revolver[@]}"))
    
    dialog --title "Russian Roulette" --msgbox "Number of live Bullets = $count" 10 40
    triggerplace=0
    
}

#------------Coin toss------------------------------------------------------------------------
tossCoin() {
    call=($(shuf -i 1-2 -n1))
    if [ $call ==  1 ]
    then
        turn=10
        dialog --title "The turn is" --msgbox "$playeronename goes first" 10 40
    else 
        turn=11
        dialog --title "The turn is" --msgbox "$playertwoname goes first" 10 40
    fi
}

playeronelives=5
playertwolives=5
# playeroneitemslist=()
# playertwoitemslist=()
choice=0

playerOneShoots(){
    dialog --title "Russian Roullette" --msgbox "$playeronename has the gun" 10 40
    choice=$(dialog --title "$playeronename's turn" --menu "You have two choices" 10 30 2 Y "Shoot $playertwoname" N "Shoot yourself" \
                3>&1 1>&2 2>&3 3>&- )
    case $choice in
        "Y")
            dialog --title "$playeronename's turn" --msgbox "You chose to shoot $playertwoname" 10 40
            if [ "${revolver[$triggerplace]}" -eq 1 ]
            then
                ((playertwolives--))
                dialog --title "$playeronename's turn" --msgbox "You Killed $playertwoname" 10 40
            else 
                dialog --title "$playeronename's turn" --msgbox "$playertwoname survived " 10 40
            fi
            ((turn++))
            ((triggerplace++))
            ((countbullets++))
            ;;
        "N")
            dialog --title "$playeronename's turn" --msgbox "How generous of you to shoot yourself instead of  $playertwoname" 30 40
            if [ "${revolver[$triggerplace]}" -eq 1 ]
            then
                ((playeronelives--))
                dialog --title "$playeronename's turn" --msgbox "oh oh Seems like Bad luck" 30 40
                ((turn++))
            else 
                dialog --title "$playeronename's turn" --msgbox "You Survived,The generosity paid off eh\nSince you shot Yourself and survived , as a bonus you get to go again" 30 40 
                ((turn++))
                ((turn++))
            fi
            ((countbullets++))
            ((triggerplace++))
            ;;
        *)
            echo "You chose a wrong option so you loose one of your life"
            echo "Next time Choose wisely"
            echo ""
            ((playeronelives--))
            ((turn++))
            ;;
    esac
}

playerTwoShoots(){
    dialog --title "Russian Roullette" --msgbox "$playertwoname has the gun" 10 40
    choice=$(dialog --title "$playertwoname's turn" --menu "You have two choices" 10 30 2 Y \
    "Shoot $playeronename" N "Shoot yourself" \
                3>&1 1>&2 2>&3 3>&- )
    case $choice in
        "Y")
            dialog --title "$playertwoname's turn" --msgbox "You chose to shoot $playeronename" 10 40
            if [ "${revolver[$triggerplace]}" -eq 1 ]
            then
                ((playeronelives--))
                dialog --title "$playertwoname's turn" --msgbox "You Killed $playeronename" 10 40
            else 
                dialog --title "$playertwoname's turn" --msgbox "$playeronename survived " 10 40
            fi
            ((turn++))
            ((triggerplace++))
            ((countbullets++))
            ;;
        "N")
            dialog --title "$playertwoname's turn" --msgbox "How generous of you to shoot yourself \
            instead of  $playeronename" 30 50
            if [ "${revolver[$triggerplace]}" -eq 1 ]
            then
                ((playertwolives--))
                dialog --title "$playertwoname's turn" --msgbox "oh oh Seems like Bad luck\n$playertwoname Shot himself" 30 75
                ((turn++))
            else 
                dialog --title "$playertwoname's turn" --msgbox "You Survived,The generosity paid off eh\
                \nSince you shot Yourself and survived , \
                as a bonus you get to go again" 30 50 
                ((turn++))
                ((turn++))
            fi
            ((countbullets++))
            ((triggerplace++))
            ;;
        *)
            echo "You chose a wrong option so you loose one of your life"
            echo "Next time Choose wisely"
            echo ""
            ((playeronelives--))
            ((turn++))
            ;;
    esac
}

lived() {
    if [ $playeronelives == 0 ]
    then 
        dialog --title "Russian Roulette" --msgbox "$playertwoname lived and can carry on" 20 50
    else
        dialog --title "Russian Roulette " --msgbox "$playeronename lived and can carry on" 20 50 
    fi
}


playeronename=$(\
  dialog --title "Russian Roulette" \
         --inputbox "Enter the name of Player1" 8 40 \
  3>&1 1>&2 2>&3 3>&- \
)

playertwoname=$(\
  dialog --title "Russian Roulette" \
         --inputbox "Enter the name of Player2" 8 40 \
  3>&1 1>&2 2>&3 3>&- \
)

dialog --title "Russian Roulette" --msgbox "welcome to Russian Roulette $playeronename and $playertwoname,\
\nclick ok to continue" 30 50

dialog --title "Russian Roulette" --msgbox "Both of you have 5 lives\nNo peeking\
\nNo cheating\n\n\nMay the Luckiest Win" 30 50

dialog --title "Russian Roulette" --msgbox "Loading the gun\nGun Loaded in Random Order" 30 50
load_revolver
#echo "${revolver[@]}"


dialog --title "Russian Roulette" --msgbox "Tossing The coin\nHead:$playeronename \
\nTail:$playertwoname\n\
Click OK to continue" 30 50
tossCoin

while [ $playeronelives != 0 ] && [ $playertwolives != 0 ];
do
    if [ $((turn % 2)) -eq 0 ];
    then
        playerOneShoots
    else
        playerTwoShoots
    fi
    if [ $countbullets -eq 8 ]
    then
        dialog --title "Russian Roulette" --msgbox "Oh oh, You ran out of bullets\nLets reload again" 10 40 
        dialog --title "Russian Roulette" --msgbox "So lets continue??" 10 40 
        revolver=()
        count=$(shuf -i 4-7 -n1) 
        load_revolver
        countbullets=0
    fi
    dialog --title "Russian Roulette" --msgbox "Number of lives of $playeronename : $playeronelives\
    \nNumber of lives of $playertwoname : $playertwolives" 10 40
done

lived
