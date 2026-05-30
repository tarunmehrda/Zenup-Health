<!-- converted from Zenup_Health_75Day_Plan_.docx -->




Zenup Health
75-Day Flutter App Development Plan
Frontend Client · Flutter 3.x · iOS & Android






Psychiatry · Therapy · Mental Health Booking
Built for zenuphealth.com
Project Manager: Samarth Mehta
Developers: Arnav, Tarun, Yashwanth

# Table of Contents

Project Overview & Frontend Architecture	Page 3
Phase 1 — Days 1–9: Foundation & Setup	Page 4
Phase 2 — Days 10–26: Core Features & Booking Flow	Page 6
Phase 3 — Days 27–45: Advanced Telehealth & Local Persistence	Page 10
Phase 4 — Days 46–62: Polish & Testing	Page 15
Phase 5 — Days 63–75: Launch & Deploy	Page 20
Daily Deliverables Tracker	Page 23
Estimated Project Costs	Page 25
Risk Register & Launch Checklist	Page 26

# Project Overview
Zenup Health is a mental health platform offering psychiatry, therapy, and counseling booking at zenuphealth.com. This Flutter app is developed as a frontend-first client utilizing client-side state management (Riverpod), local data caching (Hive), and a  Supabase backend for user authentication and core data persistence. The architecture keeps the app fast and offline-capable, while Supabase handles secure login and syncing confirmed bookings and user profiles to the cloud.
### Project Team & Personnel

### Architecture Principles
- Frontend-First: Full UI built and validated offline using mock repositories before backend wiring.
- Local Caching: Hive database for encrypted on-device data persistence — appointments, profiles, messages.
- Supabase Auth ( Backend): Supabase handles secure user sign-up, login, and session tokens only.
- Supabase Data Sync: Confirmed bookings and user profiles are written to Supabase Postgres in real time.
- Robust State Management: Riverpod providers cleanly separate UI from data layers.
- Offline-Capable: All screens function with local Hive cache — Supabase syncs in the background.

### Complete Tech Stack

## Phase 1 — Foundation & Setup (Days 1–9)
Day 1: Project Init & Folder Architecture
Tasks:
- Create Flutter project using standard naming and organization settings
- Establish clean architecture directory structure (features, core, shared, mock_services)
- Initialize Git repository and configure Git ignore files for sensitive environments
- Add package dependencies including Riverpod, Hive local storage, and GoRouter
- Configure Android and iOS project settings for minimum SDK versions
Deliverables:
- Flutter project boots on emulator
- Git repository initialized
- Dependencies configuration complete

Day 2: Local Storage & State Management Setup
Tasks:
- Configure Riverpod global state container provider wrapper
- Set up application config file for environment switches (mock/dev)
- Initialize Hive local storage in the main application entry point
- Create a dedicated local storage service class wrapper using Hive
- Verify local cache read and write flows using test key-value pairs
Deliverables:
- Local storage service initialized
- Riverpod state notifier configured
- Cache read/write test passing

Day 3: Local Database Schema & Hive Adapters
Tasks:
- Define Dart models representing User, Appointment, Mood, and Chat data structures
- Register Hive type adapters and generate Hive adapters using build_runner
- Create client-side data schema definitions for local models
- Implement local database manager with secure AES encryption keys
- Configure local data backup mechanisms and clean-up routines
Deliverables:
- Hive adapters generated successfully
- Local models registered
- Local data security layer active

Day 4: Design System & Theme
Tasks:
- Define color, typography, and spacing constants in theme config
- Configure Material theme with selected typography and styling guidelines
- Build reusable custom UI components: buttons, cards, inputs, badges, and avatars
- Set up application asset directories for assets and icons
- Add branding icons and image assets to project folders
Deliverables:
- Theme configuration complete
- Reusable UI widgets built
- Fonts rendering correctly

Day 5: Navigation Configuration
Tasks:
- Set up declarative routing using GoRouter package
- Define application routing paths (splash, login, dashboard, profile, booking)
- Implement navigation guard checking user client-side login state
- Create bottom navigation bar layout linking main tabs
- Configure deep linking pathways for application redirection
Deliverables:
- All routes defined
- Client-side login guard redirecting correctly
- Bottom nav working

Day 6: Authentication — Supabase Auth Integration
Tasks:
- Initialize Supabase Flutter SDK and configure project URL + anon key
- Build login and sign-up UI with email/password validation forms
- Connect login form to Supabase Auth — supabase.auth.signInWithPassword()
- Connect sign-up form to Supabase Auth — supabase.auth.signUp()
- Build mock Google OAuth sign-in flow for visual feedback
- Handle Supabase auth error responses with user-friendly messages
Deliverables:
- Supabase Auth login functional
- Sign-up flow creating real user in Supabase
- Auth error handling active

Day 7: Auth State & Profile Sync to Supabase
Tasks:
- Listen to Supabase auth state stream and auto-route user on login/logout
- On first login: show profile setup form (name, date of birth, contact)
- Save completed profile to Supabase 'profiles' table via REST insert
- Cache profile data locally in encrypted Hive box for offline access
- Implement local file picker and upload avatar to Supabase Storage bucket
Deliverables:
- Supabase auth stream auto-navigating
- Profile saved to Supabase profiles table
- Avatar uploaded to Supabase Storage

