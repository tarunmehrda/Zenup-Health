from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer, Table,
                                 TableStyle, HRFlowable, PageBreak, KeepTogether)
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.platypus import Flowable
import os

W, H = A4
GREEN  = colors.HexColor('#1DB87E')
DARK   = colors.HexColor('#1A2E28')
MUTED  = colors.HexColor('#7A9E93')
LIGHT  = colors.HexColor('#E8F7F0')
WHITE  = colors.white
GRAY   = colors.HexColor('#F5F7F5')
BORDER = colors.HexColor('#D9EDE6')
WARN   = colors.HexColor('#F59E0B')
BLUE   = colors.HexColor('#3B82F6')
RED    = colors.HexColor('#EF4444')
SUPA   = colors.HexColor('#3ECF8E')   # Supabase brand green

# ── styles ──────────────────────────────────────────────────────────────────
def make_styles():
    return {
        'cover_title': ParagraphStyle('ct',  fontName='Helvetica-Bold', fontSize=34,
            textColor=WHITE,  leading=42, alignment=TA_CENTER),
        'cover_sub':   ParagraphStyle('cs',  fontName='Helvetica',      fontSize=13,
            textColor=colors.HexColor('#9FE1CB'), leading=19, alignment=TA_CENTER),
        'cover_tag':   ParagraphStyle('ctag',fontName='Helvetica-Bold', fontSize=10,
            textColor=WHITE,  leading=15, alignment=TA_CENTER, spaceAfter=4),
        'h1':  ParagraphStyle('h1', fontName='Helvetica-Bold', fontSize=22,
            textColor=DARK,  leading=28, spaceBefore=16, spaceAfter=5),
        'h2':  ParagraphStyle('h2', fontName='Helvetica-Bold', fontSize=15,
            textColor=DARK,  leading=21, spaceBefore=12, spaceAfter=4),
        'h3':  ParagraphStyle('h3', fontName='Helvetica-Bold', fontSize=12,
            textColor=GREEN, leading=17, spaceBefore=9,  spaceAfter=3),
        'body':ParagraphStyle('body',fontName='Helvetica',     fontSize=10,
            textColor=colors.HexColor('#374151'), leading=16, spaceAfter=4),
        'body_bold':ParagraphStyle('bb',fontName='Helvetica-Bold',fontSize=10,
            textColor=DARK,  leading=16, spaceAfter=3),
        'bullet':ParagraphStyle('bul',fontName='Helvetica',    fontSize=10,
            textColor=colors.HexColor('#374151'), leading=16,
            leftIndent=14, firstLineIndent=-10, spaceAfter=3),
        'small':ParagraphStyle('sm', fontName='Helvetica',     fontSize=9,
            textColor=MUTED, leading=14),
        'toc_item':ParagraphStyle('toc', fontName='Helvetica', fontSize=11,
            textColor=DARK,  leading=22),
        'toc_page':ParagraphStyle('tocp',fontName='Helvetica-Bold',fontSize=11,
            textColor=GREEN, leading=22, alignment=TA_RIGHT),
        'kpi':      ParagraphStyle('kpi', fontName='Helvetica-Bold',fontSize=20,
            textColor=GREEN, leading=24, alignment=TA_CENTER),
        'kpi_label':ParagraphStyle('kpil',fontName='Helvetica',      fontSize=9,
            textColor=MUTED, leading=13, alignment=TA_CENTER),
        'supa_head':ParagraphStyle('sh', fontName='Helvetica-Bold',fontSize=11,
            textColor=WHITE, leading=15, alignment=TA_CENTER),
    }

# ── helpers ──────────────────────────────────────────────────────────────────
def hr(story): story.append(HRFlowable(width='100%', thickness=1.5, color=LIGHT))
def sp(story, n=3): story.append(Spacer(1, n*mm))

def day_block(story, styles, day_range, title, tasks, deliverables, tag_color=GREEN):
    class Badge(Flowable):
        def __init__(self, txt, col):
            super().__init__(); self.width=16*mm; self.height=16*mm
            self._t=txt; self._c=col
        def draw(self):
            c=self.canv; c.setFillColor(self._c)
            c.roundRect(0,0,self.width,self.height,4,fill=1,stroke=0)
            c.setFillColor(WHITE); c.setFont('Helvetica-Bold',8)
            c.drawCentredString(self.width/2, self.height/2-3, self._t)

    hdr = Table([[Badge(day_range,tag_color),
                  Paragraph(f"<b>{title}</b>", styles['body_bold'])]],
                colWidths=[18*mm,130*mm])
    hdr.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'MIDDLE'),
                              ('LEFTPADDING',(0,0),(-1,-1),0),
                              ('TOPPADDING',(0,0),(-1,-1),0),
                              ('BOTTOMPADDING',(0,0),(-1,-1),0)]))
    t_txt = "".join(f"• {t}<br/>" for t in tasks)
    d_txt = "".join(f"✓ {d}<br/>" for d in deliverables)
    blk = Table([[hdr,''],
                 [Paragraph("<b>Tasks:</b>",   styles['small']),
                  Paragraph("<b>Deliverables:</b>", styles['small'])],
                 [Paragraph(t_txt, styles['bullet']),
                  Paragraph(d_txt, styles['bullet'])]],
                colWidths=[78*mm,70*mm])
    blk.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),GRAY),
        ('LINEBELOW',(0,0),(-1,0),1,BORDER),
        ('SPAN',(0,0),(1,0)),
        ('TOPPADDING',(0,0),(-1,-1),5),
        ('BOTTOMPADDING',(0,0),(-1,-1),5),
        ('LEFTPADDING',(0,0),(-1,-1),6),
        ('RIGHTPADDING',(0,0),(-1,-1),6),
        ('VALIGN',(0,0),(-1,-1),'TOP'),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ]))
    story.append(KeepTogether([blk, Spacer(1,3*mm)]))

def phase_banner(story, styles, num, title, sub, days, col=GREEN):
    class Banner(Flowable):
        def __init__(self,w,num,title,sub,days,col):
            super().__init__(); self.width=w; self.height=26*mm
            self._n=num; self._t=title; self._s=sub; self._d=days; self._c=col
        def draw(self):
            c=self.canv; c.setFillColor(self._c)
            c.roundRect(0,0,self.width,self.height,8,fill=1,stroke=0)
            c.setFillColor(WHITE); c.setFont('Helvetica-Bold',8)
            c.drawString(6*mm,self.height-7*mm,f'PHASE {self._n}')
            c.setFont('Helvetica-Bold',17)
            c.drawString(6*mm,self.height-17*mm,self._t)
            c.setFont('Helvetica',10)
            c.setFillColor(colors.HexColor('#9FE1CB'))
            c.drawString(6*mm,5*mm,self._s)
            c.setFillColor(WHITE); c.setFont('Helvetica-Bold',11)
            c.drawRightString(self.width-6*mm,self.height-9*mm,self._d)
    story.append(Banner(150*mm,num,title,sub,days,col))
    sp(story,4)

