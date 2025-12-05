import 'package:coffee_shop_dashboard/modules/layouts/layout.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_flex_item.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_responsiv.dart';
import 'package:flutter/material.dart';
import '../../core/helpers/colors.dart';
import '../../widgets/my_widgets/my_text.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(
        builder: (_, __, type) {
          return MyFlex(
            contentPadding: true,
            children: [
              MyFlexItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------------------
                    // TITLE + FILTERS ROW
                    // -------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          "Orders",
                          fontWeight: 700,
                          fontSize: 24,
                        ),
                        Row(
                          children: [
                            _dateFilter(),
                            const SizedBox(width: 16),
                            _sortFilter(),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 24),

                    // -------------------------------
                    // TABLE
                    // -------------------------------
                    _orderTable(),

                    const SizedBox(height: 50),

                    // -------------------------------
                    // PAGINATION
                    // -------------------------------
                    _pagination(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  // ------------------------------------------------------
  // DATE FILTER BUTTON
  // ------------------------------------------------------
  Widget _dateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kLightGreen.withOpacity(0.7),
      ),
      child: Row(
        children: const [
          Icon(Icons.calendar_today, size: 18, color: Colors.black54),
          SizedBox(width: 10),
          MyText("Aug 10, 2025"),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // SORT DROPDOWN BUTTON
  // ------------------------------------------------------
  Widget _sortFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kLightGreen.withOpacity(0.7),
      ),
      child: Row(
        children: const [
          Icon(Icons.filter_list, size: 18, color: Colors.black54),
          SizedBox(width: 10),
          MyText("newest to oldest"),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // ORDERS TABLE
  // ------------------------------------------------------
  Widget _orderTable() {
    final data = [
      ["Macchiato caramel", "Sophia Clark", "1 Coffee, 12 Donuts", "\$150", "Processing", Colors.orange],
      ["Cafe mocha", "Liam Harris", "4 Coffee", "\$40", "Shipped", Colors.blue],
      ["Latte miel", "Ava Turner", "12 Donuts", "\$120", "Completed", Colors.green],
      ["Latte simple", "Noah Carter", "2 Coffee, 3 Accessories", "\$300", "Completed", Colors.green],
    ];

    return Column(
      children: [
        // ---------------- TABLE HEADER ----------------
        Row(
          children:  [
            _headerCell("Order ID"),
            _headerCell("Customer Name"),
            _headerCell("Items"),
            _headerCell("Amount"),
            _headerCell("Order Status"),
          ],
        ),
        const Divider(),

        // ---------------- TABLE ROWS ----------------
        ...data.map((row) => _orderRow(row)),
      ],
    );
  }

  // HEADER CELL WIDGET
  static const TextStyle headerStyle =
  TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

  static Widget _headerCell(String text) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: MyText(text, style: headerStyle),
      ),
    );
  }

  // ------------------------------------------------------
  // ORDER ROW BUILDER
  // ------------------------------------------------------
  Widget _orderRow(List row) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.green),
                  const SizedBox(width: 10),
                  MyText(row[0]),
                ],
              ),
            ),
            Expanded(child: MyText(row[1])),
            Expanded(child: MyText(row[2])),
            Expanded(child: MyText(row[3])),

            // STATUS BUTTON
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 140,
                  padding:  EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: row[5].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: MyText(
                      row[4],
                      fontSize: 13,
                      fontWeight: 600,
                      color: row[5],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  // ------------------------------------------------------
  // PAGINATION
  // ------------------------------------------------------
  Widget _pagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.chevron_left, color: Colors.black54),
        const SizedBox(width: 16),
        _pageNumber(1, isSelected: true),
        _pageNumber(2),
        _pageNumber(3),
        _pageNumber(4),
        _pageNumber(5),
        const SizedBox(width: 16),
        const Icon(Icons.chevron_right, color: Colors.black54),
      ],
    );
  }

  Widget _pageNumber(int number, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isSelected ? kPrimaryGreen : Colors.transparent,
      ),
      child: MyText(
        "$number",
        color: isSelected ? colorWhite : colorBlack,
      ),
    );
  }
}