Day 8: Splash, Onboarding & Local State Tests
Tasks:
- Build animated splash screen with entrance animations
- Create multi-slide onboarding flow with local state storage
- Write unit tests for authentication notifier and local storage service
- Fix Phase 1 visual bugs and layout adjustments
- Document environment settings and local storage structure in README
Deliverables:
- Splash + onboarding working
- Unit tests passing
- README updated with local setup instructions

Day 9: Buffer Day — Setup & Environment Contingency
Tasks:
- Resolve unexpected issues with local storage initialization or path provider
- Verify Hive model migrations and key security setup on test platforms
- Debug dependency conflicts or compiler issues on target platform simulators
- Update local development environment onboarding documentation
Deliverables:
- Verified local environment with updated configuration
- Setup and storage troubleshooting notes completed


## Phase 2 — Core Features  (Days 10–26)
Day 10: Home Dashboard
Tasks:
- Build Home screen with user greeting loading profile data
- Create upcoming appointments widget querying local logs in Hive
- Add quick-action pathways for booking, messages, and appointments overview
- Create featured providers listing sorted by highest ratings
- Add appointment scheduling summary widget using local sources
Deliverables:
- Home screen loading cached user data
- Appointments widget showing
- Featured providers list complete

Day 11: Provider Discovery & Search
Tasks:
- Create provider directory listing filtering by specialty
- Implement client-side search functionality over provider names and bios
- Design filter selection chips for medical categories
- Design provider details card using profile and image resources
- Implement sorting options by rating and availability slots
Deliverables:
- Provider list loaded from local assets
- Search and filtering functional
- Sorting options active

Day 12: Provider Profile Screen
Tasks:
- Fetch detailed provider profile data and reviews from local JSON assets
- Display bio details, credentials, ratings, and feedback counts
- Create availability calendar displaying open booking slots
- Render reviews list ordered by submission date
- Add booking action button redirecting to scheduling flow
Deliverables:
- Provider details rendering correctly
- Availability slots loaded
- Reviews feed functional

Day 13: Booking Flow Steps 1 & 2
Tasks:
- Implement multi-step booking state notifier using Riverpod
- Step 1: Select preferred appointment medium (video, in-person, audio)
- Step 2: Display date picker and fetch corresponding open slots
- Create interactive time-slot grid disabling filled appointments
- Store selected slot reference in scheduling state
Deliverables:
- Booking state managed reactively
- Date and slot selection complete
- Occupied slots disabled

Day 14: Booking Flow Steps 3 & 4 — Confirm & Sync
Tasks:
- Step 3: Collect billing information and pre-fill from user profile
- Step 4: Display booking summary review screen
- On confirm: Write appointment record to Supabase 'appointments' table
- Cache confirmed appointment in local Hive box for offline access
- Mark the selected slot as booked in the local calendar state
- Trigger local booking success notification reminder
Deliverables:
- Appointment saved to Supabase appointments table
- Cached in Hive for offline
- Local confirmation alert triggered

Day 15: Appointments Management Screen
Tasks:
- Create appointments interface with tabs for upcoming, past, and cancelled
- Connect dashboard with local appointments stream listener for live status updates
- Implement reschedule option updating local booking slot and status
- Implement cancel option updating booking status in local storage
- Add cancellation policy modal warning users before confirmation
Deliverables:
- Appointments list updating in real time
- Reschedule request processing
- Cancellation flow active

Day 16: Client-Side Payment Gateway Integration
Tasks:
- Configure Razorpay SDK package for client checkout flow
- Initialize client payment parameters and trigger checkout request from Flutter
- Design mock payment checkout screen with secure Razorpay branding
- Handle payment checkout success, failure, and cancellation states in UI
- Update local appointment record with transaction ID and status
Deliverables:
- Razorpay SDK client integrated
- Mock checkout screen functional
- Payment status saved in local database

Day 17: Billing & Invoices UI
Tasks:
- Manage member insurance detail fields within user profile form
- Retrieve paid appointments list to render billing history
- Implement client-side PDF document generator in Flutter
- Generate invoice and receipt PDFs directly on the device
- Add insurance information edit form with form validation rules
Deliverables:
- Insurance fields editable in profile
- Billing history populated
- Client-side PDF invoice generation functional

Day 18: Client-Side Messaging UI
Tasks:
- Build chat interface between patient and provider
- Load historical message records from local Hive store
- Implement send message operation saving new message to Hive
- Simulate chat stream with automated responses for demo purposes
- Configure typing indicators using local timer triggers
Deliverables:
- Message history loading from Hive
- Message sending operational
- Typing indicators simulated

Day 19: Local Scheduled Notifications
Tasks:
- Configure local notification scheduler package
- Schedule automated reminder triggers for upcoming appointments
- Set up daily check-in prompt notifications at custom times
- Register local notification channels for Android and iOS
- Set up deep links to open corresponding screens when tapping notification
Deliverables:
- Local scheduler configured
- Automated reminders working
- Notification deep links active