# ── COVER ────────────────────────────────────────────────────────────────────
def add_cover(story, styles):
    # Spacers to position text on the background template
    sp(story, 15)
    story.append(Paragraph("ZenUp Health", styles['cover_tag']))
    sp(story, 5)
    story.append(Paragraph("50-Day Flutter App<br/>Development Plan", styles['cover_title']))
    sp(story, 8)
    story.append(Paragraph("Supabase Backend · Flutter 3.x · iOS & Android", styles['cover_sub']))
    sp(story, 15)
    kd = [[Paragraph("50",     styles['kpi']),  Paragraph("5",  styles['kpi']),
           Paragraph("1",      styles['kpi']),  Paragraph("100%",styles['kpi'])],
          [Paragraph("Days",   styles['kpi_label']),Paragraph("Phases",styles['kpi_label']),
           Paragraph("Codebase",styles['kpi_label']),Paragraph("Supabase",styles['kpi_label'])]]
    kt = Table(kd, colWidths=[35*mm]*4)
    kt.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),colors.HexColor('#0F6E56')),
        ('TOPPADDING',(0,0),(-1,0),8),('BOTTOMPADDING',(0,-1),(-1,-1),8),
        ('LEFTPADDING',(0,0),(-1,-1),4),('RIGHTPADDING',(0,0),(-1,-1),4),
    ]))
    story.append(kt)
    sp(story, 15)
    story.append(Paragraph("Psychiatry · Therapy · Wellness Booking", styles['cover_sub']))
    sp(story, 10)
    story.append(Paragraph("Built for zenuphealth.com<br/><font color='#A8C3BC'>Project Manager: Samarth Mehta &nbsp;&nbsp;&nbsp;&nbsp; Developers: Arnav, Tarun</font>", styles['small']))
    story.append(PageBreak())

# ── TOC ──────────────────────────────────────────────────────────────────────
def add_toc(story, styles):
    story.append(Paragraph("Table of Contents", styles['h1'])); hr(story); sp(story,4)
    items = [
        ("Project Overview & Supabase Architecture","3"),
        ("Phase 1 — Days 1–8: Foundation & Setup",  "4"),
        ("Phase 2 — Days 9–18: Core Features",      "6"),
        ("Phase 3 — Days 19–30: Advanced Features", "9"),
        ("Phase 4 — Days 31–42: Polish & Testing",  "12"),
        ("Phase 5 — Days 43–50: Launch & Deploy",   "15"),
        ("Daily Deliverables Tracker",              "17"),
        ("Estimated Project Costs",                 "18"),
        ("Risk Register & Launch Checklist",        "19"),
    ]
    for item, pg in items:
        row = Table([[Paragraph(item,styles['toc_item']),
                       Paragraph(pg,  styles['toc_page'])]],
                    colWidths=[130*mm,20*mm])
        row.setStyle(TableStyle([
            ('LINEBELOW',(0,0),(-1,-1),0.5,BORDER),
            ('TOPPADDING',(0,0),(-1,-1),5),('BOTTOMPADDING',(0,0),(-1,-1),5),
            ('LEFTPADDING',(0,0),(0,0),0),
        ]))
        story.append(row)
    story.append(PageBreak())

# ── OVERVIEW ──────────────────────────────────────────────────────────────────
def overview(story, styles):
    story.append(Paragraph("Project Overview", styles['h1'])); hr(story); sp(story,4)
    story.append(Paragraph(
        "ZenUp Health is a mental health and wellness platform offering psychiatry, therapy, "
        "and counseling booking at zenuphealth.com. This Flutter app uses <b>Supabase as the "
        "sole backend</b> — replacing Firebase entirely — for authentication, PostgreSQL database, "
        "realtime subscriptions, file storage, and database triggers.",
        styles['body']))
    story.append(Paragraph("Project Team & Personnel", styles['h3']))
    team_data = [
        ["Role", "Member Name"],
        ["Head of Engineering / PM", "Samarth Mehta"],
        ["App Developer", "Arnav"],
        ["App Developer", "Tarun"],
    ]
    tt = Table(team_data, colWidths=[90*mm, 60*mm])
    tt.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),DARK),
        ('TEXTCOLOR',(0,0),(-1,0),WHITE),
        ('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),
        ('FONTSIZE',(0,0),(-1,-1),9),
        ('FONTNAME',(0,1),(-1,-1),'Helvetica'),
        ('ROWBACKGROUNDS',(0,1),(-1,-1),[WHITE,GRAY]),
        ('GRID',(0,0),(-1,-1),0.3,BORDER),
        ('TOPPADDING',(0,0),(-1,-1),4),('BOTTOMPADDING',(0,0),(-1,-1),4),
        ('LEFTPADDING',(0,0),(-1,-1),6),('VALIGN',(0,0),(-1,-1),'MIDDLE'),
    ]))
    story.append(tt)
    sp(story, 3)

    story.append(Paragraph("Why Supabase?", styles['h3']))
    why = [
        "Single backend: Auth + PostgreSQL DB + Realtime + Storage + Database APIs",
        "Row Level Security (RLS) for HIPAA-aware data access control",
        "Open source and self-hostable if needed for compliance",
        "supabase_flutter SDK — first-class Dart/Flutter support",
        "Built-in REST and GraphQL APIs auto-generated from your schema",
        "Free tier generous enough for development; predictable pricing for production",
    ]
    for w in why: story.append(Paragraph(f"• {w}", styles['bullet']))
    sp(story,3)

    story.append(Paragraph("Complete Tech Stack", styles['h3']))
    cell_style = ParagraphStyle('tech_cell', parent=styles['small'], fontSize=8.5, leading=12, textColor=colors.HexColor('#374151'))
    cell_bold = ParagraphStyle('tech_cell_bold', parent=styles['body_bold'], fontSize=8.5, leading=12, textColor=DARK)
    cell_header = ParagraphStyle('tech_header', fontName='Helvetica-Bold', fontSize=9, leading=13, textColor=WHITE)
    
    rows = [[
        Paragraph("Layer", cell_header),
        Paragraph("Technology", cell_header),
        Paragraph("Notes", cell_header)
    ]]
    
    tech_raw = [
        ['Frontend (App)','Flutter 3.x (Dart)',       'Single codebase — iOS & Android'],
        ['Admin Portal',  'React + Tailwind CSS',     'Web dashboard for providers & admins'],
        ['Backend Server','Node.js (Express)',        'Custom API orchestrator & cron jobs'],
        ['State Mgmt',    'Riverpod 2.x + AsyncNotifier','Reactive, testable state'],
        ['Backend / Auth','Supabase Auth',            'Email, Google, Apple OAuth'],
        ['Database',      'Supabase PostgreSQL',      'Relational, RLS enforced'],
        ['Realtime',      'Supabase Realtime',        'Live appointment & chat updates'],
        ['File Storage',  'Supabase Storage',         'Avatars, documents, prescriptions'],
        ['Database APIs', 'Supabase Database APIs',    'Direct client database queries'],
        ['Payments',      'Razorpay SDK + Supabase API','Card billing & insurance'],
        ['Video',         'MediaSFU SDK',             'Telehealth video & audio SFU'],
        ['Local Storage', 'Hive',                     'Offline cache & preferences'],
        ['Push Notifs',   'Database Webhooks + APNs/FCM','Appointment reminders'],
        ['Navigation',    'GoRouter',                 'Declarative routing + deep links'],
        ['Testing',       'Flutter Test + Patrol',    'Unit, widget & E2E tests'],
        ['CI/CD',         'GitHub Actions + Fastlane','Automated build & deploy'],
    ]
    
    for row in tech_raw:
        rows.append([
            Paragraph(row[0], cell_bold),
            Paragraph(row[1], cell_style),
            Paragraph(row[2], cell_style)
        ])
        
    t = Table(rows, colWidths=[35*mm,52*mm,60*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),DARK),
        ('GRID',(0,0),(-1,-1),0.3,BORDER),
        ('TOPPADDING',(0,0),(-1,-1),5),
        ('BOTTOMPADDING',(0,0),(-1,-1),5),
        ('LEFTPADDING',(0,0),(-1,-1),6),
        ('RIGHTPADDING',(0,0),(-1,-1),6),
        ('VALIGN',(0,0),(-1,-1),'MIDDLE'),
    ]))
    story.append(t)
    story.append(PageBreak())


