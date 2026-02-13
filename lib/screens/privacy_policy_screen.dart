import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isHindi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
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
      _buildSection('Privacy Policy', 'Last Updated: 7 / 1 / 2026'),
      _buildSection(
        '1. Introduction & Scope',
        'Welcome to All Job Open, the simple and reliable job search application for IT and Non-IT job seekers and recruiters (the "App"). This Privacy Policy describes how All Job Open collects, uses, processes, and shares your information. It applies to all users of the App, including job seekers ("Candidates") and recruiters/companies ("Recruiters"). By using our App, you agree to the terms of this Privacy Policy.',
      ),
      _buildSection(
        '2. Definitions',
        'For the purpose of this Policy:\n\nApp: Refers to the All Job Open mobile application and related services.\n\nPersonal Information (PI): Any information that relates to an identified or identifiable natural person.\n\nCandidate: An individual using the App to search for or apply to jobs.\n\nRecruiter: An individual or entity using the App to post job openings and search for Candidates.\n\nProcessing: Any operation performed on Personal Information, such as collection, recording, organization, storage, and disclosure.\n\nData Controller: All Job Open, which determines the purposes and means of processing Personal Information.',
      ),
      _buildSection('3. Information We Collect', ''),
      _buildSubSection(
        '3.1. Personal Information',
        'We collect Personal Information necessary to provide our services. This may include:\n\nUser Type | Information Collected\n\nCandidates: Name, email address, phone number, physical address, CV/resume, job experience, educational history, professional certifications, desired salary, job preferences.\n\nRecruiters: Name, work email address, phone number, company name, company address, and payment information (if applicable for premium services).\n\nAll Users: Account credentials (username and hashed password), profile picture.',
      ),
      _buildSubSection(
        '3.2. Non-Personal / Technical Information',
        'We automatically collect certain technical and usage information when you access the App:\n\nDevice Information: Device model, operating system version, unique device identifiers.\n\nLog Data: IP address, access times, pages/features viewed, app crashes, and other system activity.\n\nUsage Data: Details on how you use the App (e.g., jobs searched, jobs applied to, posts viewed).',
      ),
      _buildSection(
        '4. How We Collect Information',
        'We collect information through the following methods:\n\nDirectly from You: When you create an account, complete your profile, upload your resume, post a job, or communicate with us.\n\nAutomatically: When you use the App, through cookies and tracking technologies (detailed below).\n\nFrom Third Parties: If you choose to log in through a third-party service (like Google or Apple), we may receive information from them.',
      ),
      _buildSection(
        '5. Purpose of Data Collection',
        'We collect and process your information for the following purposes:\n\nService Provision: To operate the App, connect Candidates with Recruiters, and manage user accounts.\n\nPersonalization: To recommend relevant jobs to Candidates and relevant Candidates to Recruiters.\n\nCommunication: To send service updates, security alerts, and support messages.\n\nImprovement: To monitor and analyze usage to improve the App\'s functionality, performance, and user experience.\n\nMarketing: To send promotional content about All Job Open services, subject to your consent.',
      ),
      _buildSection(
        '6. Legal Basis for Processing (GDPR / Applicable Laws)',
        'For users in jurisdictions that require a legal basis for processing Personal Information, we rely on the following:\n\nContractual Necessity: Processing is necessary to provide the service you have requested (e.g., managing your account, enabling job applications/postings).\n\nLegitimate Interests: Processing is necessary for our legitimate interests (e.g., improving our services, preventing fraud, network security), provided these interests are not overridden by your data protection rights.\n\nConsent: Where required by law, we will obtain your explicit consent for specific processing activities (e.g., for direct marketing).\n\nLegal Obligation: Processing is necessary for compliance with a legal obligation (e.g., tax or law enforcement requests).',
      ),
      _buildSection(
        '7. Use of Cookies & Tracking Technologies',
        'All Job Open uses cookies, web beacons, and similar technologies to collect information about your browsing activities to remember your preferences, provide a more personalized experience, and analyze how the App is used. You can manage your cookie preferences through your device or browser settings, though disabling some cookies may affect the functionality of the App.',
      ),
      _buildSection('8. Data Sharing & Disclosure', ''),
      _buildSubSection(
        '8.1. Third-Party Service Providers',
        'We share your information with trusted third-party service providers who perform services on our behalf, such as:\n\nHosting and data storage providers.\nAnalytics providers (to help us understand App usage).\nCustomer support and communication providers.\n\nThese service providers are authorized to use your Personal Information only as necessary to provide these services to us and are contractually bound to protect it.',
      ),
      _buildSubSection(
        '8.2. Legal & Regulatory Authorities',
        'We may disclose your information to:\n\nComply with a legal obligation, subpoena, or court order.\nProtect the rights, property, or safety of All Job Open, our users, or the public.\nInvestigate or prevent potential fraud or security breaches.',
      ),
      _buildSection(
        '9. Data Storage & Retention Policy',
        'We retain your Personal Information only for as long as necessary to fulfill the purposes for which it was collected, including for the purposes of satisfying any legal, accounting, or reporting requirements.\n\nAccount Data: We generally retain data associated with your account for as long as your account is active.\n\nDeleted Accounts: You have the right to request that we delete your Personal Information. To request account deletion, please email us at support@alljobopen.com. Please note that some information may be retained as required by law.',
      ),
      _buildSection(
        '10. Data Security Measures',
        'All Job Open is committed to protecting your data. We implement reasonable and appropriate technical and organizational measures to safeguard the Personal Information we process. These measures include:\n\nEncryption of data in transit and at rest.\nRegular security assessments and vulnerability scanning.\nAccess controls to limit access to Personal Information to authorized personnel only.\n\nHowever, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
      ),
      _buildSection(
        '11. User Rights',
        'Depending on your location and applicable law (e.g., GDPR), you may have the following rights regarding your Personal Information:',
      ),
      _buildSubSection(
        '11.1. Access, Correction & Deletion',
        'Access: The right to request a copy of the Personal Information we hold about you.\n\nCorrection/Rectification: The right to request that we correct any inaccurate or incomplete Personal Information.\n\nDeletion/Erasure: The right to request the deletion of your Personal Information, subject to certain legal exceptions, including by submitting a deletion request via email from your registered email address to support@alljobopen.com',
      ),
      _buildSubSection(
        '11.2. Withdrawal of Consent',
        'Where we rely on your consent as the legal basis for processing, you have the right to withdraw your consent at any time. Withdrawal of consent will not affect the lawfulness of processing based on consent before its withdrawal.',
      ),
      _buildSection(
        '12. Children\'s Privacy',
        'The App is not directed to individuals under the age of 16. We do not knowingly collect Personal Information from children under 16. If we become aware that we have collected Personal Information from a child under 16 without verifiable parental consent, we will take steps to delete that information.',
      ),
      _buildSection(
        '13. International Data Transfers',
        'All Job Open may store and process your information in countries outside of your country of residence, including India and the United States, which may have different data protection laws than those in your region. Where we transfer Personal Information across borders, we implement appropriate safeguards to ensure your data remains protected.',
      ),
      _buildSection(
        '14. Third-Party Links',
        'The App may contain links to third-party websites or services. This Privacy Policy does not apply to those third-party sites. We encourage you to read the privacy policies of any third-party websites you visit.',
      ),
      _buildSection(
        '15. Changes to This Privacy Policy',
        'We may update this Privacy Policy from time to time. When we make changes, we will revise the "Effective Date" at the top of the policy. If the changes are significant, we will notify you through the App or via email before the changes take effect. Your continued use of the App after the effective date of the revised policy constitutes your acceptance of the terms.',
      ),
      _buildSection(
        '16. Contact Information & Grievance Officer',
        'If you have questions about this Privacy Policy, our data practices, or if you wish to exercise your rights, please contact us:\n\nCompany Name: All Job Open\n📧 Email: support@alljobopen.com\n📍 Address: Ringus, Sikar, Rajasthan, India',
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _buildHindiContent() {
    return [
      _buildSection(
        'गोपनीयता नीति (Privacy Policy)',
        'अंतिम अपडेट: 7 / 1 / 2026',
      ),
      _buildSection(
        '1. परिचय और दायरा',
        'All Job Open में आपका स्वागत है, जो IT और Non-IT नौकरी खोजने वालों तथा रिक्रूटर्स के लिए एक सरल और विश्वसनीय जॉब सर्च एप्लिकेशन है ("ऐप")। यह गोपनीयता नीति बताती है कि All Job Open आपकी जानकारी कैसे एकत्र, उपयोग, प्रोसेस और साझा करता है। यह नीति ऐप के सभी उपयोगकर्ताओं पर लागू होती है, जिनमें नौकरी खोजने वाले ("कैंडिडेट") और रिक्रूटर्स/कंपनियाँ ("रिक्रूटर") शामिल हैं। ऐप का उपयोग करके, आप इस गोपनीयता नीति की शर्तों से सहमत होते हैं।',
      ),
      _buildSection(
        '2. परिभाषाएँ',
        'इस नीति के उद्देश्य से:\n\nऐप: All Job Open मोबाइल एप्लिकेशन और उससे संबंधित सेवाएँ\n\nव्यक्तिगत जानकारी (Personal Information – PI): ऐसी कोई भी जानकारी जो किसी पहचाने जा सकने वाले व्यक्ति से संबंधित हो\n\nकैंडिडेट: ऐप का उपयोग नौकरी खोजने या आवेदन करने के लिए करने वाला व्यक्ति\n\nरिक्रूटर: ऐप का उपयोग नौकरी पोस्ट करने या कैंडिडेट खोजने के लिए करने वाला व्यक्ति या संस्था\n\nप्रोसेसिंग: व्यक्तिगत जानकारी पर की जाने वाली कोई भी कार्रवाई, जैसे संग्रह, रिकॉर्डिंग, भंडारण या साझा करना\n\nडेटा कंट्रोलर: All Job Open, जो व्यक्तिगत जानकारी के प्रोसेसिंग के उद्देश्य और साधन तय करता है',
      ),
      _buildSection('3. हम कौन-सी जानकारी एकत्र करते हैं', ''),
      _buildSubSection(
        '3.1 व्यक्तिगत जानकारी',
        'हम अपनी सेवाएँ प्रदान करने के लिए आवश्यक व्यक्तिगत जानकारी एकत्र करते हैं, जिसमें शामिल हो सकता है:\n\nउपयोगकर्ता प्रकार | एकत्र की जाने वाली जानकारी\n\nकैंडिडेट्स: नाम, ईमेल पता, फोन नंबर, पता, CV/रिज़्यूमे, कार्य अनुभव, शैक्षणिक विवरण, प्रोफेशनल सर्टिफिकेशन, अपेक्षित वेतन, नौकरी से संबंधित प्राथमिकताएँ\n\nरिक्रूटर्स: नाम, ऑफिस ईमेल, फोन नंबर, कंपनी का नाम, कंपनी का पता, भुगतान से संबंधित जानकारी (यदि प्रीमियम सेवाओं के लिए लागू हो)\n\nसभी उपयोगकर्ता: अकाउंट लॉगिन विवरण (यूज़रनेम और हैश किया गया पासवर्ड), प्रोफाइल फोटो',
      ),
      _buildSubSection(
        '3.2 गैर-व्यक्तिगत / तकनीकी जानकारी',
        'जब आप ऐप का उपयोग करते हैं, तो हम स्वचालित रूप से कुछ तकनीकी जानकारी एकत्र कर सकते हैं, जैसे:\n\nडिवाइस जानकारी: डिवाइस मॉडल, ऑपरेटिंग सिस्टम संस्करण, यूनिक डिवाइस आईडी\n\nलॉग डेटा: IP पता, एक्सेस समय, देखे गए फीचर्स, ऐप क्रैश रिपोर्ट\n\nउपयोग डेटा: ऐप में आपकी गतिविधियाँ (जैसे खोजी गई नौकरियाँ, किए गए आवेदन)',
      ),
      _buildSection(
        '4. जानकारी एकत्र करने के तरीके',
        'सीधे आपसे: जब आप अकाउंट बनाते हैं, प्रोफाइल पूरी करते हैं, रिज़्यूमे अपलोड करते हैं या हमसे संपर्क करते हैं\n\nस्वचालित रूप से: जब आप ऐप का उपयोग करते हैं, कुकीज़ और ट्रैकिंग तकनीकों के माध्यम से\n\nथर्ड-पार्टी से: यदि आप Google या Apple जैसे थर्ड-पार्टी लॉगिन का उपयोग करते हैं',
      ),
      _buildSection(
        '5. डेटा एकत्र करने का उद्देश्य',
        'ऐप की सेवाएँ प्रदान करने के लिए\n\nकैंडिडेट और रिक्रूटर को आपस में जोड़ने के लिए\n\nअकाउंट प्रबंधन के लिए\n\nबेहतर नौकरी और कैंडिडेट सुझाव देने के लिए\n\nनोटिफिकेशन, अपडेट और सपोर्ट संदेश भेजने के लिए\n\nऐप की गुणवत्ता और प्रदर्शन में सुधार के लिए\n\nआपकी सहमति से मार्केटिंग और प्रमोशनल जानकारी भेजने के लिए',
      ),
      _buildSection(
        '6. प्रोसेसिंग का कानूनी आधार',
        'अनुबंध की आवश्यकता: सेवा प्रदान करने के लिए\n\nवैध हित: ऐप सुधार, धोखाधड़ी रोकथाम और सुरक्षा\n\nसहमति: जहाँ कानूनन आवश्यक हो\n\nकानूनी दायित्व: कानूनी आदेशों का पालन',
      ),
      _buildSection(
        '7. कुकीज़ और ट्रैकिंग तकनीक',
        'All Job Open उपयोगकर्ता अनुभव को बेहतर बनाने और ऐप के उपयोग का विश्लेषण करने के लिए कुकीज़ और समान तकनीकों का उपयोग करता है। आप अपने डिवाइस या ब्राउज़र सेटिंग्स से कुकीज़ को नियंत्रित कर सकते हैं।',
      ),
      _buildSection('8. डेटा साझा करना', ''),
      _buildSubSection(
        '8.1 थर्ड-पार्टी सेवा प्रदाता',
        'होस्टिंग और डेटा स्टोरेज\n\nएनालिटिक्स सेवाएँ\n\nकस्टमर सपोर्ट सेवाएँ\n\nये प्रदाता आपकी जानकारी का उपयोग केवल हमारी सेवाएँ प्रदान करने के लिए ही कर सकते हैं।',
      ),
      _buildSubSection(
        '8.2 कानूनी और नियामक कारण',
        'कानून या कोर्ट के आदेश का पालन आवश्यक होने पर\n\nधोखाधड़ी या सुरक्षा जोखिम की जाँच के लिए\n\nAll Job Open या उपयोगकर्ताओं की सुरक्षा के लिए',
      ),
      _buildSection(
        '9. डेटा स्टोरेज और रिटेंशन',
        'सक्रिय अकाउंट: अकाउंट सक्रिय रहने तक\n\nडिलीटेड अकाउंट: अकाउंट हटाने के बाद कुछ जानकारी सीमित समय तक रखी जा सकती है',
      ),
      _buildSection(
        '10. डेटा सुरक्षा',
        'डेटा एन्क्रिप्शन\n\nनियमित सुरक्षा जाँच\n\nसीमित एक्सेस नियंत्रण\n\nहालाँकि, इंटरनेट पर 100% सुरक्षा की गारंटी नहीं दी जा सकती।',
      ),
      _buildSection('11. उपयोगकर्ता अधिकार', ''),
      _buildSubSection(
        '11.1 एक्सेस, सुधार और डिलीशन',
        'एक्सेस: अपनी व्यक्तिगत जानकारी की कॉपी मांगने का अधिकार\n\nसुधार: गलत या अधूरी जानकारी सुधारने का अधिकार\n\nडिलीशन / इरेज़र: आपको अपनी व्यक्तिगत जानकारी को हटाने का अनुरोध करने का अधिकार है। आप support@alljobopen.com पर ईमेल भेजकर अपना अकाउंट और डेटा डिलीट करवा सकते हैं। हालांकि, कानूनी अनिवार्यताओं के कारण कुछ डेटा रिटेन (Retain) किया जा सकता है।',
      ),
      _buildSubSection(
        '11.2 सहमति वापस लेना',
        'जहाँ डेटा प्रोसेसिंग आपकी सहमति पर आधारित है, आप किसी भी समय अपनी सहमति वापस ले सकते हैं।',
      ),
      _buildSection(
        '12. बच्चों की गोपनीयता',
        'यह ऐप 16 वर्ष से कम आयु के बच्चों के लिए नहीं है।',
      ),
      _buildSection(
        '13. अंतरराष्ट्रीय डेटा ट्रांसफर',
        'आपकी जानकारी भारत और अन्य देशों (जैसे अमेरिका) में स्टोर या प्रोसेस की जा सकती है।',
      ),
      _buildSection(
        '14. थर्ड-पार्टी लिंक',
        'ऐप में थर्ड-पार्टी वेबसाइटों के लिंक हो सकते हैं।',
      ),
      _buildSection(
        '15. गोपनीयता नीति में बदलाव',
        'हम समय-समय पर इस नीति को अपडेट कर सकते हैं।',
      ),
      _buildSection(
        '16. संपर्क जानकारी और शिकायत अधिकारी',
        'कंपनी का नाम: All Job Open\n📧 ईमेल: support@alljobopen.com\n📍 पता: रिंगस, सीकर, राजस्थान, भारत',
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