Day 20: Buffer Day — Payment SDK Sandbox & Theme Calibration
Tasks:
- Troubleshoot Razorpay SDK integration or layout anomalies
- Test simulated slow state changes and loading spinners during checkout
- Adjust app color palette and dark/light theme consistency
- Verify local state persistence after cold restarts
Deliverables:
- Razorpay sandbox flow verified
- Layout theme audits completed

Day 21: Multi-Provider Schedule Sync
Tasks:
- Design Dart data structures representing multi-provider slots and schedule sync
- Create local database model for tracking schedule changes and updates
- Implement logic to prevent double-booking on overlapping provider slots
Deliverables:
- Provider sync models initialized
- Schedule overlap resolver class created

Day 22: Booking Customization UI
Tasks:
- Build custom notes field during booking to add patient concerns
- Implement selector for language preference or doctor gender flags
- Design validation rules for booking custom fields
Deliverables:
- Booking concerns field functional
- Custom doctor flags verified

Day 23: UI Concurrency Guards & Input Validation
Tasks:
- Implement client-side transaction locks to prevent double-booking on quick double-taps
- Design input guard validation rules for all interactive forms
- Write widget tests simulating rapid simultaneous user inputs on calendar slots
Deliverables:
- Client-side booking locking logic operational
- Double-tap form validations active

Day 24: In-App Booking Cancellation & Client Refund Simulation
Tasks:
- Build slot release animation on booking cancellation
- Simulate wallet credits refund on cancellations within policy limits
- Set up local notifications alerting user of slot release
Deliverables:
- Local refund/credit simulation active
- Slot release state updated in Hive

Day 25: Client-Side State Stress Testing
Tasks:
- Perform memory stress testing with large local datasets (1000+ mock slots)
- Verify UI rendering frame rates and scroll performance
- Optimize local search index queries over provider profiles
Deliverables:
- Stress testing completed
- Local search index latency minimized

Day 26: Local PDF Invoice Export
Tasks:
- Automate local patient invoice PDF generation post-booking
- Map billing details and invoice download paths to local appointment histories
- Build manual invoice download button in patient's billing screen
Deliverables:
- Invoice PDF export functional
- Billing history download link verified


## Phase 3 — Advanced Features & Local Caching (Days 27–45)
Day 27: Telehealth Video UI (MediaSFU Integration)
Tasks:
- Add video consultation SDK module to the application dependencies
- Configure video calling client connection details for audio and video rooms
- Build telehealth call screen displaying remote and local camera streams
- Add interface controllers for camera toggling, mic mute, and screen sharing
- Store mock session credentials securely within local appointment notes
Deliverables:
- Telehealth video call working on emulator
- Connected to media room layout
- Telehealth call controls functional

Day 28: Telehealth — Device Testing & Polish
Tasks:
- Test telehealth call screen on physical iOS and Android hardware
- Add network connection quality indicators and status overlay to call screen
- Build in-app post-session feedback survey
- Manage application backgrounding states (Picture-in-Picture mode) during live calls
- Integrate interactive chat panel overlay into the active video session
Deliverables:
- Video UI tested on real devices
- Post-session survey interface complete
- In-call chat overlay working

Day 29: Prescription Tracking
Tasks:
- Create prescriptions screen showing active user prescriptions
- Display detail card for medication names, dosages, schedules, and providers
- Implement refill request flow with mock request notifications in app
- Configure local system notifications to remind users to take medication
- Build listing filter displaying archived or inactive prescriptions
Deliverables:
- Prescriptions list rendering
- Refill request flow functional
- Local medication reminders

Day 30: Health Records File Explorer
Tasks:
- Build personal health records file explorer interface
- Implement local file picker to select health documents
- Encrypt documents before saving to secure local application directory
- Retrieve listing of files registered under the user's local directory
- Generate secure file preview screen inside the application
Deliverables:
- Local health records explorer complete
- Files encrypted and stored
- In-app file preview working

Day 31: Advanced Booking Filters
Tasks:
- Build search filter form allowing sorting of doctor directory by availability timeslots
- Create active filters status bar widget for selected criteria
- Build interactive filters resetting animation
- Implement favorites list caching doctors using Hive database box
- Generate provider rating summaries calculating score stats locally
Deliverables:
- Favorites system registered in Hive
- Availability filters functional
- Dynamic search active

Day 32: In-App Alerts & Settings
Tasks:
- Build list showing local notifications and system alerts
- Create account settings screen allowing users to edit profile and reset password
- Configure notification preference switches and save choices in local profile
- Integrate option for analytics collection opt-out in settings
- Add local data purging tool triggering secure storage cleanup
Deliverables:
- Notifications center screen active
- Settings updating preferences in Hive
- Data purging flow functional

Day 33: Provider Rating Form
Tasks:
- Build rating feedback form linking patient and provider
- Configure validation to only allow feedback for completed appointments
- Recalculate average provider rating locally when new feedback is submitted
- Update provider local cache database in Hive
- Display updated review feed on the provider details screen
Deliverables:
- Review form UI complete
- Provider rating auto-calculated locally
- Reviews visible on details profile