# ── PHASE 1 ───────────────────────────────────────────────────────────────────
def phase1(story, styles):
    phase_banner(story,styles,"1","Foundation & Setup",
        "Flutter project, Supabase connection, auth & design system","Days 1–8",DARK)

    day_block(story,styles,"Day 1","Project Init & Folder Architecture",
        ["Create Flutter project using standard naming and organization settings",
         "Establish clean architecture directory structure (features, core, shared, supabase)",
         "Initialize Git repository and configure Git ignore files for sensitive environments",
         "Add package dependencies including state management and Supabase integrations",
         "Configure Android and iOS project settings for minimum SDK versions"],
        ["Flutter project boots on emulator","Git repository initialized","Dependencies configuration complete"])

    day_block(story,styles,"Day 2","Supabase Project Setup",
        ["Verify active Supabase project on the web dashboard",
         "Configure application environment file with project credentials",
         "Initialize the Supabase SDK client in the main application entry point",
         "Create a dedicated database service class wrapper",
         "Perform test query to verify connection to the remote database"],
        ["Supabase client connected","Database service class created","Connection test passing"])

    day_block(story,styles,"Day 3","Run Full SQL Schema in Supabase",
        ["Access the Supabase web dashboard SQL editor console",
         "Execute the database table schema creation statements",
         "Enable Row Level Security (RLS) on all database tables",
         "Configure HIPAA-compliant data access policies for each table",
         "Create indexes on key columns to optimize search performance"],
        ["All tables created in Supabase database","Row Level Security policies active","Database indexes created"])

    day_block(story,styles,"Day 4","Design System & Theme",
        ["Define color, typography, and spacing constants in theme config",
         "Configure Material theme with selected typography and styling guidelines",
         "Build reusable custom UI components: buttons, cards, inputs, badges, and avatars",
         "Set up application asset directories for assets and icons",
         "Add branding icons and image assets to project folders"],
        ["Theme configuration complete","Reusable UI widgets built","Fonts rendering correctly"])

    day_block(story,styles,"Day 5","Navigation Configuration",
        ["Set up declarative routing using GoRouter package",
         "Define application routing paths (splash, login, home, profile, booking)",
         "Implement navigation guard based on user authentication state",
         "Create bottom navigation bar layout linking main tabs",
         "Configure deep linking pathways for application redirection"],
        ["All routes defined","Auth guard redirecting correctly","Bottom nav working"])

    day_block(story,styles,"Day 6","Supabase Auth — Email & Social",
        ["Build login user interface with validation forms",
         "Implement email and password sign-in request method",
         "Build sign-up interface and trigger user registration",
         "Configure Google OAuth sign-in flow for seamless login",
         "Integrate native Apple Sign-In flow for iOS platforms"],
        ["Email credentials login functional","Google OAuth sign-in working","Apple Sign-In working on iOS"])

    day_block(story,styles,"Day 7","Auth State & Profile Setup",
        ["Listen to authentication state changes using state notifier",
         "Auto-route user based on authentication status",
         "Build first-time user profile configuration form",
         "Insert user profile data during registration completion",
         "Upload user avatar image to secure cloud storage bucket"],
        ["Auth stream auto-navigating","Profile setup screen functional","Avatar upload to Storage"])

    day_block(story,styles,"Day 8","Splash, Onboarding & Phase 1 Tests",
        ["Build animated splash screen with entrance animations",
         "Create multi-slide onboarding flow with local state storage",
         "Write unit tests for authentication notifier and database service",
         "Fix Phase 1 visual bugs and layout adjustments",
         "Document environment settings and database structure in README"],
        ["Splash + onboarding working","Unit tests passing","README updated with Supabase setup"])
    story.append(PageBreak())

