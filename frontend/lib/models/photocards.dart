
class Listings {
  final String id;
  final String title;
  final String sellerName;
  final String itemName;
  final String description;
  final List<String> imageUrls;
  final double price;

  // ------------------- K-POP SPECIFIC METADATA -------------------
  final String? group;
  final String? member;
  final String? album;
  final String? era;
  final String? version;
  final String? cardType;      // photocard, POB, lucky draw, lomo, etc
  final String? rarity;

  // ------------------- MARKET / LOGISTICS ------------------------
  final String location;        // REQUIRED
  final List<String> deliversTo;
  final String? shippingMethod; // EMS, DOMS, DHL, FedEx, etc
  final String? language;       // EN / KR / JP / CN
  final bool verifiedSeller;

  // ------------------- TAGS (trade modes + extra labels) ----------
  final List<String> tags;

  Listings({
    required this.title,
    required this.sellerName,
    required this.itemName,
    required this.description,
    required this.imageUrls,
    required this.price,
    required this.location,

    this.deliversTo = const [],
    this.shippingMethod,
    this.language,

    this.group,
    this.member,
    this.album,
    this.era,
    this.version,
    this.cardType,
    this.rarity,

    this.verifiedSeller = false,
    this.tags = const [],

    String? id,
  }) : id = id ??
            title
                .toLowerCase()
                .replaceAll(RegExp(r'\s+'), '-')
                .replaceAll(RegExp(r'[^a-z0-9\-]'), '');

  Listings.notFound(String missingId)
      : id = missingId,
        title = "Not Found",
        sellerName = "N/A",
        itemName = "N/A",
        description = "This listing does not exist or was removed.",
        imageUrls = const [],
        price = 0.0,
        group = null,
        member = null,
        album = null,
        era = null,
        version = null,
        cardType = null,
        rarity = null,
        location = "Unknown",
        deliversTo = const [],
        shippingMethod = null,
        language = null,
        verifiedSeller = false,
        tags = const [];
}

// ----------------------------------------------------------------------
// DUMMY LISTINGS (5 EXAMPLES)
// ----------------------------------------------------------------------

