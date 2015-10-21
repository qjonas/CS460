#include <iostream>

#include "Escape_Sequences_Colors.h"
#include "SymbolTable.H"

using namespace std;

int main() {

  SymbolTable table;

  char input = '\0';

  do {
    cout << COLOR_CYAN_NORMAL << "Symbol Table Driver" << endl;
    cout << COLOR_CYAN_NORMAL << "===================" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[1]" << COLOR_NORMAL 
         << " Insert Symbol" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[2]" << COLOR_NORMAL 
         << " Lookup Symbol" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[3]" << COLOR_NORMAL 
         << " Push Frame" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[4]" << COLOR_NORMAL 
         << " Pop Frame" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[5]" << COLOR_NORMAL 
         << " Print symbol table" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[6]" << COLOR_NORMAL 
         << " Reset Table" << endl;
    cout << COLOR_MAGENTA_NORMAL << "[q]" << COLOR_NORMAL 
         << " Quit" << endl << endl;

    cout << "Input: ";

    cin >> input;
    int line_number = 1;
    string SymbolName;
    SymbolInfo temp;

    switch (input) {

      case '1': // Insert symbol

        cout << "Symbol Name: ";
        cin >> SymbolName;
        temp = *(new SymbolInfo());
        temp.identifier_name = SymbolName;
        if(table.InsertSymbol(SymbolName, temp)) {
          if(table.HasShadowing(SymbolName)) {
            cout << COLOR_BLINK_YELLOW_NORMAL << "Warning: " << COLOR_NORMAL;
            cout << "Symbol \""<< SymbolName << "\" is shadowing another " 
                 << "variable." <<endl;
          } else { 
            cout << "Symbol \""<< SymbolName << "\" was inserted successfully." 
                 << endl;
          }
        } else {
          cout << COLOR_BLINK_RED_NORMAL << "Error: " << COLOR_NORMAL;
            cout << "Symbol \""<< SymbolName << "\" was already declared in " 
                 << "current scope." <<endl;
        }
        cout << endl;
        break; 

      case '2': // Lookup symbol
        cout << "Symbol Name: ";
        cin >> SymbolName;
        if(table.GetMostRecentSymbolInfo(SymbolName) != NULL) {
          cout << "Symbol \""<< SymbolName << "\" was found." 
                 << endl;
        } else {
          cout << COLOR_BLINK_YELLOW_NORMAL << "Warning: " << COLOR_NORMAL;
            cout << "Symbol \""<< SymbolName << "\" was not found. " 
                 << "A null pointer was returned." <<endl;
        }
        cout << endl;
        break;

      case '3': // Push frame
        table.PushFrame();
        cout << "A new frame has been pushed." << endl << endl;
        break;

      case '4': // Pop frame
        if(table.PopFrame()) {
          cout << "A frame has been popped." << endl << endl;
        } else {
          cout << COLOR_BLINK_RED_NORMAL << "Error: " << COLOR_NORMAL;
          cout << "Unable to pop a frame. " 
               << "There must always be at least one frame." << endl << endl;
        }
        break;

      case '5': // Print symbol table
        cout << endl;
        table.DriverPrint();
        cout << endl;
        break;

      case '6': // Reset table
        table.Reset();
        cout << endl;
        break;

      default:
        break;
    }


  } while (input != 'q');

  return 0;
}