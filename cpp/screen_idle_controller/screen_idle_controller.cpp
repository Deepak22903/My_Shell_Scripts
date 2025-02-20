#include <cstdlib>
#include <iostream>
#include <string>
using namespace std;

void reload_config() {
  cout << "Reloading config...\n";
  int r1 = system("pkill hypridle");
  if (!(r1 == 0)) {
    cout << "failed in pkill hypridle!\n";
  }
  int r2 = system("hypridle > /dev/null &");
  if (!(r2 == 0)) {
    cout << "failed in starting hypridle!\n";
  }
  int r3 = system("hyprctl reload > /dev/null");
  if (!(r3 == 0)) {
    cout << "failed in reloading hyprctl!\n";
  }

  cout << "success\n";
}

void check_errors(int ret) {
  if (ret == 0) {
    cout << "success\n";
  } else {
    cout << "failed!\n";
  }
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    cerr << "Usage : screen [OPTIONS]"
            "\nUse screen -h for help\n";
    return 1;
  } else if (string(argv[1]) == "-h") {
    cout << "Usage : screen [OPTIONS]\n"
            "OPTIONS : \n"
            "-h : for help\n"
            "--no-sleep : Prevents the system from suspend state\n"
            "--no-screenoff : Prevents the screen from turning off\n"
            "--default : Restores to original state\n";
  } else {
    cout << "Updating config...\n";
    if (string(argv[1]) == "--no-sleep") {
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/cpp/"
                 "screen_idle_controller/files/sleep.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
    } else if (string(argv[1]) == "--no-screenoff") {
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                 "cpp/screen_idle_controller/files/sleep_screenoff.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
    } else if (string(argv[1]) == "--default") {
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                 "cpp/screen_idle_controller/files/default.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
    } else {
      cout << "Invalid option!\n Use screen -h for help.\n";
    }
  }
}
