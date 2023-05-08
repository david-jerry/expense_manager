import 'dart:io';

import 'package:expenses_manager/model/expenses_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewExpense extends StatefulWidget {
  const AddNewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  // create a variable that can store the users latest
  //input for when we are ready to store the input value
  // var titleInput = '';

  // void _saveTitleInput(String inputValue) {
  //   titleInput = inputValue;
  // }
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  // set an anonymous function for the date.
  DateTime? selectedDate;

  // no need to check category since it has a default value thus wont be empty
  Category selectedCategory = Category.leisure;

  // function to get and open a date picker
  void datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(
      () {
        print(pickedDate);
        selectedDate = pickedDate;
        print("Selected Date: $selectedDate");
      },
    );
  }

  void _showPlatformDialog() {
    if (Platform.isAndroid) {
      // show error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Invalid Input',
          ),
          content: const Text(
            "Please ensure a valid form data has been entered.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Okay',
              ),
            )
          ],
        ),
      );
    } else {
      // show error message
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text(
            'Invalid Input',
          ),
          content: const Text(
            "Please ensure a valid form data has been entered.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Okay',
              ),
            )
          ],
        ),
      );
    }
  }

  // complete function to submit the data to the list of existing expenses(data)
  void submitData() {
    // 1: validate the user inputs first
    final enteredAmount = double.tryParse(amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      _showPlatformDialog();
      return;
    }

    // 2: Add the validated data to the backend or in this case data list
    widget.onAddExpense(
      Expense(
        title: titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: selectedCategory,
      ),
    );

    // 3: close the modal once the data has been added
    Navigator.pop(context);
  }

  // clear any inut data once the modal has been closed
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          // wrapping the padding widget with the sincglescrollview makes
          // it scrollable for the form after adding the keyboard height
          // to the bottom padding
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              26,
              26,
              26,
              keyboardSpace +
                  26, // added the keyboard height to the bottom padding to push the form contents further upward
            ),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: Text(
                    'Add New Expense',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          autocorrect: true,
                          controller: titleController,
                          maxLength: 255,
                          enableSuggestions: true,
                          enableInteractiveSelection: true,
                          decoration: const InputDecoration(
                            label: Text(
                              'Title of Expense',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          autocorrect: false,
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          enableSuggestions: true,
                          enableInteractiveSelection: true,
                          decoration: const InputDecoration(
                            prefixText: "\$ ",
                            label: Text(
                              'Amount Spent',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    autocorrect: true,
                    controller: titleController,
                    maxLength: 255,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,
                    decoration: const InputDecoration(
                      label: Text(
                        'Title of Expense',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'No Selected Date'
                                  : formatter.format(selectedDate!),
                            ),
                            IconButton(
                              onPressed: datePicker,
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autocorrect: false,
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          enableSuggestions: true,
                          enableInteractiveSelection: true,
                          decoration: const InputDecoration(
                            prefixText: "\$ ",
                            label: Text(
                              'Amount Spent',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'No Selected Date'
                                  : formatter.format(selectedDate!),
                            ),
                            IconButton(
                              onPressed: datePicker,
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      if (width < 600)
                        DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(
                              () {
                                selectedCategory = value;
                              },
                            );
                          },
                        ),
                      const Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black87),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber.shade600),
                        ),
                        onPressed: submitData,
                        child: const Text(
                          'Save Expenses',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade600),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancle',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
