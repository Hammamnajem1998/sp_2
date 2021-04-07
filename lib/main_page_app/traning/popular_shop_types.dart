class PopularShopTypesList {
  PopularShopTypesList({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularShopTypesList> popularFList = <PopularShopTypesList>[
    PopularShopTypesList(
      titleTxt: 'Doctor',
      isSelected: false,
    ),
    PopularShopTypesList(
      titleTxt: 'Barber',
      isSelected: false,
    ),
    PopularShopTypesList(
      titleTxt: 'Bank',
      isSelected: true,
    ),
    PopularShopTypesList(
      titleTxt: 'Service',
      isSelected: false,
    ),
    PopularShopTypesList(
      titleTxt: 'Other',
      isSelected: false,
    ),
  ];

}
