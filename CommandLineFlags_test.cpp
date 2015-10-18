#include <string>
#include "CommandLineFlags.h"

using namespace std;

int main(int argc, char** argv) {
  CommandLineFlags flags = CommandLineFlags::GetInstance();
	flags.InitializeFlags(argc, argv);
	flags.Print();
}