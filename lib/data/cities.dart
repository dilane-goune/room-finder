const jeddahCities = [
  "Al-Murjan",
  "Al-Basateen",
  "Al-Mohamadiya",
  "Ash-Shati",
  "An-Nahda",
  "An-Naeem",
  "An-Nozha",
  "Az-Zahraa",
  "As-Salamah",
  "Al-Bawadi",
  "Ar-Rabwa",
  "As-Safa",
  "Al-Khalidiya",
  "Ar-Rawdha",
  "Al-Faysaliya",
  "Al-Andalus",
  "Al-Aziziya",
  "Ar-Rihab",
  "Al-Hamraa",
  "Al-Mosharafa",
  "Ar-Roweis",
  "Ash-Sharafiya",
  "Bani Malik",
  "Al-Woroud",
  "An-Naseem",
  "Al-Baghdadiya Ash-Sharqiya",
  "Al-Amariya",
  "Al-Hindawiya29. As-Saheifa",
  "Al-Kandra",
  "As-Sulaimaniya",
  "Al-Thaalba",
  "As-Sabeel",
  "Al-Qurayat",
  "Gholail",
  "An-Nozla Al-Yamaniya",
  "Al-Nozla Ash-Sharqiya",
  "Al-Taghr",
  "Al-Jamaa",
  "Madayin Al-Fahad",
  "Ar-Rawabi",
  "Al-Wazeeriya",
  "Petromin",
  "Al-Mahjar",
  "Prince Abdel Majeed",
  "Obhour Al-Janobiya",
  "Al-Marwa",
  "AL-Fayhaa",
  "King Abdul Al-Aziz University",
  "Al-Baghdadiya Al-Gharbiya",
  "Al-Balad",
  "Al-Ajwad",
  "Al-Manar",
  "As-Samer",
  "Abruq Ar-Roghama",
  "Madinat As-Sultan",
  "Um Hablain",
  "Al-Hamdaniya59. Al-Salhiya",
  "Mokhatat Al-Aziziya",
  "Mokhatat Shamal Al-Matar",
  "Mokhatat Ar-Riyadh",
  "Mokhatat Al-Huda",
  "Braiman",
  "Al-Salam",
  "Al-Mostawdaat",
  "Al-Montazahat",
  "Kilo 14",
  "Al-Harazat",
  "Um As-Salam",
  "Mokhtat Zahrat Ash-Shamal",
  "Al-Majid",
  "Gowieza",
  "Al-Gozain",
  "Al-Kuwait",
  "Al-Mahrogat",
  "Al-Masfa",
  "Al-Matar Al-Gadeem (old airport)",
  "Al-Bokhariya",
  "An-Nour",
  "Bab Shareif",
  "Bab Makkah",
  "Bahra",
  "Al-Amir Fawaz",
  "Wadi Fatma",
  "Obhour Shamaliya",
  "At-Tarhil (deportation)",
  "Al-Iskan Al-janoubi89. At-Tawfeeq",
  "Al-Goaid",
  "Al-Jawhara",
  "Al-Jamoum",
  "Al-Khumra",
  "Ad-Difaa Al-Jawi (Air Defense)",
  "Ad-Dageeg",
  "Ar-Robou",
  "Ar-Rabie",
  "Ar-Rehaily",
  "As-Salmiya",
  "As-Sanabil",
  "As-Sinaiya (Bawadi)",
  "Industrial City (Mahjar)",
  "Al-Adl",
  "Al-Olayia",
  "Al-Faihaa",
  "Al-Karanteena",
  "Al-Ajaweed",
  "Al-Ahmadiya",
  "Al-Mosadiya",
  "East Al-Khat As-Sarei",
  "Kilo 10",
  "King Faisal Navy Base",
  "Kilo 7",
  "Kilo 3",
  "King Faisal Guard City",
  "Kilo 11",
  "Thowal",
  "Kilo 13119. Al-Makarona",
  "Al-Layth",
  "Al-Gonfoda",
  "Rabegh",
  "Kilo 8",
  "Kilo 5",
  "Kilo 2",
  "Al-Mokhwa",
  "National Guard Residence",
  "As-Showag",
  "Air Defense Residence",
  "Al-Morsalat",
  "Ash-Shoola",
  "Al-Corniche",
  "Al-Waha",
  "Mokhatat Al-Haramain",
  "Kholais",
];

