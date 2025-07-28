// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Curativo';

  @override
  String get homeTitle => 'Emergency Kit';

  @override
  String get firstAidTitle => 'First Aid';

  @override
  String get firstAidDescription => '🚑 Emergency medical assistance.';

  @override
  String get checkConsciousness => 'Check Consciousness';

  @override
  String get checkConsciousnessDesc => 'Make sure the victim is conscious.';

  @override
  String get callHelp => 'Call for Help';

  @override
  String get callHelpDesc => 'Call 112/119.';

  @override
  String get minorWoundCare => 'Minor Wound Care';

  @override
  String get minorWoundDesc => '🩹 Small wound treatment.';

  @override
  String get emergencyCPR => 'Emergency CPR';

  @override
  String get emergencyCPRDesc => '❤️ Basic life support.';

  @override
  String get firstAidEquipment => 'First Aid Equipment';

  @override
  String get firstAidEquipmentDesc =>
      'First aid equipment can help us during emergencies.';

  @override
  String get welcome => 'Welcome to Curativo';

  @override
  String get login => 'LOGIN';

  @override
  String get register => 'REGISTER';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get enterFullName => 'Enter Full Name';

  @override
  String get enterPhoneNumber => 'Enter Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get selectGender => 'Select Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get loading => 'Loading...';

  @override
  String get emailPasswordRequired => 'Email and password are required.';

  @override
  String get loginFailed =>
      'Login failed. Please check your email and password.';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get allFieldsRequired =>
      'All fields must be filled and gender must be selected.';

  @override
  String get passwordMismatch => 'Password confirmation does not match.';

  @override
  String get registrationSuccess =>
      'Registration successful! Going to Home Screen.';

  @override
  String get registrationFailed => 'Registration failed.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get help => 'Help';

  @override
  String get scan => 'Scan';

  @override
  String get history => 'History';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get scanWound => 'Scan Wound';

  @override
  String get uploadPhoto => 'Upload Wound Photo';

  @override
  String get tapToSelectPhoto => 'Tap to select photo';

  @override
  String get ensureLighting => 'Ensure adequate lighting';

  @override
  String get focusCamera => 'Focus camera on wound area';

  @override
  String get avoidShadows => 'Avoid shadows in photo';

  @override
  String get properDistance => 'Take photo from proper distance';

  @override
  String get processing => 'PROCESSING...';

  @override
  String get analyzingImage => 'Analyzing image...';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get errorOccurredWithDetails => '❌ An error occurred';

  @override
  String get failedToTakePhoto => 'Failed to take photo';

  @override
  String get woundTypeBruise => 'Bruise';

  @override
  String get woundTypeScratch => 'Scratch';

  @override
  String get woundTypeCut => 'Cut';

  @override
  String get woundTypeBurn => 'Burn';

  @override
  String get historySaved => 'History saved successfully';

  @override
  String get failedToSaveHistory => 'Failed to save history';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHistory => 'Delete History';

  @override
  String get deleteAllHistory => 'Delete All History';

  @override
  String get confirmDelete => 'Are you sure you want to delete this item?';

  @override
  String get confirmDeleteAll => 'Are you sure you want to delete all history?';

  @override
  String get historyDeleted => 'History deleted successfully';

  @override
  String get allHistoryDeleted => 'All history deleted successfully';

  @override
  String get someItemsFailedToDelete => 'Some items failed to delete';

  @override
  String get failedToDelete => 'Failed to delete data';

  @override
  String get failedToLoadHistory => 'Failed to load history';

  @override
  String get noScanHistory =>
      'No scan history yet.\nStart scanning wounds to see history here.';

  @override
  String totalScanHistory(Object count) {
    return 'Total $count scan history';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get detail => 'Detail';

  @override
  String get detectionResult => 'Detection Result';

  @override
  String get detectionImage => 'Detection Result Image';

  @override
  String get detectedWoundType => 'Detected Wound Type';

  @override
  String get treatmentRecommendation => 'Treatment Recommendation';

  @override
  String get confidenceLevel => 'Confidence Level';

  @override
  String get detectionTime => 'Detection Time';

  @override
  String get detailDetectionResult => 'Detail Detection Result';

  @override
  String get failedToLoadImage => 'Failed to load image';

  @override
  String get noImage => 'No image';

  @override
  String get treatmentRecommendationTitle => 'Treatment Recommendation';

  @override
  String get aboutApp => 'About App';

  @override
  String get appDescription =>
      'AI-powered wound detection app that provides appropriate treatment recommendations';

  @override
  String get version => 'v1.0.0';

  @override
  String get mainFeatures => 'Main Features';

  @override
  String get woundDetection => 'Wound Detection';

  @override
  String get woundDetectionDesc =>
      'Scan wounds using camera for wound type identification';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get aiAnalysisDesc => 'Advanced AI technology for analysis';

  @override
  String get treatmentRecommendationFeature => 'Treatment Recommendation';

  @override
  String get treatmentRecommendationFeatureDesc =>
      'Treatment suggestions based on detected wound type';

  @override
  String get scanHistoryFeature => 'Scan History';

  @override
  String get scanHistoryFeatureDesc => 'Save and review previous scan results';

  @override
  String get appInfo => 'App Information';

  @override
  String get developmentTeam => 'Development Team';

  @override
  String get greenMonkeyTeam => 'GreenMonkey Team';

  @override
  String get support => 'Support';

  @override
  String get supportDesc => 'Contact us for help and suggestions';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText =>
      'This app is for reference only. Always consult with medical professionals for proper diagnosis and treatment.';

  @override
  String get giveHelp => 'Give Help';

  @override
  String get emergencyFirstAidGuide => 'Emergency first aid guide';

  @override
  String get emergencyContact112 => 'Emergency Contact 112';

  @override
  String get emergencyContactDesc => 'Contact Indonesian emergency services';

  @override
  String get emergencyGuide => 'Emergency Guide';

  @override
  String get emergencySteps => 'First aid steps';

  @override
  String get chokingAdult => 'Choking (Adult, Elderly)';

  @override
  String get chokingAdultDesc => 'Heimlich maneuver for adults';

  @override
  String get chokingAdultInstructions =>
      'If an adult or elderly person is choking and can still cough or make sounds, let them cough to try to dislodge the object. If they can\'t breathe or speak, perform the Heimlich maneuver.';

  @override
  String get chokingChild => 'Choking (Child)';

  @override
  String get chokingChildDesc => 'Special technique for children';

  @override
  String get chokingChildInstructions =>
      'For small children, position them leaning forward and pat their back five times with the palm of your hand. If unsuccessful, perform abdominal thrusts.';

  @override
  String get chokingBaby => 'Choking (Baby)';

  @override
  String get chokingBabyDesc => 'Special handling for babies';

  @override
  String get chokingBabyInstructions =>
      'Place the baby face down on your arm, head lower than body. Give five back blows, then five chest compressions if unsuccessful.';

  @override
  String get severeBleeding => 'Severe Bleeding';

  @override
  String get severeBleedingDesc => 'How to stop bleeding';

  @override
  String get severeBleedingInstructions =>
      'Apply direct pressure to the wound with a clean cloth or bandage. If blood soaks through, add another layer without removing the first. Elevate the bleeding part above the heart if possible.';

  @override
  String get heartAttack => 'Heart Attack';

  @override
  String get heartAttackDesc => 'Signs and emergency treatment';

  @override
  String get heartAttackInstructions =>
      'Call for medical help immediately. Give aspirin if available and the victim is not allergic. Position the victim sitting comfortably, loosen tight clothing.';

  @override
  String get stroke => 'Stroke';

  @override
  String get strokeDesc => 'Early detection and treatment';

  @override
  String get strokeInstructions =>
      'Use the FAST test: Face, Arms, Speech, Time. If there are signs of stroke, immediately contact emergency services.';

  @override
  String get burns => 'Burns';

  @override
  String get burnsDesc => 'Treatment for minor to severe burns';

  @override
  String get burnsInstructions =>
      'Cool the burn with running water for 10-20 minutes. Don\'t use ice. Cover with a clean, damp cloth. For severe burns, seek medical help immediately.';

  @override
  String get homeSubtitle => 'Smart solution for wound care';

  @override
  String get checkWoundCondition => 'Let\'s Check\nWound Condition!';

  @override
  String get checkWoundSubtitle => 'Let\'s detect and monitor wounds early';

  @override
  String get emergencyKit => 'Emergency Kit';

  @override
  String get emergencyKitSubtitle =>
      'Make sure you\'re ready to help with wound treatment';

  @override
  String get bruiseWound => 'Bruise Wound';

  @override
  String get scratchWound => 'Scratch Wound';

  @override
  String get cutWound => 'Cut Wound';

  @override
  String get burnWound => 'Burn Wound';

  @override
  String get unknownWound => 'Unknown';

  @override
  String get woundNotDetected => 'Wound not detected';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get scanInstruction1 => 'Ensure adequate lighting';

  @override
  String get scanInstruction2 => 'Focus camera on wound area';

  @override
  String get scanInstruction3 => 'Avoid shadows in photo';

  @override
  String get scanInstruction4 => 'Take photo from appropriate distance';

  @override
  String get bruiseRecommendation1 => 'Apply ice compress for 15-20 minutes';

  @override
  String get bruiseRecommendation2 => 'Rest the injured area';

  @override
  String get bruiseRecommendation3 => 'Elevate the bruised part if possible';

  @override
  String get bruiseRecommendation4 => 'Consult doctor if pain persists';

  @override
  String get scratchRecommendation1 => 'Clean wound with clean water';

  @override
  String get scratchRecommendation2 => 'Apply mild antiseptic';

  @override
  String get scratchRecommendation3 => 'Cover with sterile bandage';

  @override
  String get scratchRecommendation4 => 'Change bandage regularly';

  @override
  String get cutRecommendation1 => 'Stop bleeding by applying pressure';

  @override
  String get cutRecommendation2 => 'Clean wound carefully';

  @override
  String get cutRecommendation3 => 'Apply antibiotic ointment';

  @override
  String get cutRecommendation4 =>
      'Cover with bandage and monitor for infection';

  @override
  String get burnRecommendation1 => 'Cool with running water for 10-20 minutes';

  @override
  String get burnRecommendation2 => 'Don\'t break any blisters that form';

  @override
  String get burnRecommendation3 => 'Apply aloe vera gel or burn cream';

  @override
  String get burnRecommendation4 => 'See doctor immediately if burn is severe';

  @override
  String get indonesiaLanguage => '🇮🇩 Indonesia';

  @override
  String get englishLanguage => '🇺🇸 English';

  @override
  String get scanTips => 'Scan Tips';

  @override
  String get noRecommendationsAvailable => 'No recommendations';

  @override
  String pageInfo(int currentPage, int lastPage) {
    return 'Page $currentPage of $lastPage';
  }

  @override
  String get languageSettings => 'Language / Bahasa';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get gender => 'Gender';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get confidenceHigh => 'High';

  @override
  String get confidenceMedium => 'Medium';

  @override
  String get confidenceLow => 'Low';

  @override
  String get kit => 'Kit';

  @override
  String get logout => 'LOGOUT';
}
