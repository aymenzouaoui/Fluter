class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
       titleTxt: 'Active Users',
      isSelected: false,
    ),
    PopularFilterListData(
       titleTxt: 'Premium Users',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Admin Users',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Inactive Users',
      isSelected: false,
    ),
    PopularFilterListData(
       titleTxt: 'Regular Users',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
  PopularFilterListData(
    titleTxt: 'All',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Non-Payment (NP)',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Inappropriate Behavior (IB)',
    isSelected: true,
  ),
  PopularFilterListData(
    titleTxt: 'Fraudulent Activities (AF)',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Violation of Terms of Service (TOS)',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Malicious Content Circulation (MCC)',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Non-Respect of Copyright (NRC)',
    isSelected: false,
  ),
  PopularFilterListData(
    titleTxt: 'Abusive Usage (AU)',
    isSelected: false,
  ),
];

}
