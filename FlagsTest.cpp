#include <string>
#include "FrontendFlags.h"

using namespace std;

FrontendFlags flags;

int main(int argc, char** argv) {
	flags.InitializeFlags(argc, argv);
	flags.Print();
}