const meccaCities = [
  "Al Faisaliah",
  "Ajyad fortress",
  "Al Adl",
  "Al faisaliah",
  "Al Hindawiyah",
  "Al Iskan",
  "Al Jumaizah",
  "Al Maabdah",
  "Al Muaisem",
  "Al Rasaifah",
  "Al Shoqiyah",
  "Al Shubaikah",
  "Al Sulaymaniyyah",
  "Al Utaybiyyah",
  "Al Zahir",
  "Al Zahra",
  "Al-Khalidiya",
  "Aziziyah",
  "Gazza",
  "Jabal Al Nour",
  "Jabal Omar",
  "Jurhum",
  "Misfalah",
  "Muzdalifah",
  "Shar Mansur",
];

const riyadhCities = [
  "Al-Dirah",
  "Mi'kal",
  "Manfuha",
  "Manfuha Al-Jadidah",
  "Al-'Oud",
  "Al-Mansoorah",
  "Al-Margab",
  "Salam",
  "Jabrah",
  "Al-Yamamah",
  "Otayyigah",
  "Al-'Olayya",
  "Al-Sulaymaniyah",
  "Al Izdihar",
  "King Fahd District",
  "Al-Masif",
  "Al-Murooj",
  "Al-Mugharrazat",
  "Al-Wurood",
  "Dharat Nemar",
  "Tuwaiq",
  "Hazm",
  "Nemar",
  "Deerab",
  "Al-Rabwah",
  "Jarir",
  "Al-Malaz",
  "Al-Murabba'",
  "Al-Shifa",
  "Al-Mansuriyya",
  "Al-Marwah",
  "Al-Masani'",
  "Al-Urayja",
  "Al-Urayja Al-Wusta (Mid-Urayja)",
  "Al-Urayja (West)",
  "Shubra",
  "Dharat Laban",
  "Hijrat Laban",
  "As-Suwaidi",
  "As-Suwaidi (West)",
  "Sultanah",
  "Al-Malga",
  "Al-Sahafa",
  "Hittin",
  "Al-Wadi",
  "Al-Ghadir",
  "Al-Nafil",
  "Al-Qayrawan",
  "Al-Aqiq",
  "Al-Selayy",
  "Ad Difa'",
  "Al Iskan",
  "Khashm Al-'Aan",
  "Al-Sa'adah",
  "Al-Fayha",
  "Al-Manakh",
  "Al-Rawdhah",
  "Al-Qadisiyah",
  "Al-M'aizliyyah",
  "Al-Nahdhah",
  "Gharnatah",
  "Qurtubah",
  "Al-Hamra",
  "Al-Qouds",
  "Al-Naseem (East)",
  "Al-Naseem",
  "As-Salam",
  "Al-Manar",
  "Al-Rimayah",
  "Al-Nadheem",
  "Al-Rayyan",
  "Irqah",
  "Al Aziziyah",
  "Al-Ma'athar",
  "Al-Shemaysi",
];

const dubaiCities = [
  "Dubai Marina",
  "Jumeirah Beach Residence",
  "Al Barsha",
  "Jumeirah Lake Towers",
  "Discovery Gardens",
  "Dubai Investments Park",
  "Jebel Ali Gardens",
  "Dubai Silicon Oasis",
  "International City",
  "Deira",
  "Abu Hail",
  "Al Waheda",
  "Bur Dubai",
  "Karama",
  "Al Quoz",
  "Downtown Dubai",
  "Business Bay",
  "Jumeirah",
  "Jebel Ali",
  "Palm Jumeirah",
];

const abuDahbiCities = [
  "Al Baladia",
  "Al bateen",
  "Al Dhafrah",
  "Saadiyat Island",
  "Yas Island",
  "Masdar City",
  "Al-Shahamah",
  "Al-Bahiyah",
  "Jubail Island",
  "Khalifa Port",
];

const sharjahCities = [
  "Al Majaz",
  "Al Nahda",
  "Al Taawun",
  "Al Nabba",
  "Al Layyeh",
];

const unitedArabEmiteCities = [
  "Dubai",
  "Abu Dhabi",
  "Sharjah",
  "Umm al-Quwain",
  "Fujairah",
  "Ajam",
];
var unitedArabEmiteLocations = [
  ...dubaiCities,
  ...abuDahbiCities,
  ...sharjahCities,
];