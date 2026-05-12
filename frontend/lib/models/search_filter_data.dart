import 'package:antipattern/models/photocards.dart';

class SearchFilterData {
  final List<String> locations;
  final List<String> shipsTo;
  final List<String> shippingMethods;
  final List<String> languages;
  final List<String> tags;
  final List<String> groups;
  final List<String> members;
  final List<String> albums;
  final List<String> eras;
  final List<String> cardTypes;
  final List<String> rarities;

  SearchFilterData({
    required this.locations,
    required this.shipsTo,
    required this.shippingMethods,
    required this.languages,
    required this.tags,
    required this.groups,
    required this.members,
    required this.albums,
    required this.eras,
    required this.cardTypes,
    required this.rarities,
  });

  factory SearchFilterData.fromListings(List<Listings> listings) {
    final locations = <String>{};
    final shipsTo = <String>{};
    final shippingMethods = <String>{};
    final languages = <String>{};
    final tags = <String>{};
    final groups = <String>{};
    final members = <String>{};
    final albums = <String>{};
    final eras = <String>{};
    final cardTypes = <String>{};
    final rarities = <String>{};

    for (final item in listings) {
      if (item.location.isNotEmpty) locations.add(item.location);
      shipsTo.addAll(item.deliversTo);

      if (item.shippingMethod != null) {
        shippingMethods.add(item.shippingMethod!);
      }
      if (item.language != null) {
        languages.add(item.language!);
      }

      tags.addAll(item.tags);

      if (item.group != null) groups.add(item.group!);
      if (item.member != null) members.add(item.member!);
      if (item.album != null) albums.add(item.album!);
      if (item.era != null) eras.add(item.era!);
      if (item.cardType != null) cardTypes.add(item.cardType!);
      if (item.rarity != null) rarities.add(item.rarity!);
    }

    return SearchFilterData(
      locations: locations.toList()..sort(),
      shipsTo: shipsTo.toList()..sort(),
      shippingMethods: shippingMethods.toList()..sort(),
      languages: languages.toList()..sort(),
      tags: tags.toList()..sort(),
      groups: groups.toList()..sort(),
      members: members.toList()..sort(),
      albums: albums.toList()..sort(),
      eras: eras.toList()..sort(),
      cardTypes: cardTypes.toList()..sort(),
      rarities: rarities.toList()..sort(),
    );
  }
}
