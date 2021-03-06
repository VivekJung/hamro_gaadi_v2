import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

//TODO: put this list in buttons
List categoriesList = [
  "Route Income",
  "Bank Transaction",
  "Repair & Maintenance",
  "Salary Expenses",
  "Personal Expenses",
  "Food & Drinks",
  "Salary & Bonus",
  "Vehicle Fuel",
  "Miscellaneous",
];

getCategoryWiseIcon(String? category) {
  IconData icon;
  if (category == "Bank Transaction") {
    icon = Ionicons.home;
  } else if (category == "Salary Expenses") {
    icon = Ionicons.cash;
  } else if (category == "Personal Expenses") {
    icon = Ionicons.person;
  } else if (category == "Repair & Maintenance") {
    icon = Ionicons.build;
  } else if (category == "Route Income") {
    icon = Ionicons.cash;
  } else if (category == "Food & Drinks") {
    icon = Ionicons.fast_food;
  } else if (category == "Salary & Bonus") {
    icon = Ionicons.people;
  } else if (category == "Vehicle Fuel") {
    icon = Ionicons.flash;
  } else if (category == "Miscellaneous") {
    icon = Ionicons.list;
  } else {
    icon = Ionicons.cog;
  }

  return icon;
}
