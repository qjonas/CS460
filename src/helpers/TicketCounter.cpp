#include "TicketCounter.h"

#include <cstdlib>
#include <string>

using namespace std;

TicketCounter::TicketCounter(string pre) : prefix(pre), count(1) {}

string TicketCounter::GenerateTicket() {
  char buffer[prefix.size() + 6];
  sprintf(buffer, "%s%05d", prefix.c_str(), count++);
  return string(buffer);
}