final List<Listings> dummyListings = [

  // ------------------------------------------------------------
  // 1 — LE SSERAFIM Chaewon FEARLESS
  // ------------------------------------------------------------
  Listings(
    title: "LE SSERAFIM Chaewon – FEARLESS Era",
    sellerName: "kpopvault",
    itemName: "Chaewon FEARLESS PC",
    description: "Pulled myself, sleeved immediately. No scratches.",
    imageUrls: [
      "https://picsum.photos/seed/chaewon1/600/900",
    ],
    price: 350.00,
    location: "Seoul, KR",
    deliversTo: ["WW", "USA", "EU", "India"],
    shippingMethod: "Korea Post / EMS",
    language: "EN",
    verifiedSeller: true,
    group: "LE SSERAFIM",
    member: "Chaewon",
    album: "FEARLESS",
    era: "FEARLESS",
    version: "Standard",
    cardType: "Photocard",
    rarity: "Official",
    tags: ["Official", "Album Pull", "WTS", "WW"],
  ),

  // ------------------------------------------------------------
  // 2 — NewJeans Minji OMG POB
  // ------------------------------------------------------------
  Listings(
    title: "NewJeans Minji – OMG POB",
    sellerName: "mintlover07",
    itemName: "Minji OMG Preorder Benefit",
    description: "Official Weverse POB. Toploader included.",
    imageUrls: [
      "https://picsum.photos/seed/minji1/600/900",
      "https://picsum.photos/seed/minji2/600/900",
    ],
    price: 799.99,
    location: "Tokyo, JP",
    deliversTo: ["WW"],
    shippingMethod: "FedEx",
    language: "JP",
    verifiedSeller: true,
    group: "NewJeans",
    member: "Minji",
    album: "OMG",
    era: "OMG",
    version: "Weverse POB",
    cardType: "POB",
    rarity: "Exclusive",
    tags: ["POB", "Exclusive", "WTS"],
  ),

  // ------------------------------------------------------------
  // 3 — Stray Kids Hyunjin MAXIDENT Lomo
  // ------------------------------------------------------------
  Listings(
    title: "Stray Kids Hyunjin – MAXIDENT Lomo",
    sellerName: "stay4ever",
    itemName: "Hyunjin Lomo Card",
    description: "Unofficial lomo. Good for collection only.",
    imageUrls: [
      "https://picsum.photos/seed/hyunjin1/600/900",
    ],
    price: 120.0,
    location: "LA, USA",
    deliversTo: ["USA", "CAN"],
    shippingMethod: "USPS",
    language: "EN",
    verifiedSeller: false,
    group: "Stray Kids",
    member: "Hyunjin",
    album: "MAXIDENT",
    era: "MAXIDENT",
    cardType: "Lomo",
    rarity: "Unofficial",
    tags: ["Lomo", "WTS", "USA Only"],
  ),

  // ------------------------------------------------------------
  // 4 — IVE Wonyoung LOVE DIVE Signed
  // ------------------------------------------------------------
  Listings(
    title: "IVE Wonyoung – LOVE DIVE Signed PC",
    sellerName: "starshoppe",
    itemName: "Wonyoung Signed Card",
    description: "Event-signed card. Proof video available.",
    imageUrls: [
      "https://picsum.photos/seed/wonyoung1/600/900",
      "https://picsum.photos/seed/wonyoung2/600/900",
    ],
    price: 5500.00,
    location: "Bangkok, TH",
    deliversTo: ["WW"],
    shippingMethod: "DHL Express",
    language: "EN",
    verifiedSeller: true,
    group: "IVE",
    member: "Wonyoung",
    album: "LOVE DIVE",
    era: "LOVE DIVE",
    cardType: "Signed",
    rarity: "Rare",
    tags: ["Signed", "Rare", "WTS", "Proofs"],
  ),

  // ------------------------------------------------------------
  // 5 — BTS Jungkook MOTS ONE Lucky Draw
  // ------------------------------------------------------------
  Listings(
    title: "BTS Jungkook – MOTS ONE Lucky Draw",
    sellerName: "bangtantradehub",
    itemName: "Jungkook Lucky Draw PC",
    description: "Concert pop-up lucky draw. Mint condition.",
    imageUrls: [
      "https://picsum.photos/seed/jk1/600/900",
      "https://picsum.photos/seed/jk2/600/900",
    ],
    price: 4800.00,
    location: "Busan, KR",
    deliversTo: ["WW", "EU"],
    shippingMethod: "EMS / DHL",
    language: "KR",
    verifiedSeller: true,
    group: "BTS",
    member: "Jungkook",
    album: "MAP OF THE SOUL : ONE",
    era: "MOTS ONE",
    cardType: "Lucky Draw",
    rarity: "Premium",
    tags: ["Lucky Draw", "Rare", "WTS"],
  ),

  // ------------------------------------------------------------
  // 6 — aespa Karina MY WORLD
  // ------------------------------------------------------------
  Listings(
    title: "aespa Karina – MY WORLD Album PC",
    sellerName: "aespa_collect",
    itemName: "Karina Album Pull",
    description: "Album pull. Near mint.",
    imageUrls: [
      "https://picsum.photos/seed/karina1/600/900",
    ],
    price: 280.00,
    location: "Seoul, KR",
    deliversTo: ["WW"],
    shippingMethod: "EMS",
    language: "KR",
    verifiedSeller: true,
    group: "aespa",
    member: "Karina",
    album: "MY WORLD",
    era: "MY WORLD",
    cardType: "Photocard",
    rarity: "Official",
    tags: ["Album Pull", "WTS"],
  ),

  // ------------------------------------------------------------
  // 7 — TWICE Sana Ready To Be
  // ------------------------------------------------------------
  Listings(
    title: "TWICE Sana – Ready To Be PC",
    sellerName: "once_market",
    itemName: "Sana Ready To Be",
    description: "Official photocard. Stored in binder.",
    imageUrls: [
      "https://picsum.photos/seed/sana1/600/900",
    ],
    price: 320.00,
    location: "Osaka, JP",
    deliversTo: ["WW"],
    shippingMethod: "Japan Post",
    language: "JP",
    verifiedSeller: true,
    group: "TWICE",
    member: "Sana",
    album: "READY TO BE",
    era: "READY TO BE",
    cardType: "Photocard",
    rarity: "Official",
    tags: ["Official", "WTS"],
  ),
];