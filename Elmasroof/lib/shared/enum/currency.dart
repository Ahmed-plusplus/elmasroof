enum Currency {
  pound('Pound', 'assets/images/pound_icon.svg'),
  dollar('Dollar', 'assets/images/dollar_icon.svg'),
  gold18('Gold 18', 'assets/images/gold_bar_18.svg'),
  gold21('Gold 21', 'assets/images/gold_bar_21.svg'),
  gold24('Gold 24', 'assets/images/gold_bar_24.svg');

  final String name;
  final String icon;

  const Currency(
    this.name,
    this.icon,
  );
}