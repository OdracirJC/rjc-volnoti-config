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
    echo    "Usage: rjc-volnoti-config [OPTION] IMAGE "
    echo    "Manages system volume and volnoti icons, takes an option and an image."
    echo
    echo
    echo    "Flags:"
    echo    "   -r         Raises the system volume"
    echo    "   -l         Lowers the system volume"
    echo    "   -m         Mutes the system volume"
    echo    "   -b         Raises brightness by 5% takes three IMAGE parameters [LOW] [MEDIUM] [HIGH]"
    echo    "   -d          Dims brightness by 5%  - takes three IMAGE parameters [LOW] [MEDIUM] [HIGH]"  
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
#Raise Brightness
############################################################

raiseBrightness ()
{
	lux -a 5; #Raise Brightness by 5%
	currBrightness=$(lux -G | tr -d '%') #get brightness
	volnoti-show -2 $low -3 $mid -4 $high $currBrightness
}

lowerBrightness ()
{
	lux -s 5;
	currBrightness=$(lux -G | tr -d '%')
	volnoti-show -2 $low -3 $mid -4 $high $currBrightness
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
           channel=$3
           lowerVolume imagePath
           exit;;
       -m)
           image=$2
           channel=$3
           muteVolume imagePath
           exit;;
       -b)
	   low=$2
	   mid=$3
       high=$4
	   raiseBrightness 
	   exit;;
       -d)
	   low=$2
	   mid=$3
	   high=$4
	   lowerBrightness;
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