# ── PHASE 2 ───────────────────────────────────────────────────────────────────
def phase2(story, styles):
    phase_banner(story,styles,"2","Core Features",
        "Provider discovery, booking flow, payments & appointments","Days 9–18",GREEN)

    day_block(story,styles,"Day 9","Home Dashboard",
        ["Build Home screen with user greeting loading profile data",
         "Create upcoming appointments widget querying patient bookings",
         "Add quick-action pathways for booking, messages, and prescriptions",
         "Create featured providers listing sorted by highest ratings",
         "Add daily wellness tip widget using dynamic local sources"],
        ["Home screen loading real user data","Appointments widget showing","Featured providers list complete"])

    day_block(story,styles,"Day 10","Provider Discovery & Search",
        ["Create provider directory listing filtering by specialty",
         "Implement search functionality over provider names and bios",
         "Design filter selection chips for medical categories",
         "Design provider details card using profile and image resources",
         "Implement sorting options by rating and availability slots"],
        ["Provider list database query complete","Search and filtering functional","Sorting options active"])

    day_block(story,styles,"Day 11","Provider Profile Screen",
        ["Fetch detailed provider profile data with corresponding reviews",
         "Display bio details, credentials, ratings, and feedback counts",
         "Create availability calendar displaying open booking slots",
         "Render reviews list ordered by submission date",
         "Add booking action button redirecting to scheduling flow"],
        ["Provider profile displaying database content","Availability slots loaded","Reviews feed functional"])

    day_block(story,styles,"Day 12","Booking Flow Steps 1 & 2",
        ["Implement multi-step booking state notifier using Riverpod",
         "Step 1: Select preferred appointment medium (video, in-person, audio)",
         "Step 2: Display date picker and fetch corresponding open slots",
         "Create interactive time-slot grid disabling filled appointments",
         "Store selected slot reference in scheduling state"],
        ["Booking state managed reactive","Date and slot selection complete","Occupied slots disabled"])

    day_block(story,styles,"Day 13","Booking Flow Steps 3 & 4 — Confirm",
        ["Step 3: Collect insurance information and pre-fill from user profile",
         "Step 4: Display booking summary review screen",
         "On confirm: Insert new appointment entry into database",
         "Mark the selected slot as booked in the database records",
         "Send email booking confirmation via serverless email trigger"],
        ["Appointment record inserted","Availability slot marked booked","Email confirmation triggered"])

    day_block(story,styles,"Day 14","Appointments Management Screen",
        ["Create appointments interface with tabs for upcoming, past, and cancelled",
         "Connect dashboard with realtime database listener for live status updates",
         "Implement reschedule option updating booking slot and status",
         "Implement cancel option updating booking status",
         "Add cancellation policy modal warning users before confirmation"],
        ["Appointments list updating in real time","Reschedule request processing","Cancellation flow active"])

    day_block(story,styles,"Day 15","Razorpay Payments via Supabase API",
        ["Configure database or API endpoints to handle Razorpay payment flows",
         "Generate payment order identifier from the payment provider",
         "Trigger payment checkout request via Supabase API call from Flutter",
         "Build payment checkout screen with secure Razorpay integration",
         "Update appointment record in database with payment transaction details"],
        ["Supabase API payment endpoints configured","Razorpay integration functional","Payment status saved in database"])

    day_block(story,styles,"Day 16","Insurance & Billing Screen",
        ["Manage member insurance detail fields within user profile",
         "Retrieve paid appointments list to render billing history",
         "Generate invoice documents on the server and store in cloud storage",
         "Generate secure signed URLs for downloading invoice attachments",
         "Add insurance information edit form with form validation rules"],
        ["Insurance fields editable in profile","Billing history populated","Secure invoice download links active"])

    day_block(story,styles,"Day 17","Realtime Messaging",
        ["Query historical message records between patient and provider",
         "Set up realtime messaging channel to listen for new incoming messages",
         "Implement send message operation to insert new messages to database",
         "Add read receipt operation to mark received messages as read",
         "Configure typing indicators using presence subscription channel"],
        ["Realtime message thread loading","Message sending operational","Read indicators active"])

    day_block(story,styles,"Day 18","Push Notifications via Database Webhooks",
        ["Store user device notification token in database profile table",
         "Configure push services third-party API integration",
         "Trigger push notification payload using database webhook on booking event",
         "Configure database triggers to watch appointment creations",
         "Set up deep links to open corresponding screens when tapping notification"],
        ["Device token registered","Automated notifications working","Deep links configured"])
    story.append(PageBreak())

# ── PHASE 3 ───────────────────────────────────────────────────────────────────
def phase3(story, styles):
    phase_banner(story,styles,"3","Advanced Features",
        "Telehealth, prescriptions, wellness tracker & offline","Days 19–30",
        colors.HexColor('#7F77DD'))
    P = colors.HexColor('#7F77DD')

    day_block(story,styles,"Day 19","Telehealth Video (MediaSFU Integration)",
        ["Add video consultation SDK module to the application dependencies",
         "Configure video calling client connection details for audio and video rooms",
         "Build telehealth call screen displaying remote and local camera streams",
         "Add interface controllers for camera toggling, mic mute, and screen sharing",
         "Store session credentials securely within appointment notes"],
        ["Telehealth video call working on emulator","Connected to media room","Telehealth layout complete"],P)

    day_block(story,styles,"Day 20","Telehealth — Device Testing & Polish",
        ["Test remote video consultation on physical iOS and Android hardware",
         "Add network connection quality indicators to calling screen",
         "Build and insert post-consultation feedback surveys into database",
         "Manage application backgrounding states during live calls",
         "Integrate interactive chat panel overlay into the active video session"],
        ["Video tested on real devices","Post-session survey inserting to DB","In-call chat working"],P)

    day_block(story,styles,"Day 21","Prescription Tracking",
        ["Create prescriptions screen showing active user prescriptions",
         "Display detail card for medication names, dosages, schedules, and providers",
         "Implement refill request action sending request notifications to providers",
         "Configure local system notifications to remind users to take medication",
         "Build listing filter displaying archived or inactive prescriptions"],
        ["Prescriptions loading from database","Refill request working","Local medication reminders"],P)

    day_block(story,styles,"Day 22","Health Records & Document Storage",
        ["Build personal health records document explorer interface",
         "Upload medical documents securely to user cloud storage folders",
         "Retrieve listing of files registered under the user's folder",
         "Generate secure expiring download links for previewing documents",
         "Define file tags such as lab results, referrals, and scans in document metadata"],
        ["Document upload to secure storage","List and view documents","Signed URL download"],P)

    day_block(story,styles,"Day 23","Wellness Tracker",
        ["Build check-in form saving mood, sleep, stress, and energy ratings",
         "Create calendar query loading weekly wellness logs",
         "Build interactive mood and sleep trend line charts",
         "Implement tracker calculation showing consecutive check-in streaks",
         "Generate wellness summaries calculating average mood scores in the application"],
        ["Check-in inserting to database","7-day chart rendering","Streak counter working"],P)

    day_block(story,styles,"Day 24","Notifications Center & Settings",
        ["Build list showing local notifications and system alerts",
         "Create account settings screen allowing users to edit profile and reset password",
         "Configure notification preference switches and save choices in profile",
         "Integrate option for analytics collection opt-out in settings",
         "Add account deletion utility triggering secure administrative cleanup"],
        ["Notifications center screen","Settings updating profiles in database","Delete account flow"],P)

    day_block(story,styles,"Day 25","Reviews & Ratings",
        ["Build rating feedback form linking patient, provider, and appointment",
         "Configure validation to only allow feedback for completed appointments",
         "Recalculate average provider rating when new feedback is submitted",
         "Deploy database trigger function to automate rating updates",
         "Display updated review feed on the provider details screen"],
        ["Review form posting to database","Provider rating auto-updating via trigger","Reviews visible on profile"],P)

    day_block(story,styles,"Day 26","Offline Support & Caching",
        ["Integrate secure local storage framework into application",
         "Cache essential data offline including user profile and upcoming bookings",
         "Display connectivity status banner when application is offline",
         "Implement synchronization rules to refresh local cache on reconnect",
         "Ensure local data caches are deleted upon user logout"],
        ["Offline mode showing cached data","Connectivity banner working","Cache clears on logout"],P)

    day_block(story,styles,"Day 27","Referral System",
        ["Add referral code fields to the database user profiles",
         "Generate unique short alphanumeric code for each user on sign-up",
         "Enable referral code sharing via native sharing utility",
         "Apply registration attribution logic to credit referred users",
         "Create rewards display showing total counts of successful referrals"],
        ["Referral code generated on signup","Share sheet working","Referral count displaying"],P)

    day_block(story,styles,"Day 28","Accessibility & Localization",
        ["Audit application layout against accessibility standard checklists",
         "Add semantic labels and accessibility tags to all interactive components",
         "Configure localization libraries for multi-language display support",
         "Create translated text resource files for supported languages",
         "Test application interface using system screen reader tools"],
        ["Accessibility audit complete","Screen reader working","Spanish translations added"],P)

    day_block(story,styles,"Day 29","Security Hardening",
        ["Audit database to verify all tables require credentialed access",
         "Apply cloud storage rules limiting file access to authorized owners",
         "Implement local biometric authentication check options",
         "Encrypt local data storage directories containing user information",
         "Add secure SSL pin configuration for application network calls"],
        ["Access controls verified on all tables","Storage bucket policies set","Biometric auth working"],P)

    day_block(story,styles,"Day 30","Phase 3 Integration Test & Demo",
        ["Run full client scenario flow testing all advanced features",
         "Profile memory performance and resolve any identified leaks",
         "Review database query execution logs and optimize slow queries",
         "Add database indexes for properties with frequent queries",
         "Conduct system walkthrough demo highlighting completed functionality"],
        ["Integration tests passing","No memory leaks","Demo video recorded"],P)
    story.append(PageBreak())

