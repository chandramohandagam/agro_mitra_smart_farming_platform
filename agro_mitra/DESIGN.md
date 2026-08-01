---
name: Agro Mitra
colors:
  surface: '#f7faf5'
  surface-dim: '#d8dbd6'
  surface-bright: '#f7faf5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4ef'
  surface-container: '#ecefea'
  surface-container-high: '#e6e9e4'
  surface-container-highest: '#e0e3df'
  on-surface: '#181c1a'
  on-surface-variant: '#40493d'
  inverse-surface: '#2d312e'
  inverse-on-surface: '#eff2ed'
  outline: '#707a6c'
  outline-variant: '#bfcaba'
  surface-tint: '#1b6d24'
  primary: '#0d631b'
  on-primary: '#ffffff'
  primary-container: '#2e7d32'
  on-primary-container: '#cbffc2'
  inverse-primary: '#88d982'
  secondary: '#126d27'
  on-secondary: '#ffffff'
  secondary-container: '#9cf49c'
  on-secondary-container: '#19722b'
  tertiary: '#6d5100'
  on-tertiary: '#ffffff'
  tertiary-container: '#8c6800'
  on-tertiary-container: '#ffefd6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a3f69c'
  primary-fixed-dim: '#88d982'
  on-primary-fixed: '#002204'
  on-primary-fixed-variant: '#005312'
  secondary-fixed: '#9ff79f'
  secondary-fixed-dim: '#83da85'
  on-secondary-fixed: '#002105'
  on-secondary-fixed-variant: '#005318'
  tertiary-fixed: '#ffdf9e'
  tertiary-fixed-dim: '#fabd00'
  on-tertiary-fixed: '#261a00'
  on-tertiary-fixed-variant: '#5b4300'
  background: '#f7faf5'
  on-background: '#181c1a'
  surface-variant: '#e0e3df'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style

This design system embodies the intersection of agricultural heritage and high-technology precision. The brand personality is rooted in reliability and growth, targeting modern farmers and agribusiness professionals who require professional-grade tools that feel as intuitive as a consumer app. 

The aesthetic is a refined hybrid of **Material Design 3** and **Glassmorphism**. It prioritizes clarity through generous whitespace and a "soft-tech" feel. By blending the structured hierarchy of Google’s ecosystem with the premium finish of Apple Health, the UI evokes high trust and calmness. Expect deep rounded corners, subtle layered translucency, and a focus on "Living Data"—where information feels organic and accessible rather than cold and mechanical.

## Colors

The palette is anchored in **Nature Green (#2E7D32)**, providing a sense of stability and environmental stewardship. The secondary green acts as a vibrance booster for interactive elements, while the **Gold Accent (#FFC107)** is reserved for "harvest moments"—critical alerts, premium features, or high-value data points.

The background uses a very soft mint-grey (#F7FAF5) to reduce eye strain in outdoor lighting conditions. Surfaces are pure white to maintain high contrast for data legibility. Glassmorphic elements should utilize a 60% opacity white fill with a high-saturation background blur to maintain the premium AgriTech feel.

## Typography

The system uses **Plus Jakarta Sans** (as a sophisticated alternative to Google Sans) for all display and headline roles to provide a friendly, open, and modern character. For functional text, body copy, and data-heavy tables, **Inter** is utilized for its exceptional legibility and systematic structure.

Headlines should utilize a tighter letter spacing to appear more "designed," while body text maintains a generous 0.5px tracking to ensure readability for users who may be viewing the screen in direct sunlight. All mathematical or yield-related data should be set in Inter Medium to emphasize importance.

## Layout & Spacing

This design system follows an **8px linear grid** to ensure consistency across all components. The layout philosophy is a **Fluid Grid** that transitions into a centered **Fixed Grid** on ultra-wide displays (max-width: 1440px).

- **Mobile:** 4-column layout with 16px side margins.
- **Tablet:** 8-column layout with 24px side margins.
- **Desktop:** 12-column layout with 32px or 64px margins depending on the density of the dashboard.

Spacing between cards and major sections should lean toward the larger end of the scale (24px - 32px) to maintain the "Clean/Minimal" vibe and avoid a cluttered, industrial feel.

## Elevation & Depth

Elevation is achieved through a combination of **Ambient Shadows** and **Glassmorphic Layering**. 

1.  **Level 0 (Base):** Background color (#F7FAF5).
2.  **Level 1 (Cards):** White background with a 1px soft stroke (#E0E0E0) and a very soft, diffused shadow (Offset: 0, 4px; Blur: 20px; Opacity: 4% Black).
3.  **Level 2 (Overlays/Glass):** Floating Navigation Bars or Modals use a background blur (20px-30px) with 70% white opacity. A subtle inner glow (1px white top border) simulates a light source hitting the edge of the glass.
4.  **Level 3 (Interactive):** Active buttons or dragged items use a deeper shadow (Offset: 0, 8px; Blur: 24px; Opacity: 8% Primary Color) to signify "lift" from the surface.

## Shapes

The visual signature of this design system is the **24px ultra-rounded corner** on all primary container cards. This high radius softens the technical nature of the data and aligns with the organic theme of agriculture.

- **Primary Cards:** 24px radius.
- **Buttons & Input Fields:** 16px radius for a comfortable, modern touch target.
- **Chips & Tags:** Fully pill-shaped (100px) to differentiate them from actionable buttons.
- **Selection Controls:** Checkboxes and Radio buttons retain a slight 4px rounding to match the MD3 specification but feel custom to the system.

## Components

### Buttons
Primary buttons use a solid Nature Green fill with white text. Secondary buttons utilize the Glassmorphic style: a semi-transparent green tint with a 1px green border. All buttons have a 16px corner radius.

### Cards
Cards are the primary container. They must always have a 24px corner radius. In dashboard views, cards should use a white background. For "Insights" or "Weather" cards, a subtle Glassmorphism can be applied over a primary-color gradient background.

### Input Fields
Following MD3 "Filled" style but with more rounding. Backgrounds should be #F1F3F1 (a shade darker than the page background) with a 2px bottom-indicator that expands on focus using the Primary Color.

### Chips
Used for crop types or status filters. Use a subtle primary-tinted background with a Primary Color label. When selected, the chip fills with Primary Green and uses a checkmark icon.

### Navigation
The mobile bottom navigation bar should be a floating glassmorphic element with a 32px bottom margin, creating a "suspended" effect over the content. Use haptic-inspired animations for icon transitions.