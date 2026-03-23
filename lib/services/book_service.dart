import 'dart:async';
import '../models/book_model.dart';

class BookService {
  final List<BookModel> _allBooks = [
    BookModel(
      id: 'hanuman_chalisa',
      title: 'Hanuman Chalisa',
      author: 'Tulsidas',
      category: 'Chalisa',
      deity: 'Hanuman',
      language: 'Hindi',
      translations: {
        'English': '''
Shri Guru Charan Saroj Raj, Nij Manu Mukuru Sudhari,
Barnau Raghuvar Bimal Jasu, Jo Dayaku Phal Chari.

Buddhiheen Tanu Janike, Sumirau Pavan Kumar,
Bal Buddhi Vidya Dehu Mohi, Harahu Kalesh Bikaar.

Jai Hanuman Gyan Gun Sagar,
Jai Kapis Tihun Lok Ujagar.
Ram Doot Atulit Bal Dhama,
Anjani Putra Pavan Sut Nama.

Mahavir Vikram Bajrangi,
Kumati Nivar Sumati Ke Sangi.
Kanchan Baran Viraj Subesa,
Kanan Kundal Kunchit Kesa.

Hath Vajra Aur Dhvaja Viraje,
Kandhe Moonj Janeu Saje.
Sankar Suvan Kesari Nandan,
Tej Pratap Maha Jag Vandan.

Vidyavan Guni Ati Chatur,
Ram Kaj Karibe Ko Atur.
Prabu Charitra Sunibe Ko Rasiya,
Ram Lakhan Sita Man Basiya.

Sukshma Roop Dhari Siyahi Dikhava,
Vikat Roop Dhari Lanka Jarava.
Bhima Roop Dhari Asur Sanhare,
Ramachandra Ke Kaj Sanvare.

Laye Sanjivan Lakhan Jiyaye,
Shri Raghuvir Harashi Ur Laye.
Raghupati Kinhi Bahut Badai,
Tum Mama Priya Bharat-hi Sam Bhai.

Sahas Badan Tumharo Jas Gave,
Asa Kahi Shripati Kanth Lagave.
Sanakadik Brahmadi Munisa,
Narad Sarad Sahit Ahisa.

Yam Kuber Digpal Jahan Te,
Kavi Kovid Kahi Sake Kahan Te.
Tum Upkar Sugrivahi Kinha,
Ram Milaye Rajpad Dinha.

Tumharo Mantra Vibhishan Mana,
Lankeshvar Bhaye Sab Jag Jana.
Yug Sahasra Jojan Par Bhanu,
Lilyo Tahi Madhur Phal Janu.

Prabu Mudrika Meli Mukh Mahi,
Jaladhi Langhi Gaye Achraj Nahi.
Durgaam Kaj Jagat Ke Jete,
Sugam Anugraha Tumhare Tete.

Ram Duare Tum Rakhvare,
Hot Na Agya Bin Paisare.
Sab Sukh Lahe Tumhari Sarana,
Tum Rakshak Kahu Ko Darna.

Apan Tej Samharo Ape,
Tinon Lok Hank Te Kampe.
Bhoot Pisach Nikat Nahi Ave,
Mahavir Jab Nam Sunave.

Nase Rog Hare Sab Pira,
Japat Nirantar Hanumat Bira.
Sankat Se Hanuman Chudave,
Man Kram Vachan Dhyan Jo Lave.

Sab Par Ram Tapasvee Raja,
Tin Ke Kaj Sakal Tum Saja.
Aur Manorath Jo Koi Lave,
Sohi Amit Jivan Phal Pave.

Charon Yug Partap Tumhara,
Hai Parsiddh Jagat Ujiyara.
Sadhu Sant Ke Tum Rakhvare,
Asur Nikandan Ram Dulare.

Ashta Siddhi Nav Nidhi Ke Data,
Asa Var Din Janki Mata.
Ram Rasayan Tumhare Pasa,
Sada Raho Raghupati Ke Dasa.

Tumhare Bhajan Ram Ko Pave,
Janam Janam Ke Dukh Bisrave.
Anta Kaal Raghubar Pur Jai,
Jahan Janma Hari-Bhakta Kahai.

Aur Devata Chitt Na Dharahi,
Hanumat Sei Sarva Sukh Karahi.
Sankat Kate Mite Sab Pira,
Jo Sumire Hanumat Balbira.

Jai Jai Jai Hanuman Gosahin,
Kripa Karahu Gurudev Ki Nyahin.
Jo Sat Bar Path Kare Kohi,
Chutahi Bandhi Maha Sukh Hoi.

Jo Yeh Padhe Hanuman Chalisa,
Hoye Siddhi Sakhi Gaurisa.
Tulsidas Sada Hari Chera,
Keejai Das Hriday Mein Dera.

Pavan Tanay Sankat Haran,
Mangal Moorti Roop.
Ram Lakhan Sita Sahit,
Hriday Basahu Sur Bhoop.
''',
        'Hindi': '''
श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि ।
बरनउँ रघुबर बिमल जसु जो दायक फल चारि ॥

बुद्धिहीन तनु जानिकै सुमिरौ पवन-कुमार ।
बल बुधि बिद्या देहु मोहिं हरहु कलेस बिकार ॥

जय हनुमान ज्ञान गुन सागर ।
जय कपीस तिहुँ लोक उजागर ॥

राम दूत अतुलित बल धामा ।
अंजनि-पुत्र पवनसुत नामा ॥

महाबीर बिक्रम बजरंगी ।
कुमति निवार सुमति के संगी ॥

कंचन बरन बिराज सुबेसा ।
कानन कुंडल कुंचित केसा ॥

हाथ बज्र औ ध्वजा बिराजै ।
काँधे मूँज जनेऊ साजै ॥

संकर सुवन केसरी नंदन ।
तेज प्रताप महा जग बंदन ॥

बिद्यावान गुनी अति चातुर ।
राम काज करिबे को आतुर ॥

प्रभु चरित्र सुनिबे को रसिया ।
राम लखन सीता मन बसिया ॥

सूक्ष्म रूप धरि सियहिं दिखावा ।
बिकट रूप धरि लंक जरावा ॥

भीम रूप धरि असुर सँहारे ।
रामचंद्र के काज सँवारे ॥

लाय सँजीवन लखन जियाये ।
श्रीरघुबीर हरषि उर लाये ॥

रघुपति कीन्ही बहुत बड़ाई ।
तुम मम प्रिय भरतहि सम भाई ॥

सहस बदन तुम्हरो जस गावैं ।
अस कहि श्रीपति कंठ लगावैं ॥

सनकादिक ब्रह्मादि मुनीसा ।
नारद सारद सहित अहीसा ॥

यम कुबेर दिगपाल जहाँ ते ।
कबि कोबिद कहि सके कहाँ ते ॥

तुम उपकार सुग्रीवहिं कीन्हा ।
राम मिलाय राजपद दीन्हा ॥

तुम्हरो मंत्र बिभीषन माना ।
लंकेस्वर भए सब जग जाना ॥

जुग सहस्र जोजन पर भानू ।
लील्यो ताहि मधुर फल जानू ॥

प्रभु मुद्रिका मेलि मुख माहीं ।
जलधि लाँघि गये अचरज नाहीं ॥

दुर्गम काज जगत के जेते ।
सुगम अनुग्रह तुम्हरे तेते ॥

राम दुआरे तुम रखवारे ।
होत न आज्ञा बिनु पैसारे ॥

सब सुख लहै तुम्हारी सरना ।
तुम रक्षक काहू को डरना ॥

आपन तेज सम्हारो आपै ।
तीनों लोक हाँक तें काँपै ॥

भूत पिसाच निकट नहिं आवै ।
महाबीर जब नाम सुनावै ॥

नासै रोग हरै सब पीरा ।
जपत निरंतर हनुमत बीरा ॥

संकट तें हनुमान छुड़ावै ।
मन क्रम बचन ध्यान जो लावै ॥

सब पर राम तपस्वी राजा ।
तिन के काज सकल तुम साजा ॥

और मनोरथ जो कोइ लावै ।
सोई अमित जीवन फल पावै ॥

चारों जुग परताप तुम्हारा ।
है परसिद्ध जगत उजियारा ॥

साधु संत के तुम रखवारे ।
असुर निकंदन राम दुलारे ॥

अष्ट सिद्धि नव निधि के दाता ।
अस बर दीन जानकी माता ॥

राम रसायन तुम्हरे पासा ।
सदा रहो रघुपति के दासा ॥

तुम्हरे भजन राम को पावै ।
जनम जनम के दुख बिसरावै ॥

अंत काल रघुबर पुर जाई ।
जहाँ जन्म हरि-भक्त कहाई ॥

और देवता चित्त न धरई ।
हनुमत सेइ सर्ब सुख करई ॥

संकट कटै मिटै सब पीरा ।
जो सुमिरै हनुमत बलबीरा ॥

जै जै जै हनुमान गोसाईं ।
कृपा करहु गुरुदेब की नाईं ॥

जो सत बार पाठ कर कोई ।
छूटहि बंदि महा सुख होई ॥

जो यह पढ़े हनुमान चालीसा ।
होय सिद्धि साखी गौरीसा ॥

तुलसीदास सदा हरि चेरा ।
कीजै नाथ हृदय महँ डेरा ॥

पवनतनय संकट हरन मंगल मूरति रूप ।
राम लखन सीता सहित हृदय बसहु सुर भूप ॥
'''
      },
      content: 'Shri Guru Charan Saroj Raj...',
    ),
    BookModel(
      id: 'ramraksha_stotra',
      title: 'Ramraksha Stotra',
      author: 'Budha Kaushika',
      category: 'Stotra',
      deity: 'Ram',
      language: 'Sanskrit',
      translations: {
        'English': 'Asya Sri Rama Raksha Stotra Mantrasya...',
        'Hindi': 'अस्य श्रीरामरक्षास्तोत्रमन्त्रस्य...',
      },
      content: 'Asya Sri Rama Raksha Stotra Mantrasya.',
    ),
    BookModel(
      id: 'ganesh_stotra',
      title: 'Ganesh Stotra',
      author: 'Narada',
      category: 'Stotra',
      deity: 'Ganesh',
      language: 'Sanskrit',
      translations: {
        'English': 'Pranamya Shirasa Devam...',
        'Hindi': 'प्रणम्य शिरसा देवं...',
      },
      content: 'Pranamya Shirasa Devam.',
    ),
  ];

  Future<List<BookModel>> getBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allBooks;
  }

  Future<List<BookModel>> getBooksByDeity(String deity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allBooks.where((b) => b.deity == deity).toList();
  }

  Future<BookModel?> getBookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allBooks.firstWhere((b) => b.id == id);
  }
}