# ── PHASE 4 ───────────────────────────────────────────────────────────────────
def phase4(story, styles):
    phase_banner(story,styles,"4","Polish & Testing",
        "Animations, QA, unit/widget/E2E tests, beta","Days 31–42",WARN)

    d4 = [
        ("Day 31","UI Animation Polish",
         ["Hero transitions between provider list → provider profile",
          "Shimmer loading (shimmer package) on all list screens while fetching from Supabase",
          "Lottie animations for empty states (no appointments, no messages)",
          "Micro-interactions: button press haptic, card tap scale",
          "Smooth PageView transitions in onboarding"],
         ["Hero transitions","Shimmer on all loaders","Lottie empty states"]),
        ("Day 32","Error Handling & Empty States",
         ["Wrap all Supabase calls in try/catch with PostgrestException handling",
          "Show user-friendly error messages (no raw Supabase error codes shown)",
          "Empty state screens for: no appointments, no messages, no prescriptions",
          "Full-screen error widget with retry button that re-calls Supabase",
          "Network lost banner via connectivity_plus"],
         ["Friendly error messages","Empty states on all screens","Retry on error working"]),
        ("Day 33","Performance Optimization",
         ["Profile all screens with Flutter DevTools — target 60fps",
          "Add const constructors everywhere possible",
          "Optimize Supabase queries: add .limit() and .range() for pagination",
          "Lazy load images with cached_network_image (cache Supabase Storage URLs)",
          "Reduce Supabase select fields: never use SELECT * in production"],
         ["60fps on all screens","Supabase queries paginated","Images cached locally"]),
        ("Day 34","Unit Testing — Supabase Repositories",
         ["Mock Supabase client using mocktail package",
          "Test AppointmentRepository: fetch, insert, update, cancel",
          "Test AuthNotifier: sign in, sign up, sign out state transitions",
          "Test ProfileRepository: fetch profile, update profile",
          "Test BookingNotifier state machine (step 1→2→3→4→confirm)"],
         ["All repository tests passing","AuthNotifier tests passing","80%+ coverage on business logic"]),
        ("Day 35","Widget Testing",
         ["Widget tests for all custom widgets (ZButton, ZCard, ZInput)",
          "Test booking flow screens with mocked Riverpod providers",
          "Test login form validation (empty, invalid email, short password)",
          "Golden tests for pixel-perfect UI consistency",
          "Test provider card rendering with mock data"],
         ["Widget tests complete","Golden tests passing","Login form validation tested"]),
        ("Day 36","E2E Testing with Patrol",
         ["Write Patrol E2E test: signup → complete profile → book appointment → pay",
          "E2E test: login → view appointments → cancel appointment",
          "E2E test: search provider → view profile → check availability",
          "Run E2E on real iOS and Android devices",
          "Add Patrol tests to GitHub Actions CI workflow"],
         ["3 E2E test journeys passing","Tests on real devices","CI running Patrol tests"]),
        ("Day 37","Internal Beta via TestFlight & Play Console",
         ["Build release IPA and AAB",
          "Upload to TestFlight (iOS) — invite internal team (10 testers)",
          "Upload to Play Console Internal Testing track",
          "Configure Firebase Crashlytics for crash reporting (optional — or Sentry)",
          "Collect structured feedback via Google Form"],
         ["TestFlight build live","Play Console internal track live","Feedback form distributed"]),
        ("Day 38","Supabase Production Setup",
         ["Upgrade Supabase project to Pro plan (production)",
          "Enable Point-in-Time Recovery (PITR) for database backups",
          "Configure Supabase auth email templates (branded with ZenUp logo)",
          "Set up Supabase usage alerts (rows, storage, bandwidth)",
          "Review and lock all RLS policies for production security"],
         ["Supabase Pro plan active","PITR backups enabled","Auth email templates branded"]),
        ("Day 39","External Beta — 50 Users",
         ["Expand TestFlight to 50 external testers (health professionals, patients)",
          "Expand Play Console to Closed Testing with 50 users",
          "Monitor Supabase dashboard: queries per second, active connections",
          "Fix all P0/P1 bugs from beta feedback",
          "Test on minimum supported devices (iPhone 12, Android API 26)"],
         ["50 beta users testing","Supabase performance stable","P0/P1 bugs fixed"]),
        ("Day 40","Compliance & Privacy Review",
         ["Review all Supabase RLS policies with security checklist",
          "Ensure no PHI stored in client-side logs or crash reports",
          "Add in-app privacy policy and terms of service screens",
          "Implement data export: allow user to download their data via direct database API request",
          "Add data deletion flow (full GDPR right-to-erasure)"],
         ["RLS security checklist signed off","Privacy policy screen in app","Data export working"]),
        ("Day 41","Bug Fix Sprint",
         ["Triage all beta feedback (P0/P1/P2 categories)",
          "Fix all crash reports",
          "UI fixes for specific device sizes (small Android screens)",
          "Fix Supabase realtime reconnection after background",
          "Upload final beta build to both platforms"],
         ["All crashes fixed","UI bugs on small screens resolved","Final beta build up"]),
        ("Day 42","Release Candidate & Sign-Off",
         ["Full regression test of all 50-day features",
          "Tag release in Git: v1.0.0-rc1",
          "Stakeholder sign-off meeting",
          "Freeze feature scope — no new features until v1.1",
          "Prepare App Store and Play Store metadata, screenshots, descriptions"],
         ["Release candidate tagged","Stakeholder sign-off","Store metadata complete"]),
    ]
    for day,title,tasks,deliverables in d4:
        day_block(story,styles,day,title,tasks,deliverables,WARN)
    story.append(PageBreak())

