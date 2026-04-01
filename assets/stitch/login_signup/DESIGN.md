# Design System Strategy: The Kinetic Horizon

## 1. Overview & Creative North Star
**The Creative North Star: "Precision Velocity"**

In the high-stakes, fast-moving world of delivery logistics, insurance shouldn't feel like paperwork—it should feel like a high-performance dashboard. This design system moves away from the "static forms" of traditional fintech. We are building an experience defined by **Precision Velocity**: a marriage of tactical utility and premium aesthetics. 

To break the "template" look, we utilize **Intentional Asymmetry**. We move away from centered, balanced layouts in favor of left-heavy typographic anchors and overlapping card elements that suggest movement. By utilizing high-contrast scales and "breathing" white space, we ensure that a rider glancing at their phone in mid-day sun can instantly parse their coverage status. We aren't just building an app; we are building a piece of flight-instrumentation for the urban athlete.

---

## 2. Colors & Surface Philosophy

Our palette is engineered for extreme legibility and "Tactical Premium" feel. We use orange not just as a color, but as a beacon.

### The "No-Line" Rule
**Explicit Instruction:** You are prohibited from using 1px solid borders to define sections. Traditional borders clutter the UI and feel "budget." Instead, boundaries must be defined solely through background shifts. Use `surface-container-low` against a `surface` background to create a crisp, modern edge without the "hairline" noise.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. We use a "Nesting" approach to depth:
- **Level 0 (Base):** `surface` (#0e0e0e) – The foundation.
- **Level 1 (Sections):** `surface-container-low` (#131313) – Large content blocks.
- **Level 2 (Interactive Cards):** `surface-container` (#1a1a1a) – The primary touch targets.
- **Level 3 (Elevated Details):** `surface-container-highest` (#262626) – Floating menus or critical status chips.

### The "Glass & Gradient" Rule
To inject "soul" into the fintech experience:
- **Primary CTAs:** Do not use flat orange. Use a subtle linear gradient from `primary` (#ff915a) to `primary-container` (#ff7a31) at a 135-degree angle. This adds a "convex" physical feel.
- **Floating Headers:** Use Glassmorphism. Apply `surface` at 70% opacity with a `20px` backdrop-blur. This keeps the user grounded in their scroll position while maintaining a futuristic, airy feel.

---

## 3. Typography: The Editorial Edge

We pair the technical precision of **Space Grotesk** with the human readability of **Manrope**.

- **Display & Headlines (Space Grotesk):** Use these for "At-a-Glance" data (e.g., Premium amounts, active minutes). The exaggerated ink traps and geometric forms convey a futuristic, tech-forward authority.
- **Body & Labels (Manrope):** High x-heights ensure readability while riding. 
- **The Contrast Play:** Always pair a `display-lg` numeric value with a `label-md` uppercase descriptor. This "Big-Small" pairing creates an editorial look found in premium magazines, moving away from "standard" form styling.

---

## 4. Elevation & Depth: Tonal Layering

We reject the 2014-era drop shadow. Depth in this system is achieved through light and material, not "fuzz."

*   **The Layering Principle:** Use the Spacing Scale `1.5` (0.5rem) as the standard padding between nested containers. The shift from `surface-container-low` to `surface-container` provides all the visual separation needed.
*   **Ambient Shadows:** For floating action buttons (FABs) or emergency modals, use a "Tinted Shadow." Instead of black, use `primary` at 12% opacity with a `32px` blur and `16px` Y-offset. This makes the element look like it is glowing with its own energy.
*   **The "Ghost Border" Fallback:** If high-noon glare makes tonal shifts invisible, use a "Ghost Border": `outline-variant` at 15% opacity. It should be felt, not seen.
*   **Tactical Glass:** Use `surface-bright` for elements that need to "pop" out of the dark mode, acting as a light source within the UI.

---

## 5. Components

### Buttons (Tactical Triggers)
*   **Primary:** Gradient fill (`primary` to `primary-container`), `xl` (1.5rem) rounded corners. Text is `on-primary-fixed` (Pure Black) for maximum contrast.
*   **Secondary:** Ghost style. No fill, `outline` token at 30% opacity. 
*   **Interaction:** On press, the button should scale to 96%—a physical "click" sensation.

### Cards (The Information Unit)
*   **Rule:** Forbid divider lines. Use `spacing-4` (1.4rem) of vertical white space to separate groups. 
*   **Layout:** Use `surface-container`. All cards must use `xl` (1.5rem) corner radius to feel friendly despite the high-contrast "sharp" colors.

### Input Fields (Minimal Friction)
*   **Style:** No "box" inputs. Use a "Slab" style—a solid `surface-container-high` background with a bottom-accent of `primary` only when focused.
*   **Large Touch Targets:** Minimum height of `12` (4rem) to accommodate gloved hands.

### Specialized Component: The "Active Shield"
A persistent, glassmorphic header that appears when insurance is active. It uses `primary` text and a pulsing `primary-dim` glow to provide "Ambient Assurance" to the rider without them needing to stop and read.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use `primary` orange for "Action" and "Active Status" only. If everything is orange, nothing is important.
*   **Do** use `display-lg` for the most important number on the screen (e.g., "YOU ARE COVERED").
*   **Do** lean into the `0.5rem` to `1rem` roundedness. It balances the "aggressive" high-contrast colors with a premium, approachable feel.

### Don’t
*   **Don't** use pure black (#000000) for text on a white background in Light Mode. Use `surface-container-lowest` for a softer, more premium "Charcoal" look.
*   **Don't** use standard Material Design "Drop Shadows." If it looks like a default Android app, you’ve failed the "Premium" requirement.
*   **Don't** use icons with fills. Use **Stroke-based icons** with a 1.5px or 2px weight to maintain the "Technical Blueprint" aesthetic.