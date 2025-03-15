#include <cstdlib>
#include <fstream>
#include <iostream>
#include <nlohmann/json.hpp>
#include <nlohmann/json_fwd.hpp>
#include <string>
using namespace std;
using json = nlohmann::json;

// Function to update the status in status.json
void updateStatus(const string &newStatus) {
  ifstream file("/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/cpp/"
                "screen_idle_controller/status.json");

  json jsonData;

  // Read existing JSON file if it exists
  if (file) {
    file >> jsonData;
    file.close();
  } else {
    cerr << "Warning: status.json not found, creating a new one.\n";
  }

  // Update the status
  jsonData["status"] = newStatus;

  // Write back to the file
  ofstream outFile("/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                   "cpp/screen_idle_controller/status.json");
  if (!outFile) {
    cerr << "Error: Could not open status.json for writing.\n";
    return;
  }

  outFile << jsonData.dump(4); // Pretty-print with indentation
  outFile.close();

  cout << "Status updated to: " << newStatus << endl;
}
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
            "--default : Restores to original state\n"
            "--status : Prints the current status\n";
  } else {
    if (string(argv[1]) == "--no-sleep") {
      cout << "Updating config...\n";
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/cpp/"
                 "screen_idle_controller/files/sleep.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
      updateStatus("Status: no-sleep");
    } else if (string(argv[1]) == "--no-screenoff") {
      cout << "Updating config...\n";
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                 "cpp/screen_idle_controller/files/sleep_screenoff.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
      updateStatus("Status: no-screenoff");
    } else if (string(argv[1]) == "--default") {
      cout << "Updating config...\n";
      int ret =
          system("cp "
                 "/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                 "cpp/screen_idle_controller/files/default.conf "
                 "~/.config/hypr/hypridle.conf");
      check_errors(ret);
      reload_config();
      updateStatus("Status: default");
    } else if (string(argv[1]) == "--status") {
      ifstream file("/home/deepak/ghq/github.com/Deepak22903/My_Shell_Scripts/"
                    "cpp/screen_idle_controller/status.json");
      if (!file) {
        cerr << "Error in opening status.json file\n";
        return -1;
      }
      nlohmann::json jsonData;
      file >> jsonData;
      string str = jsonData["status"];
      string res = str.substr(0, str.size() - 1);
      cout << res << endl;

    } else {
      cout << "Invalid option!\n Use screen -h for help.\n";
    }
  }
}
