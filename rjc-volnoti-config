#! /bin/bash
#
#   ((0, xF86XK_AudioMute ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle && OPTION=$(amixer get Master | grep 'Front Left' | awk 'NR==2 { print $6  }');case $OPTION in    '[on]') volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail -1);    ;;'[off]')        volnoti-show -nm -0 ~/Pictures/me.png;    ;;    *)    echo 'ERROR';    exit 1;esac" ) --mute
#   ((0, xF86XK_AudioLowerVolume), spawn "case $(amixer get Master | grep 'Front Left' | awk 'NR==2 { print $6  }') in '[on]') pactl set-sink-volume @DEFAULT_SINK@ -5%;  ;; '[off]') ;; esac && case $(amixer get Master | grep 'Front Left' | awk 'NR==2 { print $6  }') in '[on]') volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail  -1); ;; '[off]') volnoti-show -nm -0 ~/Pictures/me.png; ;; *) exit 1; ;; esac;") -- lower volume
#   ((0, xF86XK_AudioRaiseVolume), spawn "case $(amixer get Master | grep 'Front Left' | awk 'NR==2 { print $6  }') in '[on]') pactl set-sink-volume @DEFAULT_SINK@ +5%;  ;; '[off]') ;; esac && case $(amixer get Master | grep 'Front Left' | awk 'NR==2 { print $6  }') in '[on]') volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail  -1); ;; '[off]') volnoti-show -nm -0 ~/Pictures/me.png; ;; *) exit 1; ;; esac;") -- raise volume
#
#

#Deps; pactl, amixer, volnoti
#
#
#
############################################################
# Help Command
############################################################
runHelp()
{
    echo    "Usage: rjc-volnoti-config [OPTION] IMAGE CHANNEL"
    echo    "Manages system volume and volnoti icons, takes an option and an image."
    echo
    echo
    echo    "Flags:"
    echo    "   -r         Raises the system volume"
    echo    "   -l         Lowers the system volume"
    echo    "   -m         Mutes the system volume"
    echo
    echo
    echo    "Examples:"
    echo    "   rjc-volnoti -m ~/Pictures/catpicture.png 'Front Left'   mutes system volume, send a cat png to volnoti-show for icon."
    echo    "   rjc-volnoti -l       lower system volume by 5%."
    echo
    echo
    echo    "Author:    Ricardo J. Cantarero"
    echo    "Website:   odracirjc.github.io"

}




############################################################
#Raise Volume
############################################################

raiseVolume ()
{
    case $(amixer get Master | grep '%' | awk 'NR==2 { print $6  }') in
       '[on]')
           if [ $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail  -1) -gt 100 ]; then
               :
           else
           pactl set-sink-volume @DEFAULT_SINK@ +5%;
           fi
           ;;
       '[off]')
           ;;
   esac

   case $(amixer get Master | grep '%' | awk 'NR==2 { print $6  }') in
        '[on]')
            volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail  -1);
            ;;
        '[off]')
            volnoti-show -nm -0 $image;
            ;;
    esac

}

###########################################################
# Lower Volume
###########################################################

lowerVolume()
{

   case $(amixer get Master | grep '%' | awk 'NR==2 { print $6  }') in
       '[on]')
           pactl set-sink-volume @DEFAULT_SINK@ -5%;
           ;;
       '[off]')
           ;;
   esac
   case $(amixer get Master | grep '%' | awk 'NR==2 { print $6  }') in
        '[on]')
            volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail  -1);
            ;;
        '[off]')
            volnoti-show -nm -0 $image;
            ;;
    esac
}

###########################################################
# Mute Volume
###########################################################

muteVolume ()
{
    pactl set-sink-mute @DEFAULT_SINK@ toggle;
    OPTION=$(amixer get Master | grep '%' | awk 'NR==2 { print $6  }');
    case $OPTION in
        '[on]')
            volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | tail -1);
            ;;
        '[off]')
            if [[ $image ]]
            then
                volnoti-show -nm -0 $image;
            else
                volnoti-show -nm;
            fi
            ;;
        *)
            echo 'ERROR';
            exit 1;;
    esac
}




while [[ "$1" =~ ^- && ! "$1" == "--" ]];

do
   case $1 in
       -r)
           image=$2
           channel=$3
           raiseVolume imagePath
           exit;;
       -l)
           image=$2
           channel=$333
           lowerVolume imagePath
           exit;;
       -m)
           image=$2
           channel=$3
           muteVolume imagePath
           exit;;
       -h)
           runHelp
           exit;;
       *) # Invalid option
         echo "Error: Invalid option"
         runHelp
         exit;;

   esac
done