Day 34: Local Appointment Alerts & Campaign Prompts
Tasks:
- Create scheduled timer checking for upcoming 24-hour bookings
- Trigger local notification alert for upcoming patient slots
- Implement in-app campaign banner prompts suggesting scheduling
- Verify user notification preferences before showing campaign banners
Deliverables:
- Timer check active
- 24-hour alerts functional
- Campaign prompts working

Day 35: Medication Reminder Alerts & Logs
Tasks:
- Build scheduled timers for medication schedule intakes
- Create localized daily logs tracking consumed doses
- Verify medication alerts triggers using background task scheduler
Deliverables:
- Medication reminders working
- Push alarms configured
- Intake logs saved locally

Day 36: Telehealth Connection Diagnostics UI
Tasks:
- Design call diagnostic overlay alerting user of network issues
- Log call exception events in local diagnostic logs
- Set up automatic rescheduling recommendation dialogs for patients
Deliverables:
- Diagnostics overlay functional
- Call failure logging active
- Reschedule dialog active

Day 37: Post-Call Consultation Summary & Review
Tasks:
- Trigger post-consultation feedback prompt on call end
- Sync review score and comments to local appointment history
- Design escalation dialog for negative rating feedback
Deliverables:
- Post-call prompt active
- Reviews logged in local history
- Escalation dialog verified

Day 38: Offline Outbox Queue & Sync
Tasks:
- Implement offline sync manager caching user actions while offline
- Display connectivity banner when app is offline
- Implement retry logic to process outbox on reconnect
- Clear outbox queue database on logout
Deliverables:
- Outbox queue active
- Offline banner working
- Cache cleared on logout

Day 39: Referral Sharing UI
Tasks:
- Add referral code generation logic based on user profile metadata
- Generate unique alphanumeric code for each user on sign-up
- Enable referral code sharing via native share utility (share_plus)
- Apply registration attribution logic to credit referred users
- Create rewards display showing total counts of successful referrals
Deliverables:
- Referral code generated
- Native share sheet working
- Rewards dashboard complete

Day 40: Accessibility & Localization
Tasks:
- Audit application layout against accessibility standard checklists
- Add semantic labels and accessibility tags to all interactive components
- Configure localization libraries for multi-language display support
- Create translated text resource files for supported languages
- Test application interface using system screen reader tools
Deliverables:
- Accessibility audit complete
- Screen reader working
- Spanish translations added

Day 41: Security Hardening & Encryption
Tasks:
- Verify that all local database boxes in Hive use AES-256 encryption keys
- Implement local biometric authentication check (fingerprint/face)
- Encrypt local file directories containing personal health documents
- Add secure SSL pinning configuration for external API calls
- Audit local security parameters in build configurations
Deliverables:
- Local database encrypted
- Biometric auth gate working
- Folder encryption active

Day 42: Phase 3 Integration Test & Demo
Tasks:
- Run full client scenario flow testing all advanced features
- Profile memory performance and resolve any identified leaks
- Review local query execution latency and optimize list indexing
- Conduct system walkthrough demo highlighting completed functionality
Deliverables:
- Integration tests passing
- No memory leaks
- Walkthrough demo verified

Day 43: Buffer Day — Telehealth Call Screens & Layout Adjustments
Tasks:
- Debug device hardware permission flows (mic/camera) on physical target platforms
- Verify offline storage caching and outbox sync queue on flaky networks
- Resolve layout responsiveness issues for telehealth overlay screens on tablets
Deliverables:
- Offline outbox verified
- Telehealth call overlays tested on tablet layouts

Day 44: Local Cache Pruning & Purging Utility
Tasks:
- Implement memory cleanup routines deleting expired schedules and logs
- Create diagnostic dashboard showing cache size
- Verify that GDPR-compliant profile and appointment purge flows delete completely
Deliverables:
- Local cache statistics operational
- Data cache purging utility active
- GDPR deletion verified

Day 45: Offline Flow Simulation Dry-Run
Tasks:
- Simulate extended offline session with multi-booking and messaging flows
- Audit local outbox queue storage limits and retry counts
- Conduct offline-to-online reconciliation dry-run test
Deliverables:
- Offline flow simulations complete
- Offline sync outbox validated
- Reconciliation logic verified


## Phase 4 — Polish & Testing (Days 46–62)
Day 46: UI Animation Polish
Tasks:
- Hero transitions between provider list and provider profile screens
- Shimmer loading placeholders on all list screens during data fetch
- Lottie animations for empty states (no appointments, no messages)
- Micro-interactions: button press haptic feedback, card tap scale
- Smooth PageView transitions in onboarding flows
Deliverables:
- Hero transitions working
- Shimmer on all loaders active
- Lottie empty states rendering

