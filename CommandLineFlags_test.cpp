#include <string>
#include "CommandLineFlags.h"

using namespace std;

CommandLineFlags flags;

int main(int argc, char** argv) {
	flags.InitializeFlags(argc, argv);
	flags.Print();
}