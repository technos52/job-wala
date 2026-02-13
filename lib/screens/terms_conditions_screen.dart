import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool isHindi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isHindi ? 'नियम और शर्तें' : 'Terms and Conditions',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  isHindi = !isHindi;
                });
              },
              icon: Icon(
                Icons.language,
                color: const Color(0xFF007BFF),
                size: 20,
              ),
              label: Text(
                isHindi ? 'EN' : 'हिं',
                style: const TextStyle(
                  color: Color(0xFF007BFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF).withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isHindi ? _buildHindiContent() : _buildEnglishContent(),
        ),
      ),
    );
  }

  List<Widget> _buildEnglishContent() {
    return [
      _buildSection('Terms and Conditions', 'Last Updated: 7 / 1 / 2026'),
      _buildSection(
        '1. Introduction & Acceptance of Terms',
        'Welcome to All Job Open ("we", "our", "us"). These Terms and Conditions ("Terms") govern your access to and use of the All Job Open job search platform, including the mobile application and website (collectively, the "Service").\n\nBy accessing or using the Service, you confirm that you have read, understood, and agree to be bound by these Terms and our Privacy Policy, which is incorporated herein by reference. If you do not agree with these Terms, you must immediately stop using the Service.\n\nWe reserve the right to modify these Terms at any time. Updated Terms will be effective once posted. Continued use of the Service constitutes acceptance of the revised Terms.',
      ),
      _buildSection(
        '2. Definitions',
        'Service: The All Job Open platform for IT and Non-IT job seekers and recruiters.\n\nUser / You: Any person or entity using the Service, including Job Seekers and Recruiters.\n\nJob Seeker: A User searching or applying for jobs.\n\nRecruiter: A User posting job openings or searching for candidates.\n\nContent: All text, data, images, software, graphics, audio, video, and material available on the Service.\n\nUser-Generated Content: Content uploaded or shared by Users, including job posts, resumes, profiles, and messages.',
      ),
      _buildSection(
        '3. Eligibility',
        'By using the Service, you represent and warrant that:\n\n• You are at least 16 years of age.\n• You have the legal capacity to enter into a binding agreement.\n• You are not prohibited from using the Service under applicable laws.\n• You will comply with all applicable local, national, and international laws.',
      ),
      _buildSection('4. Account Registration & Security', ''),
      _buildSubSection(
        '4.1 Account Creation',
        'Some features require account registration. You agree to provide accurate, current, and complete information and to keep it updated.',
      ),
      _buildSubSection(
        '4.2 Account Security',
        'You are responsible for maintaining the confidentiality of your login credentials. You are solely responsible for all activities conducted through your account. You must notify us immediately of any unauthorized access or security breach.',
      ),
      _buildSection('5. User Responsibilities & Acceptable Use', ''),
      _buildSubSection(
        '5.1 Recruiters',
        '• Post only genuine, lawful, and accurate job openings.\n• Use candidate data solely for recruitment purposes related to posted jobs.\n• Not sell, misuse, or share candidate data without lawful authority.',
      ),
      _buildSubSection(
        '5.2 Job Seekers',
        '• Provide accurate and truthful profile and resume information.\n• Apply only for legitimate employment purposes.',
      ),
      _buildSection(
        '6. Prohibited Activities',
        '• Post unlawful, misleading, abusive, defamatory, obscene, or harmful content.\n• Impersonate any person or organization.\n• Use the Service for scams, solicitation, or unrelated commercial purposes.\n• Violate intellectual property rights.\n• Upload malware, viruses, or harmful code.\n• Attempt to reverse engineer or disrupt the Service.',
      ),
      _buildSection(
        '7. Nature of Service',
        'All Job Open is a facilitation platform only.\n\n• We do not guarantee the accuracy of job postings or candidate information.\n• We are not an employer, recruiter, or employment agency.\n• Employment decisions are solely between Job Seekers and Recruiters.',
      ),
      _buildSection(
        '8. Pricing, Payments & Refunds',
        '• Job searching for Job Seekers is generally free.\n• Recruiters or premium features may be subject to fees, as displayed on the Service.\n• All payments are non-refundable unless explicitly stated otherwise in writing.\n• Any refund request is subject to our sole discretion.',
      ),
      _buildSection(
        '9. Intellectual Property Rights',
        '• All platform content, excluding User-Generated Content, is owned by or licensed to All Job Open.\n• You may not copy, distribute, or modify any content without written permission.\n• All Job Open trademarks, logos, and brand assets may not be used without authorization.',
      ),
      _buildSection(
        '10. User-Generated Content',
        '• You retain ownership of your User-Generated Content.\n• You grant All Job Open a worldwide, non-exclusive, royalty-free license to use and display content for Service operation and promotion.\n• You confirm your content is lawful and does not infringe third-party rights.',
      ),
      _buildSection(
        '11. Confidentiality',
        'Users must treat all non-public information obtained through the Service as confidential. Recruiters must keep candidate information strictly confidential and use it only for recruitment purposes.',
      ),
      _buildSection(
        '12. Third-Party Services',
        'The Service may include links to third-party websites or services. We are not responsible for their content, privacy policies, or practices. Use them at your own risk.',
      ),
      _buildSection(
        '13. Disclaimers',
        'THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE."\n\nWe disclaim all warranties, express or implied, including merchantability, fitness for a particular purpose, and non-infringement. We do not guarantee uninterrupted, secure, or error-free service or job outcomes.',
      ),
      _buildSection(
        '14. Limitation of Liability',
        'To the maximum extent permitted by law, All Job Open shall not be liable for any indirect, incidental, consequential, or punitive damages. Our total liability shall not exceed the amount paid by you (if any) during the six (6) months preceding the claim.',
      ),
      _buildSection(
        '15. Indemnification',
        'You agree to indemnify and hold harmless All Job Open from claims arising out of:\n\n• Your use of the Service\n• Your User-Generated Content\n• Your violation of these Terms or applicable laws',
      ),
      _buildSection(
        '16. Account Termination & Deletion',
        'By You: Delete your account via in-app settings or by emailing support@alljobopen.com\n\nBy Us: We may suspend or terminate accounts for violations or misuse.\n\nLegal provisions shall survive termination.',
      ),
      _buildSection(
        '17. Governing Law & Jurisdiction',
        'These Terms are governed by the laws of India. Courts located in Sikar, Rajasthan shall have exclusive jurisdiction.',
      ),
      _buildSection(
        '18. Dispute Resolution',
        'Disputes shall be resolved by binding arbitration in Sikar, Rajasthan, in accordance with the Arbitration and Conciliation Act, 1996 (India). The arbitrator\'s decision shall be final and binding.',
      ),
      _buildSection(
        '19. Force Majeure',
        'We shall not be liable for delays or failures caused by events beyond reasonable control, including natural disasters, technical failures, or governmental actions.',
      ),
      _buildSection(
        '20. Severability & Waiver',
        '• If any provision is invalid, remaining provisions remain enforceable.\n• Failure to enforce rights shall not constitute a waiver.',
      ),
      _buildSection(
        '21. Amendments',
        'We may update these Terms at any time. Changes will be reflected by the "Last Updated" date. Continued use indicates acceptance.',
      ),
      _buildSection(
        '22. Contact Information',
        'Company Name: All Job Open\n📧 Email: support@alljobopen.com\n📍 Address: Ringus, Sikar, Rajasthan, India',
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildHindiContent() {
    return [
      _buildSection(
        'नियम और शर्तें (Terms and Conditions)',
        'अंतिम अपडेट: 7 / 1 / 2026',
      ),
      _buildSection(
        '1. परिचय एवं शर्तों की स्वीकृति',
        'All Job Open में आपका स्वागत है ("हम", "हमारा", "हमें")। ये नियम और शर्तें ("नियम") All Job Open के जॉब सर्च प्लेटफ़ॉर्म, जिसमें मोबाइल एप्लिकेशन और वेबसाइट शामिल हैं (सामूहिक रूप से "सेवा"), के उपयोग को नियंत्रित करती हैं।\n\nसेवा का उपयोग या एक्सेस करके, आप यह पुष्टि करते हैं कि आपने इन नियमों और हमारी गोपनीयता नीति (Privacy Policy) को पढ़ लिया है, समझ लिया है, और इनका पालन करने के लिए सहमत हैं। यदि आप इन नियमों से सहमत नहीं हैं, तो आपको तुरंत सेवा का उपयोग बंद करना होगा।\n\nहम किसी भी समय इन नियमों में बदलाव करने का अधिकार सुरक्षित रखते हैं। संशोधित नियम पोस्ट किए जाने के साथ ही प्रभावी होंगे। सेवा का निरंतर उपयोग संशोधित नियमों की स्वीकृति माना जाएगा।',
      ),
      _buildSection(
        '2. परिभाषाएँ',
        'सेवा (Service): IT और Non-IT नौकरी खोजने वालों और रिक्रूटर्स के लिए All Job Open प्लेटफ़ॉर्म।\n\nउपयोगकर्ता / आप: सेवा का उपयोग करने वाला कोई भी व्यक्ति या संस्था।\n\nनौकरी खोजने वाला: वह उपयोगकर्ता जो नौकरी खोज रहा हो या आवेदन कर रहा हो।\n\nरिक्रूटर: वह उपयोगकर्ता जो नौकरी की रिक्तियाँ पोस्ट करता है या उम्मीदवारों की तलाश करता है।\n\nसामग्री: सेवा पर उपलब्ध सभी टेक्स्ट, डेटा, चित्र, सॉफ़्टवेयर, ऑडियो, वीडियो आदि।\n\nउपयोगकर्ता-निर्मित सामग्री: नौकरी पोस्ट, रिज़्यूमे, प्रोफ़ाइल और संदेश।',
      ),
      _buildSection(
        '3. पात्रता',
        '• आपकी आयु कम से कम 16 वर्ष है।\n• आप कानूनी रूप से बाध्यकारी अनुबंध करने में सक्षम हैं।\n• आप कानून के अंतर्गत सेवा उपयोग से प्रतिबंधित नहीं हैं।\n• आप सभी लागू कानूनों का पालन करेंगे।',
      ),
      _buildSection('4. खाता पंजीकरण एवं सुरक्षा', ''),
      _buildSubSection(
        '4.1 खाता निर्माण',
        'सेवा की कुछ सुविधाओं के लिए खाता पंजीकरण आवश्यक हो सकता है। आप सटीक और अद्यतन जानकारी प्रदान करने के लिए सहमत होते हैं।',
      ),
      _buildSubSection(
        '4.2 खाता सुरक्षा',
        'अपने लॉगिन विवरण की सुरक्षा की जिम्मेदारी आपकी है। किसी भी अनधिकृत पहुँच की स्थिति में हमें तुरंत सूचित करना होगा।',
      ),
      _buildSection('5. उपयोगकर्ता की जिम्मेदारियाँ एवं स्वीकार्य उपयोग', ''),
      _buildSubSection(
        '5.1 रिक्रूटर्स',
        '• केवल वास्तविक और वैध नौकरी रिक्तियाँ पोस्ट करेंगे।\n• उम्मीदवार डेटा का उपयोग केवल भर्ती उद्देश्य के लिए करेंगे।\n• डेटा का दुरुपयोग या बिक्री नहीं करेंगे।',
      ),
      _buildSubSection(
        '5.2 नौकरी खोजने वाले',
        '• प्रोफ़ाइल और रिज़्यूमे में सटीक जानकारी देंगे।\n• केवल वैध रोजगार उद्देश्यों के लिए आवेदन करेंगे।',
      ),
      _buildSection(
        '6. निषिद्ध गतिविधियाँ',
        '• अवैध, अपमानजनक या भ्रामक सामग्री पोस्ट करना।\n• किसी व्यक्ति या संस्था का प्रतिरूपण करना।\n• धोखाधड़ी या अवांछित प्रचार के लिए सेवा का उपयोग।\n• बौद्धिक संपदा अधिकारों का उल्लंघन।\n• वायरस या मैलवेयर अपलोड करना।\n• सेवा को बाधित करने का प्रयास।',
      ),
      _buildSection(
        '7. सेवा की प्रकृति',
        'All Job Open केवल एक सुविधा मंच है।\n\n• नौकरी या उम्मीदवार की सटीकता की गारंटी नहीं।\n• हम नियोक्ता या भर्ती एजेंसी नहीं हैं।\n• रोजगार निर्णय दोनों पक्षों के बीच होंगे।',
      ),
      _buildSection(
        '8. मूल्य निर्धारण, भुगतान एवं रिफंड',
        '• नौकरी खोजने वालों के लिए सेवा सामान्यतः निःशुल्क है।\n• रिक्रूटर्स या प्रीमियम सेवाओं पर शुल्क लग सकता है।\n• सभी भुगतान गैर-वापसी योग्य हैं।',
      ),
      _buildSection(
        '9. बौद्धिक संपदा अधिकार',
        'उपयोगकर्ता-निर्मित सामग्री को छोड़कर, सभी सामग्री All Job Open की संपत्ति है। बिना लिखित अनुमति उपयोग निषिद्ध है।',
      ),
      _buildSection(
        '10. उपयोगकर्ता-निर्मित सामग्री',
        'आप अपनी सामग्री के स्वामी रहेंगे। आप हमें सेवा संचालन एवं प्रचार हेतु उपयोग का लाइसेंस देते हैं।',
      ),
      _buildSection(
        '11. गोपनीयता',
        'सभी गैर-सार्वजनिक जानकारी को गोपनीय रखा जाएगा। उम्मीदवार डेटा केवल भर्ती उद्देश्य हेतु उपयोग होगा।',
      ),
      _buildSection(
        '12. तृतीय-पक्ष सेवाएँ',
        'तृतीय-पक्ष लिंक हमारे नियंत्रण में नहीं हैं। उनका उपयोग आपके जोखिम पर होगा।',
      ),
      _buildSection(
        '13. अस्वीकरण',
        'सेवा "जैसी है" आधार पर प्रदान की जाती है। हम किसी भी परिणाम की गारंटी नहीं देते।',
      ),
      _buildSection(
        '14. दायित्व की सीमा',
        'कानून द्वारा अनुमत सीमा तक, हम किसी भी अप्रत्यक्ष क्षति के लिए उत्तरदायी नहीं होंगे।',
      ),
      _buildSection(
        '15. क्षतिपूर्ति',
        'सेवा उपयोग या नियम उल्लंघन से उत्पन्न किसी भी दावे के लिए आप हमें क्षतिपूर्ति देंगे।',
      ),
      _buildSection(
        '16. खाता समाप्ति',
        'आप support@alljobopen.com पर ईमेल करके खाता हटा सकते हैं। नियम उल्लंघन पर हम खाता निलंबित कर सकते हैं।',
      ),
      _buildSection(
        '17. शासक कानून एवं क्षेत्राधिकार',
        'ये नियम भारत के कानूनों के अधीन होंगे। सीकर, राजस्थान की अदालतों को अधिकार होगा।',
      ),
      _buildSection(
        '18. विवाद समाधान',
        'विवादों का समाधान मध्यस्थता द्वारा सीकर, राजस्थान में किया जाएगा।',
      ),
      _buildSection(
        '19. फोर्स मेज्योर',
        'नियंत्रण से बाहर की परिस्थितियों में हम उत्तरदायी नहीं होंगे।',
      ),
      _buildSection(
        '20. पृथक्करण एवं परित्याग',
        'किसी प्रावधान के अमान्य होने पर शेष नियम लागू रहेंगे।',
      ),
      _buildSection(
        '21. संशोधन',
        'नियमों में बदलाव "अंतिम अपडेट" तिथि से प्रभावी होंगे।',
      ),
      _buildSection(
        '22. संपर्क जानकारी',
        'कंपनी: ऑल जॉब ओपन\n📧 Email: support@alljobopen.com\n📍 पता: रिंगस, सीकर, राजस्थान, भारत',
      ),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
