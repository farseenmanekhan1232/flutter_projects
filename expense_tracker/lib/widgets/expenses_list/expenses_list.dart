import 'package:flutter/material.dart';

import "package:expense_tracker/models/expense.dart";

import "package:expense_tracker/widgets/expenses_list/expenses_item.dart";

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expensesList, required this.onRemoveExpense});

  final List<Expense> expensesList;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(context) {
    return (ListView.builder(
      itemCount: expensesList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(expensesList[index]),
          onDismissed: (direction) {
            onRemoveExpense(expensesList[index]);
          },
          child: ExpenseItem(expensesList[index]),
        );
      },
    ));
  }
}
