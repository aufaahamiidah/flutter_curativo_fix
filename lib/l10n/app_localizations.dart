import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Curativo'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Kit'**
  String get homeTitle;

  /// No description provided for @firstAidTitle.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get firstAidTitle;

  /// No description provided for @firstAidDescription.
  ///
  /// In en, this message translates to:
  /// **'🧰 Preparing a Wound Alert Kit at Home.'**
  String get firstAidDescription;

  /// No description provided for @preparednessKit.
  ///
  /// In en, this message translates to:
  /// **'🧠 Tips for Preparing a Wound Alert Kit at Home'**
  String get preparednessKit;

  /// No description provided for @preparednessKitDesc.
  ///
  /// In en, this message translates to:
  /// **'• Place the first aid kit and wound treatment tools in a location that is easily accessible to all family members.\n• Check the expiration date of medicines and the condition of the tools every 3 months.\n• Store medical tools in different containers so that they are not mixed with medicines.\n• Choose a waterproof storage box and clearly label each part.\n• Insert a short leaflet or QR Code into the tutorial video so that the family knows the steps for handling minor injuries.\n• Add additional tools outside the first aid kit.'**
  String get preparednessKitDesc;

  /// No description provided for @callHelp.
  ///
  /// In en, this message translates to:
  /// **'Call for Help'**
  String get callHelp;

  /// No description provided for @callHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Call 112/119.'**
  String get callHelpDesc;

  /// No description provided for @minorWoundCare.
  ///
  /// In en, this message translates to:
  /// **'Minor Wound Care'**
  String get minorWoundCare;

  /// No description provided for @minorWoundDesc.
  ///
  /// In en, this message translates to:
  /// **'🩹 Small wound treatment.'**
  String get minorWoundDesc;

  /// No description provided for @emergencyBagTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Bag'**
  String get emergencyBagTitle;

  /// No description provided for @emergencyBagDescription.
  ///
  /// In en, this message translates to:
  /// **'🧳 Emergency Bag Checklist.'**
  String get emergencyBagDescription;

  /// No description provided for @emergencyBag.
  ///
  /// In en, this message translates to:
  /// **'📌 Must-Have Items in Your Emergency Bag'**
  String get emergencyBag;

  /// No description provided for @emergencyBagDesc.
  ///
  /// In en, this message translates to:
  /// **'• 📄 Important documents (ID card, family card, health insurance – keep in a waterproof plastic pouch)\n• 💊 Personal medication & mini first aid kit (regular medicine, antiseptic, plasters, face masks)\n• 🔦 Flashlight + spare batteries\n• 🧴 Hygiene supplies (wet wipes, hand sanitizer, sanitary pads)\n• 🧥 Spare clothes & light blanket\n• 🍞 Long-lasting food (biscuits, canned food)\n• 💧 At least 1 liter of drinking water\n• 📱 Power bank & charging cable\n• 💵 Some cash\n• 🧸 Comfort items (children’s toys, small blanket)'**
  String get emergencyBagDesc;

  /// No description provided for @firstAidEquipment1.
  ///
  /// In en, this message translates to:
  /// **'🩹 Wound Covering Supplies'**
  String get firstAidEquipment1;

  /// No description provided for @firstAidEquipmentDesc1.
  ///
  /// In en, this message translates to:
  /// **'• Adhesive bandages (various sizes)\n• Sterile gauze pads\n• Gauze rolls\n• Medical tape\n• Triangular bandage (for sling or wrapping)'**
  String get firstAidEquipmentDesc1;

  /// No description provided for @firstAidEquipment2.
  ///
  /// In en, this message translates to:
  /// **'🧼 Antiseptics & Wound Cleansers'**
  String get firstAidEquipment2;

  /// No description provided for @firstAidEquipmentDesc2.
  ///
  /// In en, this message translates to:
  /// **'• Antiseptic solution (e.g., povidone-iodine or chlorhexidine)\n• 70% alcohol\n• Antiseptic wipes\n• Antibacterial soap'**
  String get firstAidEquipmentDesc2;

  /// No description provided for @firstAidEquipment3.
  ///
  /// In en, this message translates to:
  /// **'✂️ Medical Tools'**
  String get firstAidEquipment3;

  /// No description provided for @firstAidEquipmentDesc3.
  ///
  /// In en, this message translates to:
  /// **'• Scissors (for cutting bandages or clothing)\n• Tweezers (for removing splinters)\n• Thermometer\n• Medical gloves (latex or non-latex)\n• Face masks'**
  String get firstAidEquipmentDesc3;

  /// No description provided for @firstAidEquipment4.
  ///
  /// In en, this message translates to:
  /// **'💊 Basic Medications'**
  String get firstAidEquipment4;

  /// No description provided for @firstAidEquipmentDesc4.
  ///
  /// In en, this message translates to:
  /// **'• Paracetamol / ibuprofen (for pain and fever)\n• Diarrhea medication (oral rehydration salts, loperamide)\n• Antihistamines (for allergies)\n• Antibiotic ointment (for open wounds)\n• Anti-itch cream (e.g., for insect bites)'**
  String get firstAidEquipmentDesc4;

  /// No description provided for @firstAidEquipment5.
  ///
  /// In en, this message translates to:
  /// **'🔗 Additional Items'**
  String get firstAidEquipment5;

  /// No description provided for @firstAidEquipmentDesc5.
  ///
  /// In en, this message translates to:
  /// **'• First aid manual or instruction booklet\n• CPR face shield or breathing mask\n• Instant cold pack\n• Cotton swabs\n• Clean plastic bags'**
  String get firstAidEquipmentDesc5;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Curativo'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get register;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get emailPasswordRequired;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your email and password.'**
  String get loginFailed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields must be filled and gender must be selected.'**
  String get allFieldsRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation does not match.'**
  String get passwordMismatch;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Going to Home Screen.'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get registrationFailed;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @scanWound.
  ///
  /// In en, this message translates to:
  /// **'Scan Wound'**
  String get scanWound;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Wound Photo'**
  String get uploadPhoto;

  /// No description provided for @tapToSelectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photo'**
  String get tapToSelectPhoto;

  /// No description provided for @ensureLighting.
  ///
  /// In en, this message translates to:
  /// **'Ensure adequate lighting'**
  String get ensureLighting;

  /// No description provided for @focusCamera.
  ///
  /// In en, this message translates to:
  /// **'Focus camera on wound area'**
  String get focusCamera;

  /// No description provided for @avoidShadows.
  ///
  /// In en, this message translates to:
  /// **'Avoid shadows in photo'**
  String get avoidShadows;

  /// No description provided for @properDistance.
  ///
  /// In en, this message translates to:
  /// **'Take photo from proper distance'**
  String get properDistance;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'PROCESSING...'**
  String get processing;

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image...'**
  String get analyzingImage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @errorOccurredWithDetails.
  ///
  /// In en, this message translates to:
  /// **'❌ An error occurred'**
  String get errorOccurredWithDetails;

  /// No description provided for @failedToTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to take photo'**
  String get failedToTakePhoto;

  /// No description provided for @woundTypeBruise.
  ///
  /// In en, this message translates to:
  /// **'Bruise'**
  String get woundTypeBruise;

  /// No description provided for @woundTypeScratch.
  ///
  /// In en, this message translates to:
  /// **'Scratch'**
  String get woundTypeScratch;

  /// No description provided for @woundTypeCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get woundTypeCut;

  /// No description provided for @woundTypeBurn.
  ///
  /// In en, this message translates to:
  /// **'Burn'**
  String get woundTypeBurn;

  /// No description provided for @historySaved.
  ///
  /// In en, this message translates to:
  /// **'History saved successfully'**
  String get historySaved;

  /// No description provided for @failedToSaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to save history'**
  String get failedToSaveHistory;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistory;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get deleteHistory;

  /// No description provided for @deleteAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete All History'**
  String get deleteAllHistory;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all history?'**
  String get confirmDeleteAll;

  /// No description provided for @historyDeleted.
  ///
  /// In en, this message translates to:
  /// **'History deleted successfully'**
  String get historyDeleted;

  /// No description provided for @allHistoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'All history deleted successfully'**
  String get allHistoryDeleted;

  /// No description provided for @someItemsFailedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Some items failed to delete'**
  String get someItemsFailedToDelete;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete data'**
  String get failedToDelete;

  /// No description provided for @failedToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedToLoadHistory;

  /// No description provided for @noScanHistory.
  ///
  /// In en, this message translates to:
  /// **'No scan history yet.\nStart scanning wounds to see history here.'**
  String get noScanHistory;

  /// No description provided for @totalScanHistory.
  ///
  /// In en, this message translates to:
  /// **'Total {count} scan history'**
  String totalScanHistory(Object count);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @detectionResult.
  ///
  /// In en, this message translates to:
  /// **'Detection Result'**
  String get detectionResult;

  /// No description provided for @detectionImage.
  ///
  /// In en, this message translates to:
  /// **'Detection Result Image'**
  String get detectionImage;

  /// No description provided for @detectedWoundType.
  ///
  /// In en, this message translates to:
  /// **'Detected Wound Type'**
  String get detectedWoundType;

  /// No description provided for @treatmentRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Treatment Recommendation'**
  String get treatmentRecommendation;

  /// No description provided for @confidenceLevel.
  ///
  /// In en, this message translates to:
  /// **'Confidence Level'**
  String get confidenceLevel;

  /// No description provided for @accuracyLevel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy Level'**
  String get accuracyLevel;

  /// No description provided for @detectionAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Detection Accuracy'**
  String get detectionAccuracy;

  /// No description provided for @detectionTime.
  ///
  /// In en, this message translates to:
  /// **'Detection Time'**
  String get detectionTime;

  /// No description provided for @detailDetectionResult.
  ///
  /// In en, this message translates to:
  /// **'Detail Detection Result'**
  String get detailDetectionResult;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get noImage;

  /// No description provided for @treatmentRecommendationTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment Recommendation'**
  String get treatmentRecommendationTitle;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'AI-powered wound detection app that provides appropriate treatment recommendations'**
  String get appDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get version;

  /// No description provided for @mainFeatures.
  ///
  /// In en, this message translates to:
  /// **'Main Features'**
  String get mainFeatures;

  /// No description provided for @woundDetection.
  ///
  /// In en, this message translates to:
  /// **'Wound Detection'**
  String get woundDetection;

  /// No description provided for @woundDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan wounds using camera for wound type identification'**
  String get woundDetectionDesc;

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @aiAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI technology for analysis'**
  String get aiAnalysisDesc;

  /// No description provided for @treatmentRecommendationFeature.
  ///
  /// In en, this message translates to:
  /// **'Treatment Recommendation'**
  String get treatmentRecommendationFeature;

  /// No description provided for @treatmentRecommendationFeatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Treatment suggestions based on detected wound type'**
  String get treatmentRecommendationFeatureDesc;

  /// No description provided for @scanHistoryFeature.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistoryFeature;

  /// No description provided for @scanHistoryFeatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Save and review previous scan results'**
  String get scanHistoryFeatureDesc;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// No description provided for @developmentTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// No description provided for @greenMonkeyTeam.
  ///
  /// In en, this message translates to:
  /// **'GreenMonkey Team'**
  String get greenMonkeyTeam;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact us for help and suggestions'**
  String get supportDesc;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app is for reference only. Always consult with medical professionals for proper diagnosis and treatment.'**
  String get disclaimerText;

  /// No description provided for @giveHelp.
  ///
  /// In en, this message translates to:
  /// **'Give Help'**
  String get giveHelp;

  /// No description provided for @emergencyFirstAidGuide.
  ///
  /// In en, this message translates to:
  /// **'Emergency first aid guide'**
  String get emergencyFirstAidGuide;

  /// No description provided for @emergencyContact112.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact 112'**
  String get emergencyContact112;

  /// No description provided for @emergencyContactDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact Indonesian emergency services'**
  String get emergencyContactDesc;

  /// No description provided for @emergencyGuide.
  ///
  /// In en, this message translates to:
  /// **'Emergency Guide'**
  String get emergencyGuide;

  /// No description provided for @emergencySteps.
  ///
  /// In en, this message translates to:
  /// **'First aid steps'**
  String get emergencySteps;

  /// No description provided for @chokingAdult.
  ///
  /// In en, this message translates to:
  /// **'Choking (Adult, Elderly)'**
  String get chokingAdult;

  /// No description provided for @chokingAdultDesc.
  ///
  /// In en, this message translates to:
  /// **'Heimlich maneuver for adults'**
  String get chokingAdultDesc;

  /// No description provided for @chokingAdultInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Stay calm and assess the situation: if the victim can still cough or make sounds, let them cough to try to dislodge the object.\nb. If they can\'t breathe or speak, stand behind the victim and wrap your arms around their waist.\nc. Make a fist and place it above the navel, grasp with your other hand.\nd. Give quick upward and inward thrusts until the object comes out or the victim becomes unconscious.\ne. If the victim faints, start CPR and call emergency medical services (112).\nf. Stay with the victim until medical help arrives.'**
  String get chokingAdultInstructions;

  /// No description provided for @chokingChild.
  ///
  /// In en, this message translates to:
  /// **'Choking (Child)'**
  String get chokingChild;

  /// No description provided for @chokingChildDesc.
  ///
  /// In en, this message translates to:
  /// **'Special technique for children'**
  String get chokingChildDesc;

  /// No description provided for @chokingChildInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Stay calm and position the child leaning forward with head lower than chest.\nb. Give 5 firm back blows between the shoulder blades with the heel of your hand.\nc. If unsuccessful, turn the child to face you and give 5 abdominal thrusts with 2 fingers below the breastbone.\nd. Repeat back blows and abdominal thrusts until the object comes out.\ne. If the child faints, start CPR and call 112 immediately.\nf. Monitor breathing and stay with the child until help arrives.'**
  String get chokingChildInstructions;

  /// No description provided for @chokingBaby.
  ///
  /// In en, this message translates to:
  /// **'Choking (Baby)'**
  String get chokingBaby;

  /// No description provided for @chokingBabyDesc.
  ///
  /// In en, this message translates to:
  /// **'Special handling for babies'**
  String get chokingBabyDesc;

  /// No description provided for @chokingBabyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Place the baby face down on your forearm with head lower than body, support head and neck.\nb. Give 5 gentle but firm back blows between the shoulder blades with the heel of your hand.\nc. If unsuccessful, turn baby face up on your arm and give 5 chest compressions with 2 fingers in the center of chest.\nd. Repeat back blows and chest compressions until object comes out or baby becomes unresponsive.\ne. If baby becomes unresponsive, start infant CPR and call 112 immediately.\nf. Never put your finger in the baby\'s mouth unless you can clearly see the object.'**
  String get chokingBabyInstructions;

  /// No description provided for @severeBleeding.
  ///
  /// In en, this message translates to:
  /// **'Severe Bleeding'**
  String get severeBleeding;

  /// No description provided for @severeBleedingDesc.
  ///
  /// In en, this message translates to:
  /// **'How to stop bleeding'**
  String get severeBleedingDesc;

  /// No description provided for @severeBleedingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Wear protective gloves if available, or use another barrier to protect yourself.\nb. Apply direct pressure to the wound with a clean cloth, bandage, or clothing to stop bleeding.\nc. If blood soaks through, add another layer on top without removing the first layer.\nd. Elevate the bleeding body part above the heart if possible and there\'s no broken bone.\ne. If bleeding doesn\'t stop after 10 minutes of direct pressure, call 112 immediately.\nf. Monitor for signs of shock (pale, cold, weak) and keep victim warm until help arrives.'**
  String get severeBleedingInstructions;

  /// No description provided for @heartAttack.
  ///
  /// In en, this message translates to:
  /// **'Heart Attack'**
  String get heartAttack;

  /// No description provided for @heartAttackDesc.
  ///
  /// In en, this message translates to:
  /// **'Signs and emergency treatment'**
  String get heartAttackDesc;

  /// No description provided for @heartAttackInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Call 112 immediately or ask someone else to do it.\nb. Help the victim sit in a comfortable position, usually with knees bent and leaning back.\nc. Loosen tight clothing around neck and chest to ease breathing.\nd. If victim is conscious and not allergic, give 1 aspirin tablet to chew (not swallow whole).\ne. Monitor breathing and pulse; if they stop, start CPR immediately.\nf. Stay calm and stay with the victim, note the time symptoms started to report to medical personnel.'**
  String get heartAttackInstructions;

  /// No description provided for @stroke.
  ///
  /// In en, this message translates to:
  /// **'Stroke'**
  String get stroke;

  /// No description provided for @strokeDesc.
  ///
  /// In en, this message translates to:
  /// **'Early detection and treatment'**
  String get strokeDesc;

  /// No description provided for @strokeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Use the FAST test to recognize stroke: Face (ask to smile, is face drooping?), Arms (raise both arms, does one drift down?), Speech (ask to speak, is speech slurred/unclear?), Time (note time symptoms started).\nb. If there are signs of stroke, call 112 immediately - time is critical in stroke treatment.\nc. Help victim lie down with head and shoulders slightly elevated, turn head to side if vomiting.\nd. Don\'t give food or drinks as swallowing ability may be impaired.\ne. Loosen tight clothing and monitor breathing and consciousness.\nf. Note the time symptoms started and provide this information to medical personnel.'**
  String get strokeInstructions;

  /// No description provided for @fainting.
  ///
  /// In en, this message translates to:
  /// **'Fainting'**
  String get fainting;

  /// No description provided for @faintingDesc.
  ///
  /// In en, this message translates to:
  /// **'Handling unconscious person'**
  String get faintingDesc;

  /// No description provided for @faintingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Steps:\na. Ensure the area is safe and move victim away from danger (roads, sharp objects).\nb. Check victim\'s response by tapping shoulders and calling their name loudly.\nc. If unresponsive but breathing normally, position in recovery position (on their side).\nd. Loosen tight clothing around neck and chest, ensure airway is open.\ne. If victim is not breathing or breathing abnormally, start CPR and call 112 immediately.\nf. Monitor vital signs and stay with victim until they regain consciousness or medical help arrives.'**
  String get faintingInstructions;

  /// No description provided for @burns.
  ///
  /// In en, this message translates to:
  /// **'Burns'**
  String get burns;

  /// No description provided for @burnsDesc.
  ///
  /// In en, this message translates to:
  /// **'Treatment for minor to severe burns'**
  String get burnsDesc;

  /// No description provided for @burnsInstructions.
  ///
  /// In en, this message translates to:
  /// **'Cool the burn with running water for 10-20 minutes. Don\'t use ice. Cover with a clean, damp cloth. For severe burns, seek medical help immediately.'**
  String get burnsInstructions;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart solution for wound care'**
  String get homeSubtitle;

  /// No description provided for @checkWoundCondition.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Check\nWound Condition!'**
  String get checkWoundCondition;

  /// No description provided for @checkWoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s detect and monitor wounds early'**
  String get checkWoundSubtitle;

  /// No description provided for @emergencyKit.
  ///
  /// In en, this message translates to:
  /// **'Emergency Kit'**
  String get emergencyKit;

  /// No description provided for @emergencyKitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure you\'re ready to help with wound treatment'**
  String get emergencyKitSubtitle;

  /// No description provided for @bruiseWound.
  ///
  /// In en, this message translates to:
  /// **'Bruise Wound'**
  String get bruiseWound;

  /// No description provided for @scratchWound.
  ///
  /// In en, this message translates to:
  /// **'Scratch Wound'**
  String get scratchWound;

  /// No description provided for @cutWound.
  ///
  /// In en, this message translates to:
  /// **'Cut Wound'**
  String get cutWound;

  /// No description provided for @burnWound.
  ///
  /// In en, this message translates to:
  /// **'Burn Wound'**
  String get burnWound;

  /// No description provided for @unknownWound.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownWound;

  /// No description provided for @woundNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Wound not detected'**
  String get woundNotDetected;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @scanInstruction1.
  ///
  /// In en, this message translates to:
  /// **'Ensure adequate lighting'**
  String get scanInstruction1;

  /// No description provided for @scanInstruction2.
  ///
  /// In en, this message translates to:
  /// **'Focus camera on wound area'**
  String get scanInstruction2;

  /// No description provided for @scanInstruction3.
  ///
  /// In en, this message translates to:
  /// **'Avoid shadows in photo'**
  String get scanInstruction3;

  /// No description provided for @scanInstruction4.
  ///
  /// In en, this message translates to:
  /// **'Take photo from appropriate distance'**
  String get scanInstruction4;

  /// No description provided for @bruiseRecommendation1.
  ///
  /// In en, this message translates to:
  /// **'Apply a cold compress or an ice pack wrapped in a cloth to the injured area for 10–15 minutes immediately after the injury to reduce swelling and subcutaneous bleeding.'**
  String get bruiseRecommendation1;

  /// No description provided for @bruiseRecommendation2.
  ///
  /// In en, this message translates to:
  /// **'Repeat cold compress every 2–3 hours during the first 24 hours after the injury.'**
  String get bruiseRecommendation2;

  /// No description provided for @bruiseRecommendation3.
  ///
  /// In en, this message translates to:
  /// **'After 24 hours, switch to a warm compress for 10–15 minutes several times a day to improve blood flow and speed up healing.'**
  String get bruiseRecommendation3;

  /// No description provided for @bruiseRecommendation4.
  ///
  /// In en, this message translates to:
  /// **'Elevate the injured area above heart level to reduce swelling.'**
  String get bruiseRecommendation4;

  /// No description provided for @bruiseRecommendation5.
  ///
  /// In en, this message translates to:
  /// **'Rest the injured area and avoid activities that worsen the pain and swollen.'**
  String get bruiseRecommendation5;

  /// No description provided for @bruiseRecommendation6.
  ///
  /// In en, this message translates to:
  /// **'Apply a thin layer of ointment containing heparin (e.g., Trombophob) to the bruise to help break down blood clots under the skin.'**
  String get bruiseRecommendation6;

  /// No description provided for @bruiseRecommendation7.
  ///
  /// In en, this message translates to:
  /// **'Take pain relievers such as paracetamol if the pain becomes bothersome.'**
  String get bruiseRecommendation7;

  /// No description provided for @cutRecommendation1.
  ///
  /// In en, this message translates to:
  /// **'Wash your hands with soap and running water before touching or handling the wound.'**
  String get cutRecommendation1;

  /// No description provided for @cutRecommendation2.
  ///
  /// In en, this message translates to:
  /// **'Clean the wound with running water to remove dirt.'**
  String get cutRecommendation2;

  /// No description provided for @cutRecommendation3.
  ///
  /// In en, this message translates to:
  /// **'Gently press the wound area with sterile gauze or a clean tissue until the bleeding stops.'**
  String get cutRecommendation3;

  /// No description provided for @cutRecommendation4.
  ///
  /// In en, this message translates to:
  /// **'Apply antiseptic such as povidone-iodine (Betadine) on the wound area.'**
  String get cutRecommendation4;

  /// No description provided for @cutRecommendation5.
  ///
  /// In en, this message translates to:
  /// **'Cover the wound with a plaster or sterile gauze to prevent contamination.'**
  String get cutRecommendation5;

  /// No description provided for @cutRecommendation6.
  ///
  /// In en, this message translates to:
  /// **'Change the dressing routine or immediately if it becomes dirty or wet.'**
  String get cutRecommendation6;

  /// No description provided for @cutRecommendation7.
  ///
  /// In en, this message translates to:
  /// **'Watch for signs of infection such as excessive redness, swelling, pus, or fever.'**
  String get cutRecommendation7;

  /// No description provided for @cutRecommendation8.
  ///
  /// In en, this message translates to:
  /// **'If the cut is too wide, deep, or longer than approximately 2 cm, go to the nearest healthcare facility for evaluation and possible stitches.'**
  String get cutRecommendation8;

  /// No description provided for @scratchRecommendation1.
  ///
  /// In en, this message translates to:
  /// **'Clean the wound with running water to remove dirt'**
  String get scratchRecommendation1;

  /// No description provided for @scratchRecommendation2.
  ///
  /// In en, this message translates to:
  /// **'Use sterile tweezers to remove sand, dust, or foreign objects stuck to the skin.'**
  String get scratchRecommendation2;

  /// No description provided for @scratchRecommendation3.
  ///
  /// In en, this message translates to:
  /// **'Apply an antiseptic such as povidone-iodine (Betadine) or other antiseptic solutions to the wound area.'**
  String get scratchRecommendation3;

  /// No description provided for @scratchRecommendation4.
  ///
  /// In en, this message translates to:
  /// **'Cover the wound with a plaster or sterile gauze to prevent contamination.'**
  String get scratchRecommendation4;

  /// No description provided for @scratchRecommendation5.
  ///
  /// In en, this message translates to:
  /// **'If swelling occurs, apply a cold compress in the early stages of the injury.'**
  String get scratchRecommendation5;

  /// No description provided for @scratchRecommendation6.
  ///
  /// In en, this message translates to:
  /// **'If the cut is too wide, deep, longer than ±2 cm, or bleeding that is difficult to stop, immediately go to the nearest health facility for evaluation and possible stitches.'**
  String get scratchRecommendation6;

  /// No description provided for @burnRecommendation1.
  ///
  /// In en, this message translates to:
  /// **'Stop the burning process by moving away from the heat source or the cause of injury.'**
  String get burnRecommendation1;

  /// No description provided for @burnRecommendation2.
  ///
  /// In en, this message translates to:
  /// **'Remove clothing and jewelry around the burn area; if clothing sticks to the skin, cut around it without pulling the stuck part.'**
  String get burnRecommendation2;

  /// No description provided for @burnRecommendation3.
  ///
  /// In en, this message translates to:
  /// **'Rinse the affected area with running water for 30 minutes.'**
  String get burnRecommendation3;

  /// No description provided for @burnRecommendation4.
  ///
  /// In en, this message translates to:
  /// **'Determine degree of the burn, the location of the burn, and the presence of complicating factors such as respiratory distress or chemical burns.'**
  String get burnRecommendation4;

  /// No description provided for @burnRecommendation5.
  ///
  /// In en, this message translates to:
  /// **'For first-degree burns affecting only the outer layer of skin, apply aloe vera gel or an ointment such as Bioplacenton thinly after cooling, then cover with wet sterile gauze if necessary, and give pain relievers like paracetamol or ibuprofen if necessary.'**
  String get burnRecommendation5;

  /// No description provided for @burnRecommendation6.
  ///
  /// In en, this message translates to:
  /// **'For second-degree burns characterized by blisters, pain, and redness, after cooling and gentle cleaning, cover with a non-stick wet sterile gauze, use a topical antibiotic ointment such as silver sulfadiazine or Bioplacenton to prevent infection, and paracetamol or ibuprofen if necessary.'**
  String get burnRecommendation6;

  /// No description provided for @burnRecommendation7.
  ///
  /// In en, this message translates to:
  /// **'For third-degree burns involving damage to all layers of the skin down to underlying tissues, immediately cover with a clean cloth or wet sterile gauze, do not apply any ointments or medications, maintain airway ,dan prevent hypothermia, and promptly refer to a healthcare facility for advanced care.'**
  String get burnRecommendation7;

  /// No description provided for @burnRecommendation8.
  ///
  /// In en, this message translates to:
  /// **'Immediately seek medical attention if the burn is extensive, affects the face, hands, feet, genitals, airways, or is accompanied by systemic symptoms such as shortness of breath, dizziness, or loss of consciousness.'**
  String get burnRecommendation8;

  /// No description provided for @indonesiaLanguage.
  ///
  /// In en, this message translates to:
  /// **'🇮🇩 Indonesia'**
  String get indonesiaLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 English'**
  String get englishLanguage;

  /// No description provided for @scanTips.
  ///
  /// In en, this message translates to:
  /// **'Scan Tips'**
  String get scanTips;

  /// No description provided for @noRecommendationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No recommendations'**
  String get noRecommendationsAvailable;

  /// No description provided for @pageInfo.
  ///
  /// In en, this message translates to:
  /// **'Page {currentPage} of {lastPage}'**
  String pageInfo(int currentPage, int lastPage);

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language / Bahasa'**
  String get languageSettings;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get confidenceHigh;

  /// No description provided for @confidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get confidenceMedium;

  /// No description provided for @confidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get confidenceLow;

  /// No description provided for @kit.
  ///
  /// In en, this message translates to:
  /// **'Kit'**
  String get kit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logout;

  /// No description provided for @processScan.
  ///
  /// In en, this message translates to:
  /// **'Analyzing the wound'**
  String get processScan;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @addNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a note for this history (optional):'**
  String get addNoteDescription;

  /// No description provided for @addNotePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Example: Wound occurred while cooking, already cleaned with water...'**
  String get addNotePlaceholder;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes added'**
  String get noNotes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
