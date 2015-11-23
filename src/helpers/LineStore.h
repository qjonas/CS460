#ifndef LINE_STORE_H
#define LINE_STORE_H

#include <string>
#include <utility>
#include <vector>

class LineStore {
public:
  static void LogWord(std::string word);  
  static void LogLine();
  static std::string GetLine(int current);
  static void PrintLines();
  static void ResetChecks();

private:
  LineStore();

  static std::string words_;
  static std::vector<std::pair<std::string, bool> > lines_;
};

#endif // LINE_STORE_H