# ── PHASE 5 ───────────────────────────────────────────────────────────────────
def phase5(story, styles):
    phase_banner(story,styles,"5","Launch & Deploy",
        "App Store, Play Store, monitoring & v1.1 kickoff","Days 43–50",RED)

    d5 = [
        ("Day 43","App Store Assets & Metadata",
         ["Design screenshots for all required sizes (6.7\", 6.1\", 5.5\", iPad)",
          "Write App Store description with health keywords",
          "Create 30-second app preview video",
          "Finalize 1024x1024px App Store icon (no alpha)",
          "Live privacy policy URL and terms of service URL"],
         ["All screenshot sizes ready","App Store copy finalized","Privacy policy URL live"]),
        ("Day 44","iOS App Store Submission",
         ["Configure Xcode signing (automatic signing with App Store distribution cert)",
          "flutter build ipa --release",
          "Upload with Fastlane: fastlane deliver",
          "Complete App Store Connect review information (privacy questions, encryption)",
          "Submit for Apple review (allow 1–3 days)"],
         ["IPA uploaded to App Store Connect","Review form complete","Submitted to Apple"]),
        ("Day 45","Google Play Submission",
         ["flutter build appbundle --release",
          "Sign with upload keystore (store in GitHub Secrets)",
          "Upload AAB to Play Console Production track",
          "Complete Play Store listing: description, screenshots, content rating",
          "Publish (will go live after review — usually same day)"],
         ["AAB uploaded and reviewed","Play Store listing complete","App live on Play Store"]),
        ("Day 46","Monitoring & Analytics Setup",
         ["Enable Supabase dashboard monitoring (queries, connections, latency)",
          "Set up Sentry for Flutter crash reporting (sentry_flutter package)",
          "Configure Sentry alerts for new crash types",
          "Set up Mixpanel events: app_open, booking_started, booking_completed, payment_success",
          "Create Mixpanel funnel: Provider View → Book → Pay → Confirm"],
         ["Sentry crash alerts configured","Mixpanel funnels set up","Supabase monitoring on"]),
        ("Day 47","App Store Optimization (ASO) & Marketing",
         ["Research top keywords: mental health app, psychiatry booking, therapy online",
          "Optimize App Store title and subtitle with keywords",
          "Set up Apple Search Ads campaign",
          "Set up Google UAC campaign for Android installs",
          "Announce launch on LinkedIn, Instagram, and health tech communities"],
         ["Keywords optimized in store listings","Search Ads campaigns live","Launch announcement posted"]),
        ("Day 48","Launch Day Monitoring",
         ["Monitor Supabase realtime connections and query load",
          "Watch Sentry for any new crash types from production users",
          "Respond to all Day 1 App Store and Play Store reviews",
          "Monitor booking conversion rate in Mixpanel funnel",
          "Hotfix deploy if any P0 issues arise"],
         ["Supabase stable under production load","All reviews responded to","No P0 crashes in prod"]),
        ("Day 49","Post-Launch Data Analysis",
         ["Analyze first 7 days: installs, DAU, booking conversion, drop-off points",
          "Run SQL in Supabase to find most-booked specialties and providers",
          "Identify top 3 friction points from Mixpanel funnel",
          "Survey first 50 users for qualitative feedback",
          "Document findings in v1.1 planning doc"],
         ["User behavior report written","Top 3 friction points identified","v1.1 planning doc started"]),
        ("Day 50","Retrospective & v1.1 Roadmap",
         ["Full project retrospective with team (what went well / what to improve)",
          "Publish v1.1 public roadmap",
          "Set 90-day OKRs: target bookings, DAU, retention",
          "Start v1.1 backlog: telehealth group sessions, family plans, Apple Health integration",
          "Celebrate launch — 50 days complete!"],
         ["Retrospective completed","v1.1 roadmap published","OKRs set for next quarter"]),
    ]
    for day,title,tasks,deliverables in d5:
        day_block(story,styles,day,title,tasks,deliverables,RED)
    story.append(PageBreak())

# ── TRACKER ───────────────────────────────────────────────────────────────────
def tracker(story, styles):
    story.append(Paragraph("Daily Deliverables Tracker", styles['h1'])); hr(story); sp(story,3)
    story.append(Paragraph("Print this page and check off each day as you complete it.",styles['body']))
    sp(story,3)
    hdr = ['Day','Phase','Key Deliverable','Done']
    rows = [hdr]
    data = [
        (1,"1","Flutter project boots on emulator"),
        (2,"1","Supabase client connected in Flutter"),
        (3,"1","All 8 tables + RLS active in Supabase"),
        (4,"1","Design system + widget library complete"),
        (5,"1","GoRouter + auth guard working"),
        (6,"1","Email + Google + Apple auth working"),
        (7,"1","Profile setup writing to Supabase"),
        (8,"1","Splash, onboarding, unit tests passing"),
        (9,"2","Home dashboard loading real Supabase data"),
        (10,"2","Provider search + filter from Supabase"),
        (11,"2","Provider profile with live reviews"),
        (12,"2","Booking steps 1 & 2 with slot selection"),
        (13,"2","Appointment inserted in Supabase DB"),
        (14,"2","Appointments screen with Realtime updates"),
        (15,"2","Razorpay payment via Supabase API"),
        (16,"2","Billing history + invoice download"),
        (17,"2","Realtime messaging working"),
        (18,"2","Push notifications via database webhooks"),
        (19,"3","MediaSFU video call on simulator"),
        (20,"3","Video tested on real devices"),
        (21,"3","Prescriptions + local reminders"),
        (22,"3","Health records in Supabase Storage"),
        (23,"3","Wellness check-in + chart"),
        (24,"3","Notifications center + settings"),
        (25,"3","Reviews + provider rating trigger"),
        (26,"3","Offline mode with Hive cache"),
        (27,"3","Referral code + share sheet"),
        (28,"3","Accessibility + Spanish translation"),
        (29,"3","RLS audit + biometric auth"),
        (30,"3","Integration tests passing"),
        (31,"4","Hero transitions + Lottie"),
        (32,"4","Error handling + empty states"),
        (33,"4","60fps + Supabase queries paginated"),
        (34,"4","Repository unit tests 80%+ coverage"),
        (35,"4","Widget + golden tests passing"),
        (36,"4","Patrol E2E tests on real devices"),
        (37,"4","Internal beta distributed"),
        (38,"4","Supabase Pro + PITR configured"),
        (39,"4","50-user external beta running"),
        (40,"4","Compliance & GDPR review done"),
        (41,"4","All crashes fixed"),
        (42,"4","Release candidate v1.0.0-rc1 tagged"),
        (43,"5","App Store assets ready"),
        (44,"5","Submitted to Apple review"),
        (45,"5","Live on Google Play"),
        (46,"5","Sentry + Mixpanel configured"),
        (47,"5","ASO keywords + Search Ads live"),
        (48,"5","Launch day stable — no P0 crashes"),
        (49,"5","Post-launch data analysis complete"),
        (50,"5","v1.1 roadmap published"),
    ]
    cell_style = ParagraphStyle('track_cell', parent=styles['small'], fontSize=8, leading=11, textColor=colors.HexColor('#1f2937'))
    cell_bold = ParagraphStyle('track_bold', fontName='Helvetica-Bold', fontSize=8.5, leading=11, textColor=WHITE, alignment=TA_CENTER)
    cell_header = ParagraphStyle('track_header', fontName='Helvetica-Bold', fontSize=8.5, leading=12, textColor=WHITE, alignment=TA_CENTER)
    
    rows = [[
        Paragraph("Day", cell_header),
        Paragraph("Ph", cell_header),
        Paragraph("Deliverable Description", ParagraphStyle('track_h_l', parent=cell_header, alignment=TA_LEFT)),
        Paragraph("Status", cell_header)
    ]]
    
    pc = {"1":DARK,"2":GREEN,"3":colors.HexColor('#7F77DD'),"4":WARN,"5":RED}
    for d,p,dl in data:
        rows.append([
            Paragraph(str(d), cell_bold),
            Paragraph(p, cell_bold),
            Paragraph(dl, cell_style),
            Paragraph("[ ]", ParagraphStyle('track_s', parent=cell_style, alignment=TA_CENTER))
        ])
        
    cw = [12*mm, 12*mm, 110*mm, 12*mm]
    ts = TableStyle([
        ('BACKGROUND',(0,0),(-1,0),DARK),
        ('GRID',(0,0),(-1,-1),0.3,BORDER),
        ('TOPPADDING',(0,0),(-1,-1),3),
        ('BOTTOMPADDING',(0,0),(-1,-1),3),
        ('LEFTPADDING',(0,0),(-1,-1),4),
        ('RIGHTPADDING',(0,0),(-1,-1),4),
        ('VALIGN',(0,0),(-1,-1),'MIDDLE'),
    ])
    for i,(d,p,_) in enumerate(data,1):
        col=pc.get(p,DARK)
        ts.add('BACKGROUND',(0,i),(1,i),col)
    t=Table(rows,colWidths=cw,repeatRows=1); t.setStyle(ts)
    story.append(t)
    story.append(PageBreak())

