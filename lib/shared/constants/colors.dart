import 'package:flutter/material.dart';

// ==========================================
// Base & Existing Colors
// ==========================================
const kWhite = Color(0xFFFFFFFF);
const kBlack = Color(0xFF151616);
const kRedColor = Color(0XFFAE270F);
const kGreenColor = Color(0xFF5BDB7F);

// ==========================================
// Primary Brand Colors (Indigo)
// ==========================================
const kPrimaryColor = Color(0xFF4F46E5); // Indigo 600 - Main CTA button, active page indicator
const kPrimaryIndigoAccent = Color(0xFF6366F1); // Indigo 500 - Secondary brand accent
const kPrimaryIndigoLight = Color(0xFFEEF2FF); // Indigo 50 - Light container/card background
const kPrimaryIndigoGlow = Color(0x594F46E5); // Indigo 35% opacity glow
const kIndigoStroke = Color(0x59818CF8); // Indigo 400 35% opacity dashed line/stroke

// ==========================================
// Accent & Vault Colors (Teal / Mint / Aqua)
// ==========================================
const kTealPrimary = Color(0xFF0D9488); // Teal 600 - Core vault icon, lock rings, badges
const kTealAccent = Color(0xFF14B8A6); // Teal 500 - Active indicators, tags
const kMintAccent = Color(0xFF5EEAD4); // Teal 300 - Neon mint glow & highlights
const kMintLight = Color(0xFFCCFBF1); // Teal 100 - Mint badge & icon container background
const kMintPale = Color(0xFFE0F7F6); // Teal 50 - Gradient background top stop
const kAquaPale = Color(0xFFE6FFFA); // Aqua 50 - Gradient background variation

// ==========================================
// Neutral & Slate Scale (Text & Backgrounds)
// ==========================================
const kTextPrimary = Color(0xFF0F172A); // Slate 900 - Headings, bold titles, dark text
const kSlate800 = Color(0xFF1E293B); // Slate 800 - Secondary dark text
const kSlate700 = Color(0xFF334155); // Slate 700 - Body text, icons
const kSlate600 = Color(0xFF475569); // Slate 600 - Secondary body copy
const kTextSecondary = Color(0xFF64748B); // Slate 500 - Subtitles, description copy, muted icons
const kTextMuted = Color(0xFF94A3B8); // Slate 400 - Placeholder text, hints, meta tags
const kBorderColor = Color(0xFFE2E8F0); // Slate 200 - Inactive dots, card outlines/borders
const kSurfaceLight = Color(0xFFF1F5F9); // Slate 100 - Card backgrounds, icon circles
const kBackgroundLight = Color(0xFFF8FAFC); // Slate 50 - Screen scaffold background, inner cards

// ==========================================
// Status & Document Tag Colors
// ==========================================
// Success / Encrypted
const kSuccessColor = Color(0xFF10B981); // Emerald 500 - 'Encrypted' status, checkmarks, growth graphs

// DOC / Blue Tag
const kDocBadgeText = Color(0xFF3B82F6); // Blue 500 - 'DOC' badge text & icon
const kDocBadgeBg = Color(0xFFDBEAFE); // Blue 100 - 'DOC' badge background
const kSkyPale = Color(0xFFE0F2FE); // Sky 100 - Gradient bottom stop

// PDF / Red Tag
const kPdfBadgeText = Color(0xFFEF4444); // Red 500 - 'PDF' badge text
const kPdfBadgeBg = Color(0xFFFEE2E2); // Red 100 - 'PDF' badge background

// ==========================================
// Shadows & Transparency Overlays
// ==========================================
const kShadowSubtle = Color(0x08000000); // Black 3% - Subtle card elevation
const kShadowMedium = Color(0x10000000); // Black 6% - Floating card shadow
const kShadowSlateSubtle = Color(0x0A0F172A); // Slate 4% - Soft ambient shadow
const kShadowSlateMedium = Color(0x100F172A); // Slate 6% - Floating element shadow
const kShadowSlateCard = Color(0x120F172A); // Slate 7% - Main card elevation
const kShadowSlateFloating = Color(0x140F172A); // Slate 8% - Elevated card shadow
const kWhiteOverlay20 = Color(0x33FFFFFF); // White 20% overlay
const kWhiteOverlay80 = Color(0xCCFFFFFF); // White 80% frosted overlay

// ==========================================
// AppColors Helper Class
// ==========================================
class AppColors {
  // Brand
  static const Color primary = kPrimaryColor;
  static const Color primaryAccent = kPrimaryIndigoAccent;
  static const Color primaryLight = kPrimaryIndigoLight;

  // Vault / Teal
  static const Color teal = kTealPrimary;
  static const Color tealAccent = kTealAccent;
  static const Color mint = kMintAccent;
  static const Color mintLight = kMintLight;

  // Text & Neutrals
  static const Color textPrimary = kTextPrimary;
  static const Color textSecondary = kTextSecondary;
  static const Color textMuted = kTextMuted;
  static const Color border = kBorderColor;
  static const Color surface = kSurfaceLight;
  static const Color background = kBackgroundLight;
  static const Color white = kWhite;
  static const Color black = kBlack;

  // Status
  static const Color success = kSuccessColor;
  static const Color docBlue = kDocBadgeText;
  static const Color docBlueBg = kDocBadgeBg;
  static const Color pdfRed = kPdfBadgeText;
  static const Color pdfRedBg = kPdfBadgeBg;
}