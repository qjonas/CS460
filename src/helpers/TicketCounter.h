#ifndef TICKET_COUNTER_H
#define TICKET_COUNTER_H

#include <string>

class TicketCounter {
public:
  TicketCounter(std::string pre);
  std::string GenerateTicket();

private:
  std::string prefix;
  int count;
};

#endif // TICKET_COUNTER_H