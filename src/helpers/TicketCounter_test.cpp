#include "TicketCounter.h"

#include <iostream>
#include <string>

using namespace std;

int main() {
  TicketCounter TI("TF");

  for(int i = 0; i < 100; i ++) {
    cout << TI.GenerateTicket() << endl;
  }
}