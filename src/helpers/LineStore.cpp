#include "LineStore.h"

#include <iostream>
#include <utility>
#include <string>
#include <vector>

using namespace std;

string LineStore::words_;
vector<pair<string, bool> > LineStore::lines_;

void LineStore::LogWord(string word) {
  words_ += word;
}

void LineStore::LogLine() {
  lines_.push_back(make_pair(words_, false));
  words_ = "";
}

void LineStore::PrintLines() {
  for(auto line : lines_) {
    cout << line.first << endl;
  }
}

string LineStore::GetLine(int current) {
  if(current > 0 &&
     current <= lines_.size() &&
     !(lines_[current - 1].second)) {
    lines_[current - 1].second = true;
    return lines_[current - 1].first;
  }
  if(current == lines_.size() + 1) {
    return words_;
  }
  return "";
}

void LineStore::ResetChecks() {
  for (int i = 0; i < lines_.size(); i++) {
    lines_[i].second = false;
  }
}