Day 47: Error Handling & Empty States
Tasks:
- Wrap all repository calls in try/catch blocks with custom exceptions
- Show user-friendly, localized error messages in UI
- Empty state layouts for: no appointments, no messages, no prescriptions
- Full-screen error widget with retry button that re-calls service notifier
- Network connectivity lost banner via connectivity_plus package
Deliverables:
- Friendly error screens active
- Empty states on all screens
- Retry widget functional

Day 48: Performance Optimization
Tasks:
- Profile all screens with Flutter DevTools to ensure 60fps
- Add const constructors to static layouts and components
- Optimize local list builders with lazy loading and pagination
- Lazy load cached images using cached_network_image package
- Reduce widget rebuilds by isolating Riverpod state select parameters
Deliverables:
- 60fps on all screens
- Paginated list builders active
- Images cached locally

Day 49: Unit Testing — Mock Repositories
Tasks:
- Mock repository interfaces using mocktail package
- Test MockAppointmentRepository: fetch, insert, update, cancel
- Test AuthNotifier: sign in, sign up, sign out state transitions
- Test MockProfileRepository: fetch profile, update profile
- Test BookingNotifier state machine (step 1 to 4 confirm flows)
Deliverables:
- Repository tests passing
- AuthNotifier tests passing
- 80%+ business logic coverage

Day 50: Widget & Golden Testing
Tasks:
- Write widget tests for custom design widgets (ZButton, ZCard, ZInput)
- Test booking flow screens using mocked Riverpod providers
- Test login form validations (empty, invalid email, short password)
- Perform golden tests for visual layout regression monitoring
- Test provider profile card rendering with mock datasets
Deliverables:
- Widget tests complete
- Golden tests passing
- Validation tests active

Day 51: Patrol E2E Testing
Tasks:
- Write Patrol E2E test journey: signup, complete profile, book, pay
- Write Patrol E2E test: login, view bookings, cancel booking
- Run Patrol integration tests on physical iOS and Android devices
- Add E2E tests to GitHub Actions CI workflow runs
Deliverables:
- 3 E2E test journeys passing
- Real device tests completed
- CI running Patrol

Day 52: Internal Beta Distribution
Tasks:
- Build release IPAs (iOS) and App Bundles (AAB for Android)
- Upload to TestFlight and invite internal team (10 testers)
- Upload to Google Play Console Internal Testing track
- Configure Sentry SDK client-side crash reporting in main
- Collect structured feedback from internal team using form
Deliverables:
- TestFlight build live
- Play Console internal track live
- Feedback form distributed

Day 53: App Assets Preparation & Optimization
Tasks:
- Audit app assets bundle size to minimize final application payload
- Optimize all PNG/JPEG/Lottie assets using compression tools
- Compress font files and remove unused font variations
- Clean up unused package dependencies in pubspec.yaml
Deliverables:
- Assets optimized
- Package bundle size minimized
- Cleaner build output ready

Day 54: External Beta — 50 Users
Tasks:
- Expand TestFlight invite list to 50 external beta testers
- Expand Play Console closed track to 50 external beta testers
- Monitor Sentry crash logs for uncaught client exceptions
- Triage and resolve high-priority beta user bug reports
- Test performance on older physical target devices
Deliverables:
- 50 external testers active
- Sentry telemetry monitored
- Beta crash reports resolved

Day 55: Local PHI Scrubbing & Log Security
Tasks:
- Audit application logs to ensure no protected health info is outputted
- Configure local log rotation and diagnostic log file size limits
- Verify secure key storage configurations in Vault/Keyring platforms
Deliverables:
- PHI data scrubbing active
- Local log security verified
- Encrypted log export ready

Day 56: Offline Outbox Queue & API Webhook Failover
Tasks:
- Build offline sync manager for outbox sync queue
- Write local db logic monitoring retry limits and sync statuses
- Verify failover handling under simulated network outages
Deliverables:
- Outbox sync queue verified
- API failure logs active
- Failover scenarios tested

Day 57: Hive Database Integrity Auditing
Tasks:
- Perform database integrity checks on local Hive files during boot
- Audit local cache synchronization logs for structural discrepancies
- Design auto-repair logic resolving corrupted local cache files
Deliverables:
- Hive integrity check active
- Cache database check completed
- Auto-repair routines verified

Day 58: Buffer Day — Beta Bug Triaging & Crash Fixes
Tasks:
- Review Sentry crash reports from active TestFlight and Play Console closed track
- Triage and fix critical visual bugs or state exceptions in booking flow
- Hotfix high-impact exception triggers in authentication and calendar widgets
- Build and deploy update builds to Apple TestFlight and Google Play Console
Deliverables:
- All reported blocking exceptions resolved
- Updated beta builds successfully deployed

Day 59: Buffer Day — Local Security Verification
Tasks:
- Verify that all local database files use secure encryption keys
- Confirm that no patient information is outputted to device console logs
- Verify the end-to-end data export and delete GDPR flows
- Review App Store and Google Play data safety declaration questionnaires
Deliverables:
- Security configuration verified
- Local logs audited and locked
- Data safety checklists ready

