import 'package:expenses_manager/commons/expense_chart.dart';
import 'package:expenses_manager/commons/expenses_list.dart';
import 'package:expenses_manager/forms/expenses_new.dart';
import 'package:expenses_manager/model/expenses_model.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  // way to use the expense model as a list with dummy data
  final List<Expense> _regExpenses = [
    Expense(
      amount: 20.00,
      title: "Expense 1",
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      amount: 10.00,
      title: "Expense 2",
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      amount: 25.00,
      title: "Expense 3",
      date: DateTime.now(),
      category: Category.travel,
    )
  ];

  void _onAppBarActionIconPressed() {
    // do something when the appBar add icon on the
    // right has been pressed

    showModalBottomSheet(
      useSafeArea:
          true, // to ensure the widgets start below the device built in header style
      // adding the isScrollControlled feature makes the modal fullscreen
      isScrollControlled: true,
      // while showing the modal pass extra argument that can be used
      // within the model by a button or any other widget
      context: context,
      builder: (ctx) {
        return AddNewExpense(
          onAddExpense: addExpense,
        );
      },
    );
  }

  // functions as django's append to add to a data list
  void addExpense(Expense expense) {
    setState(() {
      _regExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    // storing the index of the expense we are deleting
    // so we can undo and  add it back to the same index
    // it was before

    final expenseIndex = _regExpenses.indexOf(expense);

    // add a setState to remove the expense from the list
    setState(() {
      _regExpenses.remove(expense);
    });
    // clear any snackbar message we have on the screen to show the next one
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show a message that the expense has been removed
    // with extra action for undoing the removal.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _regExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // perform django list view empty object
    Widget mainContent = const Center(
      child: Text("No expenses found. Add a new one"),
    );

    // a conditional to check if the expense list is empty or not
    if (_regExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _regExpenses,
        onRemoveExpense: removeExpense,
      );
    }

    return Scaffold(
      // top app bar to show
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Expenses Manager',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black87,
            onPressed: _onAppBarActionIconPressed,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      // expenses list
      body: width < 400
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // show the chart above the list of items
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Chart(expenses: _regExpenses),
                ),

                // show the list of expenses we have
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                // show the chart above the list of items
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Chart(expenses: _regExpenses),
                  ),
                ),

                // show the list of expenses we have
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