# ── RISK + CHECKLIST ──────────────────────────────────────────────────────────
def risks_and_checklist(story, styles):
    story.append(Paragraph("Risk Register", styles['h1'])); hr(story); sp(story,3)
    risks=[
        ("Apple Review Rejection","High",
         "Missing privacy declarations for health data",
         "Add NSHealthShareUsageDescription, privacy policy URL, and data use disclosures before Day 43"),
        ("Supabase RLS Gap","High",
         "A misconfigured RLS policy exposes patient data",
         "Run RLS checker script on every table after Day 29; peer review all policies"),
        ("Razorpay API Timeout","Medium",
         "Network delay on direct payment API calls causes checkout timeout",
         "Use optimistic client-side UI states and configure connection timeout limits Day 34"),
        ("MediaSFU Room Expiry","Medium",
         "Video call drops if room session expires mid-consultation",
         "Configure long-lived room sessions; implement auto-reconnect client logic using mediasfu_sdk"),
        ("Supabase Storage Costs","Low",
         "Health records and avatars consume unexpected storage bandwidth",
         "Set max upload size in Storage policy (10MB); compress images before upload"),
        ("App Store Health App Category","Medium",
         "Apple may require additional medical app review or entitlements",
         "Submit under Health & Fitness category; prepare medical disclaimer copy by Day 43"),
        ("HIPAA / Data Compliance","High",
         "PHI stored without BAA or proper encryption",
         "Sign Supabase BAA (available on Pro plan); encrypt Hive boxes; no PHI in logs"),
    ]
    # Cell styles for Risk Register table wrapping
    cell_style = ParagraphStyle('rc_cell', parent=styles['small'], fontSize=8, leading=11, textColor=colors.HexColor('#1f2937'))
    cell_bold = ParagraphStyle('rc_cell_bold', parent=styles['body_bold'], fontSize=8.5, leading=11, textColor=DARK)
    cell_header = ParagraphStyle('rc_header', fontName='Helvetica-Bold', fontSize=8.5, leading=12, textColor=WHITE)
    cell_level = ParagraphStyle('rc_level', fontName='Helvetica-Bold', fontSize=8, leading=11, textColor=WHITE, alignment=TA_CENTER)
    
    # Process headers
    rows = [[
        Paragraph("Risk", cell_header),
        Paragraph("Level", ParagraphStyle('rc_h_c', parent=cell_header, alignment=TA_CENTER)),
        Paragraph("Cause", cell_header),
        Paragraph("Mitigation", cell_header)
    ]]
    
    # Process rows
    lc = {'High': RED, 'Medium': WARN, 'Low': GREEN}
    for r in risks:
        rows.append([
            Paragraph(r[0], cell_bold),
            Paragraph(r[1], cell_level),
            Paragraph(r[2], cell_style),
            Paragraph(r[3], cell_style)
        ])
        
    t = Table(rows, colWidths=[33*mm, 15*mm, 48*mm, 54*mm])
    ts = TableStyle([
        ('BACKGROUND', (0,0), (-1,0), DARK),
        ('GRID', (0,0), (-1,-1), 0.3, BORDER),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 6),
        ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ])
    for i, (_, level, _, _) in enumerate(risks, 1):
        c = lc.get(level, MUTED)
        ts.add('BACKGROUND', (1, i), (1, i), c)
    t.setStyle(ts)
    story.append(t)
    sp(story, 6)

    story.append(Paragraph("Launch Checklist", styles['h1'])); hr(story); sp(story,3)
    cl=[
        ("App Store (iOS)",[
            "App icon 1024x1024px — no alpha, no rounded corners (Apple adds them)",
            "Screenshots for 6.7\", 6.1\", 5.5\", 12.9\" iPad",
            "Age rating 17+ selected (health / medical content)",
            "Privacy policy and terms of service URLs in App Store Connect",
            "NSHealthShareUsageDescription in Info.plist if using HealthKit",
            "Apple Sign-In implemented (required when any other OAuth is present)",
            "TestFlight tested with 50+ users before production submission",
        ]),
        ("Google Play (Android)",[
            "Feature graphic 1024x500px",
            "Screenshots for phone and 7\" + 10\" tablet",
            "Content rating questionnaire complete (Health category)",
            "Target SDK 34+ (Android 14 requirement 2024+)",
            "App Bundle (AAB) uploaded — NOT APK",
            "Data safety section filled (data collected, shared, encrypted)",
            "Closed testing with 20+ testers before production",
        ]),
        ("Supabase Production",[
            "Project on Pro plan with PITR backups enabled",
            "Supabase BAA signed (HIPAA — available on Pro plan)",
            "All tables have RLS enabled — verify with RLS checker",
            "Storage bucket policies: users access only own files",
            "Database triggers and API endpoints verified in production",
            "Database connection pooling configured (PgBouncer on Supabase)",
            "Auth email templates branded with ZenUp logo and colours",
            "Usage alerts set: rows, storage, bandwidth, API requests",
        ]),
        ("Flutter App",[
            "ProGuard rules configured for Android release build",
            "iOS bitcode disabled (deprecated — ensure Xcode setting correct)",
            "All API keys in .env — NOT hardcoded in source",
            "Certificate pinning implemented for Supabase API calls",
            "Biometric auth gate on sensitive screens",
            "Sentry or Crashlytics configured for production crash tracking",
            "App version and build number incremented (pubspec.yaml)",
        ]),
    ]
    for section,items in cl:
        story.append(Paragraph(section, styles['h3']))
        for item in items:
            story.append(Paragraph(f"☐  {item}", styles['bullet']))
        sp(story,2)

