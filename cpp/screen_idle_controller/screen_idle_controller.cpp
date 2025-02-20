#include <cstdlib>
#include <iostream>
#include <string>
using namespace std;

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
  } else if (string(argv[1]) == "--no-sleep") {
    int ret = system(
        "cp "
        "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/cpp/"
        "screen_idle_controller/files/sleep.conf ~/.config/hypr/hypridle.conf");
    check_errors(ret);
  } else if (string(argv[1]) == "--no-screenoff") {
    int ret = system("cp "
                     "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                     "cpp/screen_idle_controller/files/sleep_screenoff.conf "
                     "~/.config/hypr/hypridle.conf");
    check_errors(ret);
  } else if (string(argv[1]) == "--default") {
    int ret = system("cp "
                     "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                     "cpp/screen_idle_controller/files/default.conf "
                     "~/.config/hypr/hypridle.conf");
    check_errors(ret);
  } else {
    cout << "Invalid input!\n Use screen -h for help.\n";
  }
}
