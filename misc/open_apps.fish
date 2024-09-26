# ~/.config/fish/open_apps.fish

#function open
#    # Define a list of apps with their commands
#    set -l apps "youtube:am start --user 0 -n com.google.android.youtube/.HomeActivity
#                 whatsapp:am start --user 0 -n com.whatsapp/.Main
#                 telegram:am start --user 0 -n org.telegram.messenger/.MainActivity
#                 vlc:am start --user 0 -n org.videolan.vlc/.gui.MainActivity
#                 termux:am start --user 0 -n com.termux/.app.TermuxActivity
#                 truecaller:am start --user 0 -n com.truecaller/.ui.TruecallerInit"
#
#    # Use fzf with height limitation, borders, and other customizations
#    set -l choice (echo "$apps" | fzf --height=40% --border --delimiter=":" --with-nth=1)
#
#    # Get the app command from the choice
#    set -l command (echo $choice | cut -d':' -f2-)
#
#    # If a valid command is chosen, execute it
#    if test -n "$command"
#        eval $command
#    else
#        echo "No app selected or command found."
#    end
#end
#

function open
    switch $argv[1]
        case 'whatsapp'
            am start -n com.whatsapp/.Main
        case 'youtube'
            am start -n com.google.android.youtube/.HomeActivity
        case 'chrome'
            am start -n com.android.chrome/com.google.android.apps.chrome.Main
        case 'termux'
            am start -n com.termux/.app.TermuxActivity
        case 'discord'
            am start -n com.discord/com.discord.main.MainDefault
        case 'instagram'
            am start -n com.instagram.android/com.instagram.mainactivity.InstagramMainActivity
        case 'telegram'
            am start -n org.telegram.messenger/org.telegram.messenger.DefaultIcon
        case 'kiwi'
            am start -n com.kiwibrowser.browser/com.google.android.apps.chrome.Main
        case 'files'
            am start -n com.google.android.apps.nbu.files/com.google.android.apps.nbu.files.home.HomeActivity
        case 'photos'
            am start -n com.coloros.gallery3d/com.coloros.gallery3d.app.MainActivity 
        case 'gmail'
            am start -n com.google.android.gm/com.google.android.gm.ConversationListActivityGmail
        case 'maps'
            am start -n com.google.android.apps.maps/com.google.android.maps.MapsActivity
          case 'file_manager'
            am start -n me.zhanghai.android.files/me.zhanghai.android.files.filelist.FileListActivity
        case 'ymusic'
            am start -n com.kapp.youtube.final/com.kapp.youtube.ui.MainActivity
        case 'kdeconnect'
            am start -n com.coloros.weather2/.WeatherActivity
        case 'calculator'
            am start -n com.coloros.calculator/com.android.calculator2.Calculator
        case 'drive'
            am start -n com.google.android.apps.docs/com.google.android.apps.docs.drive.app.navigation.NavigationActivity
        case 'reddit'
            am start -n com.reddit.frontpage/launcher.default
        case 'ytmusic'
            am start -n com.google.android.apps.youtube.music/com.google.android.apps.youtube.music.activities.MusicActivity
        case 'outlook'
            am start -n com.microsoft.office.outlook/com.acompli.acompli.CentralActivity
        case '*'
          echo "Unknown app: $argv[1]"
    end
end


function o
        set apps 'file_manager' 'whatsapp' 'youtube' 'chrome' 'termux' 'discord' 'instagram' 'telegram' 'files' 'photos' 'gmail' 'maps' 'ymusic' 'kdeconnect' 'calculator' 'drive' 'reddit' 'ytmusic' 'outlook'
    set app (echo $apps | tr ' ' '\n' | fzf --prompt="Select an app: " --height=40% --border --delimiter=":" --with-nth=1 --color=dark)
    if test -n "$app"
        open $app
    end
end