Day 60: Compliance & Privacy Review
Tasks:
- Ensure all local database encryption is verified
- Ensure no PHI is outputted to client-side logs or crash logs
- Add in-app privacy policy and terms of service screens
- Implement client-side GDPR data export utility
- Implement client-side GDPR data deletion utility
Deliverables:
- Encryption verified
- Privacy policy screens in app
- GDPR data flows functional

Day 61: Bug Fix Sprint
Tasks:
- Triage all user feedback and bug reports from external beta
- Fix all crash exceptions on older devices
- UI fixes for small screen layout responsiveness
- Fix local notification scheduler triggers
- Upload final release candidate build to store consoles
Deliverables:
- All crashes fixed
- UI layout bugs resolved
- Final release build ready

Day 62: Release Candidate & Sign-Off
Tasks:
- Full regression testing of all frontend client flows
- Tag release candidate in Git repository: v1.0.0-rc1
- Stakeholder sign-off meeting
- Freeze features - no new features until v1.1
- Prepare App Store and Google Play metadata, screenshots, and descriptions
Deliverables:
- Release candidate tagged
- Stakeholder sign-off complete
- Store metadata ready


## Phase 5 — Launch & Deploy (Days 63–75)
Day 63: App Store Assets & Metadata
Tasks:
- Design screenshots for all required sizes (6.7", 6.1", 5.5", iPad)
- Write App Store description with mental health and therapy keywords
- Create 30-second app preview demonstration video
- Finalize 1024x1024px App Store icon
- Live privacy policy and terms of service URLs on website
Deliverables:
- Screenshots ready
- App Store metadata copy finalized
- Privacy link live

Day 64: iOS App Store Submission
Tasks:
- Configure Xcode signing and distribution credentials
- Build release IPA using command: flutter build ipa --release
- Upload IPA to App Store Connect using Fastlane tools
- Complete App Store Connect review questionnaires (encryption, data safety)
- Submit for Apple review
Deliverables:
- IPA uploaded to App Store Connect
- Connect questionnaires complete
- Submitted to Apple for review

Day 65: Google Play Submission
Tasks:
- Build Android App Bundle: flutter build appbundle --release
- Sign with release keystore credentials
- Upload App Bundle (AAB) to Google Play Console Production track
- Complete Google Play Store listing information
- Publish build for Google Play review
Deliverables:
- AAB uploaded to Play Console
- Play Store listing complete
- Live on Google Play

Day 66: Review Delay Buffer — App Store Feedbacks
Tasks:
- Monitor App Store Connect review progress and respond immediately to reviewer inquiries
- Address potential app classification queries regarding medical category
- Prepare alternative metadata descriptions if requested by reviewers
- Configure pricing tiers and test-user credentials in App Store Connect
Deliverables:
- Apple reviewer feedback handled
- iOS store requirements met

Day 67: Review Delay Buffer — Google Play Console Closed Testing
Tasks:
- Verify that closed-testing compliance tracks remain active with required testers
- Monitor Google Play dashboard for console alerts or review delays
- Review pre-launch reports generated by the Play Console test lab
- Prepare fallback builds in case of build-rejection notifications
Deliverables:
- Google pre-launch alerts resolved
- Android store requirements met

Day 68: Sentry & Mixpanel Setup
Tasks:
- Enable Sentry crash reporting configuration in the production app
- Configure Sentry alerts for new crash types and anomalies
- Set up Mixpanel events: app_open, booking_started, payment_success
- Create Mixpanel funnel: Provider View to Book to Pay to Confirm
Deliverables:
- Sentry alerts configured
- Mixpanel funnels active
- Production monitoring live

Day 69: App Store Optimization & Marketing
Tasks:
- Research top search keywords for mental health apps
- Optimize App Store title and subtitle with target keywords
- Set up Apple Search Ads campaign
- Set up Google UAC campaign for Android installs
- Announce launch on LinkedIn, Instagram, and health tech communities
Deliverables:
- Listings optimized
- Marketing campaigns active
- Launch announced

Day 70: Launch Day Monitoring
Tasks:
- Monitor Sentry dashboard for any crash reports from production users
- Watch for new reviews on App Store and Google Play Console
- Monitor booking conversion rates in Mixpanel funnels
- Triage and prepare hotfixes if any P0 crashes occur
Deliverables:
- Launch stable
- Sentry monitored
- Conversion rates tracked

Day 71: Post-Launch Data Analysis
Tasks:
- Analyze first 7 days: installs, DAU, booking conversion, drop-offs
- Query local Hive stats database to find popular provider categories
- Identify top 3 friction points in user experience funnels
- Survey first 50 active users for qualitative feedback
- Document findings in v1.1 planning documentation
Deliverables:
- User behavior report written
- Top friction points identified
- v1.1 planning doc started

Day 72: Retrospective & v1.1 Roadmap
Tasks:
- Full project retrospective with team (what went well, what to improve)
- Publish v1.1 public roadmap overview
- Set 90-day OKRs: target bookings, DAU, retention rates
- Start v1.1 backlog: telehealth group sessions, Apple Health integration
- Celebrate launch - 75 days complete!
Deliverables:
- Retrospective complete
- v1.1 roadmap published
- OKRs set for next quarter

Day 73: Post-Launch Buffer — Performance Tuning
Tasks:
- Monitor application frame rates and page rendering performance on older devices
- Analyze Sentry transaction metrics to find slow rendering states
- Verify Sentry/Mixpanel analytics webhook performance in production
Deliverables:
- Telemetry analyzed
- Performance tuning complete

Day 74: Post-Launch Buffer — Production Feedback
Tasks:
- Monitor customer support channels for login or booking layout complaints
- Draft and verify hotfixes for production styling bugs or local storage issues
- Update App Store and Google Play Console support resources and links
Deliverables:
- Initial user issues triaged
- Minor updates rolled out

Day 75: Buffer Day — Handoff & Backlog Grooming
Tasks:
- Conduct a final engineering retrospective and update code documentation in the repository
- Clean up development and staging local configuration settings
- Prioritize features in the backlog for the upcoming v1.1 version cycle
- Prepare system administration handover documentation for the client team
Deliverables:
- Engineering retro summary written
- Roadmap backlog prioritized
- Handover documentation ready


# Daily Deliverables Tracker
Check off each day as it is completed.

# Estimated Project Costs
Direct monetary costs required to publish, deploy, host, and maintain the Zenup Health mobile application.

# Risk Register

# Launch Checklist
### App Store (iOS)
[  ] App icon 1024x1024px — no alpha, no rounded corners (Apple adds them)
[  ] Screenshots for 6.7", 6.1", 5.5", 12.9" iPad
[  ] Age rating 17+ selected (health / medical content)
[  ] Privacy policy and terms of service URLs in App Store Connect
[  ] NSHealthShareUsageDescription in Info.plist if using HealthKit
[  ] Apple Sign-In implemented (required when any other OAuth is present)
[  ] TestFlight tested with 50+ users before production submission
### Google Play (Android)
[  ] Feature graphic 1024x500px
[  ] Screenshots for phone and 7" + 10" tablet
[  ] Content rating questionnaire complete (Health category)
[  ] Target SDK 34+ (Android 14 requirement)
[  ] App Bundle (AAB) uploaded — NOT APK
[  ] Data safety section filled (data collected, shared, encrypted)
[  ] Closed testing with 20+ testers before production
### Flutter App Hardening
[  ] ProGuard rules configured for Android release build
[  ] iOS bitcode disabled (deprecated — ensure Xcode setting correct)
[  ] Client API keys stored securely in native config or env files
[  ] Certificate pinning implemented for MediaSFU and Razorpay API calls
[  ] Biometric auth gate on sensitive screens
[  ] Sentry or Crashlytics configured for production crash tracking
[  ] App version and build number incremented (pubspec.yaml)
| Role | Member Name |
| --- | --- |
| Head of Engineering / PM | Samarth Mehta |
| App Developer | Arnav |
| App Developer | Tarun |
| App Developer | Yashwanth |
| Layer | Technology | Notes |
| --- | --- | --- |
| Frontend (App) | Flutter 3.x (Dart) | Single codebase — iOS & Android |
| Backend | Supabase (Auth + Postgres) | User login, session tokens & confirmed booking sync |
| State Mgmt | Riverpod 2.x + AsyncNotifier | Reactive, testable, mock-compatible state |
| Local Storage | Hive (Encrypted) | Encrypted offline cache & user preferences |
| Navigation | GoRouter | Declarative routing + deep links |
| Payments | Razorpay SDK (Client) | Client-side checkout integration sandbox |
| Video Call | MediaSFU SDK (Client) | Telehealth video & audio calling interface |
| Notifications | Local Notifications SDK | Scheduled check-in & app reminder alerts |
| Mocking Layer | Mock Repository Adapters | Simulated network latencies and operation buffers |
| Testing | Flutter Test + Patrol | Unit, widget, golden & integration E2E tests |
| Day | Ph | Deliverable Description | Done |
| --- | --- | --- | --- |
| 1 | 1 | Flutter project boots on emulator | [  ] |
| 2 | 1 | Local storage service initialized | [  ] |
| 3 | 1 | Hive adapters generated successfully | [  ] |
| 4 | 1 | Theme configuration complete | [  ] |
| 5 | 1 | All routes defined | [  ] |
| 6 | 1 | Supabase Auth login functional | [  ] |
| 7 | 1 | Supabase auth stream auto-navigating | [  ] |
| 8 | 1 | Splash + onboarding working | [  ] |
| 9 | 1 | Verified local environment with updated configuration | [  ] |
| 10 | 2 | Home screen loading cached user data | [  ] |
| 11 | 2 | Provider list loaded from local assets | [  ] |
| 12 | 2 | Provider details rendering correctly | [  ] |
| 13 | 2 | Booking state managed reactively | [  ] |
| 14 | 2 | Appointment saved to Supabase appointments table | [  ] |
| 15 | 2 | Appointments list updating in real time | [  ] |
| 16 | 2 | Razorpay SDK client integrated | [  ] |
| 17 | 2 | Insurance fields editable in profile | [  ] |
| 18 | 2 | Message history loading from Hive | [  ] |
| 19 | 2 | Local scheduler configured | [  ] |
| 20 | 2 | Razorpay sandbox flow verified | [  ] |
| 21 | 2 | Provider sync models initialized | [  ] |
| 22 | 2 | Booking concerns field functional | [  ] |
| 23 | 2 | Client-side booking locking logic operational | [  ] |
| 24 | 2 | Local refund/credit simulation active | [  ] |
| 25 | 2 | Stress testing completed | [  ] |
| 26 | 2 | Invoice PDF export functional | [  ] |
| 27 | 3 | Telehealth video call working on emulator | [  ] |
| 28 | 3 | Video UI tested on real devices | [  ] |
| 29 | 3 | Prescriptions list rendering | [  ] |
| 30 | 3 | Local health records explorer complete | [  ] |
| 31 | 3 | Favorites system registered in Hive | [  ] |
| 32 | 3 | Notifications center screen active | [  ] |
| 33 | 3 | Review form UI complete | [  ] |
| 34 | 3 | Timer check active | [  ] |
| 35 | 3 | Medication reminders working | [  ] |
| 36 | 3 | Diagnostics overlay functional | [  ] |
| 37 | 3 | Post-call prompt active | [  ] |
| 38 | 3 | Outbox queue active | [  ] |
| 39 | 3 | Referral code generated | [  ] |
| 40 | 3 | Accessibility audit complete | [  ] |
| 41 | 3 | Local database encrypted | [  ] |
| 42 | 3 | Integration tests passing | [  ] |
| 43 | 3 | Offline outbox verified | [  ] |
| 44 | 3 | Local cache statistics operational | [  ] |
| 45 | 3 | Offline flow simulations complete | [  ] |
| 46 | 4 | Hero transitions working | [  ] |
| 47 | 4 | Friendly error screens active | [  ] |
| 48 | 4 | 60fps on all screens | [  ] |
| 49 | 4 | Repository tests passing | [  ] |
| 50 | 4 | Widget tests complete | [  ] |
| 51 | 4 | 3 E2E test journeys passing | [  ] |
| 52 | 4 | TestFlight build live | [  ] |
| 53 | 4 | Assets optimized | [  ] |
| 54 | 4 | 50 external testers active | [  ] |
| 55 | 4 | PHI data scrubbing active | [  ] |
| 56 | 4 | Outbox sync queue verified | [  ] |
| 57 | 4 | Hive integrity check active | [  ] |
| 58 | 4 | All reported blocking exceptions resolved | [  ] |
| 59 | 4 | Security configuration verified | [  ] |
| 60 | 4 | Encryption verified | [  ] |
| 61 | 4 | All crashes fixed | [  ] |
| 62 | 4 | Release candidate tagged | [  ] |
| 63 | 5 | Screenshots ready | [  ] |
| 64 | 5 | IPA uploaded to App Store Connect | [  ] |
| 65 | 5 | AAB uploaded to Play Console | [  ] |
| 66 | 5 | Apple reviewer feedback handled | [  ] |
| 67 | 5 | Google pre-launch alerts resolved | [  ] |
| 68 | 5 | Sentry alerts configured | [  ] |
| 69 | 5 | Listings optimized | [  ] |
| 70 | 5 | Launch stable | [  ] |
| 71 | 5 | User behavior report written | [  ] |
| 72 | 5 | Retrospective complete | [  ] |
| 73 | 5 | Telemetry analyzed | [  ] |
| 74 | 5 | Initial user issues triaged | [  ] |
| 75 | 5 | Engineering retro summary written | [  ] |
| Item / Service | Billing Frequency | Estimated Cost | Purpose / Notes |
| --- | --- | --- | --- |
| Google Play Console | One-time | $25 USD | Required developer account for Android publishing. |
| Apple Developer Program | Annual | $99 USD / year | Required developer account for iOS publishing. |
| MediaSFU Meetings | Monthly (Usage) | $162 USD / month | Client video calling sessions usage (10% discount). |
| Razorpay Gateway | Transaction-based | 2.0% per transaction (+ GST) | Domestic payment processing fee for client transactions. |
| Sentry Error Tracker | Free Tier | $0 USD | Client-side crash and error tracking. |
| Risk | Level | Cause | Mitigation |
| --- | --- | --- | --- |
| Apple Review Rejection | High | Missing privacy declarations for health data | Add NSHealthShareUsageDescription, privacy policy URL, and data use disclosures before Day 43 |
| Local PHI Storage Security | High | Local patient data stored insecurely on device | Encrypt Hive database boxes using keys stored in keychain/keystore using secure storage |
| Razorpay SDK Timeout | Medium | Client-side payment gateway fails to connect or times out | Implement robust state retry mechanisms and check connectivity state dynamically |
| MediaSFU Room Expiry | Medium | Call drops if session credentials expire | Implement client-side token refresh and auto-reconnect flow in video controller |
| In-App Performance | Medium | High memory usage from video/charts leads to app crashes on older hardware | Profile memory with DevTools, dispose controllers, and paginate local list builders |