# ── COSTING PAGE ─────────────────────────────────────────────────────────────
def costing_page(story, styles):
    story.append(Paragraph("Estimated Project Costs", styles['h1'])); hr(story); sp(story,4)
    story.append(Paragraph(
        "A detailed breakdown of the direct monetary costs required to publish, deploy, host, "
        "and maintain the ZenUp Health mobile application on both the Google Play Store and Apple App Store.",
        styles['body']))
    sp(story,4)

    # Cell styles for Costing table
    cell_style = ParagraphStyle('cost_cell', parent=styles['small'], fontSize=8.5, leading=12, textColor=colors.HexColor('#1f2937'))
    cell_bold = ParagraphStyle('cost_cell_bold', parent=styles['body_bold'], fontSize=8.5, leading=12, textColor=DARK)
    cell_header = ParagraphStyle('cost_header', fontName='Helvetica-Bold', fontSize=9, leading=13, textColor=WHITE)
    
    # Process headers
    rows = [[
        Paragraph("Item / Service", cell_header),
        Paragraph("Billing Frequency", cell_header),
        Paragraph("Estimated Cost", cell_header),
        Paragraph("Purpose / Notes", cell_header)
    ]]
    
    costs_raw = [
        ['Google Play Console', 'One-time', '$25 USD', 'Required developer account for Android publishing.'],
        ['Apple Developer Program', 'Annual', '$99 USD / year', 'Required developer account for iOS publishing.'],
        ['Supabase Pro Plan', 'Monthly', '$25 USD / month', 'Production database, Auth, & Storage (HIPAA-ready BAA available).'],
        ['MediaSFU Meetings', 'Monthly (Usage)', '$162 USD / month', '2-participant video sessions. ($180 base - 10% discount).'],
        ['MediaSFU Recording', 'Monthly (Usage)', '$180 USD / month', 'Audio-only recording. ($240 base - 25% discount for first 3 mos).'],
        ['Transcription Pipeline', 'Usage-based', 'No extra cost', 'Automated by MediaSFU (included in recording) or via external offline S3.'],
        ['Razorpay Gateway', 'Transaction-based', '2.0% per transaction (+ GST)', 'Domestic payment processing for patient bookings.'],
        ['Sentry Error Tracker', 'Free Tier', '$0 USD', 'Production crash and error tracking.'],
    ]
    
    for row in costs_raw:
        rows.append([
            Paragraph(row[0], cell_bold),
            Paragraph(row[1], cell_style),
            Paragraph(row[2], cell_style),
            Paragraph(row[3], cell_style)
        ])
        
    t = Table(rows, colWidths=[40*mm, 28*mm, 32*mm, 48*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),DARK),
        ('GRID',(0,0),(-1,-1),0.3,BORDER),
        ('TOPPADDING',(0,0),(-1,-1),5),
        ('BOTTOMPADDING',(0,0),(-1,-1),5),
        ('LEFTPADDING',(0,0),(-1,-1),6),
        ('RIGHTPADDING',(0,0),(-1,-1),6),
        ('VALIGN',(0,0),(-1,-1),'MIDDLE'),
    ]))
    story.append(t)
    story.append(PageBreak())

# ── BUILD ─────────────────────────────────────────────────────────────────────
def build():
    dir_path = os.path.dirname(os.path.abspath(__file__))
    base_name = "ZenUp_Health_50Day_Supabase_Flutter_Plan"
    path = os.path.join(dir_path, f"{base_name}.pdf")
    suffix = ""
    counter = 1
    while True:
        try:
            if os.path.exists(path):
                with open(path, 'ab') as f:
                    pass
            break
        except PermissionError:
            suffix = f"_new{counter}"
            path = os.path.join(dir_path, f"{base_name}{suffix}.pdf")
            counter += 1
    print("Saving PDF to:", path)
    doc=SimpleDocTemplate(path,pagesize=A4,
        leftMargin=20*mm,rightMargin=20*mm,topMargin=18*mm,bottomMargin=18*mm,
        title="ZenUp Health — 50-Day Supabase + Flutter App Plan",
        author="ZenUp Health")
    styles=make_styles()
    story=[]
    add_cover(story,styles)
    add_toc(story,styles)
    overview(story,styles)
    phase1(story,styles)
    phase2(story,styles)
    phase3(story,styles)
    phase4(story,styles)
    phase5(story,styles)
    tracker(story,styles)
    costing_page(story,styles)
    risks_and_checklist(story,styles)

    def draw_cover_bg(canvas, doc):
        canvas.saveState()
        canvas.setFillColor(DARK)
        canvas.roundRect(20*mm, 18*mm, W - 40*mm, H - 36*mm, 12, fill=1, stroke=0)
        
        canvas.setFillColor(SUPA)
        canvas.roundRect(20*mm, H - 26*mm, W - 40*mm, 8*mm, 0, fill=1, stroke=0)
        canvas.roundRect(20*mm, 18*mm, W - 40*mm, 8*mm, 0, fill=1, stroke=0)
        
        canvas.setFillColor(colors.HexColor('#0F6E56'))
        canvas.circle(W - 35*mm, H - 43*mm, 18*mm, fill=1, stroke=0)
        
        canvas.setFillColor(colors.HexColor('#085041'))
        canvas.circle(35*mm, 48*mm, 22*mm, fill=1, stroke=0)
        canvas.restoreState()

    def footer(canvas,doc):
        canvas.saveState()
        if doc.page>1:
            canvas.setFillColor(DARK); canvas.setFont('Helvetica-Bold',8)
            canvas.drawString(20*mm,10*mm,"ZenUp Health — 50-Day Supabase + Flutter Plan")
            canvas.setFillColor(SUPA)
            canvas.drawRightString(A4[0]-20*mm,10*mm,f"Page {doc.page}")
            canvas.setStrokeColor(LIGHT); canvas.setLineWidth(0.5)
            canvas.line(20*mm,13*mm,A4[0]-20*mm,13*mm)
        canvas.restoreState()

    doc.build(story,onFirstPage=draw_cover_bg,onLaterPages=footer)
    print("Done:",path)

if __name__ == '__main__':
    build()
