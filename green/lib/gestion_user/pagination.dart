import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final Function(int) onPageChanged;
  final int visiblePageCount; // Number of visible page buttons.

  PaginationWidget({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
    this.visiblePageCount = 10, // Default to showing 5 page numbers.
  });

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalItems / pageSize).ceil();
    int halfPageToShow = visiblePageCount ~/ 2;

    int startPage = currentPage - halfPageToShow;
    startPage = startPage <= 0 ? 1 : startPage;

    int endPage = startPage + visiblePageCount;
    endPage = endPage > totalPages ? totalPages : endPage;

    List<Widget> pageItems = List<Widget>.generate(
      endPage - startPage + 1,
      (index) {
        int pageNumber = startPage + index;
        bool isCurrentPage = pageNumber == currentPage;
        return Container(
          margin: EdgeInsets.all(2), // Space between page buttons
          decoration: BoxDecoration(
            color: isCurrentPage ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isCurrentPage ? null : () => onPageChanged(pageNumber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  pageNumber.toString(),
                  style: TextStyle(
                    color: isCurrentPage ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ...pageItems,
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}
