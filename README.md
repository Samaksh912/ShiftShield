# ShiftShield

## AI-Powered Weekly Income Protection for Food Delivery Riders

ShiftShield is an AI-enabled parametric insurance platform built exclusively for food delivery partners on platforms such as Swiggy and Zomato. It protects riders against loss of earnings during specific working shifts caused by verified external disruptions — heavy rain, extreme heat, severe air pollution, and mobility restrictions.

Unlike traditional insurance, ShiftShield uses objective real-world signals and AI-based income modeling to detect income disruption and trigger payouts automatically, without requiring any manual claim submission from the rider.

> **Video Walkthrough:** [Insert 2-minute prototype video link here]
> **Repository:** [Insert GitHub/GitLab link here]

---

## Table of Contents

1. [Persona and User Scenarios](#1-persona-and-user-scenarios)
2. [Problem Statement](#2-problem-statement)
3. [Coverage Scope](#3-coverage-scope)
4. [Platform Choice](#4-platform-choice)
5. [Weekly Premium Model](#5-weekly-premium-model)
6. [Parametric Trigger Design](#6-parametric-trigger-design)
7. [Payout Logic](#7-payout-logic)
8. [AI and Machine Learning Plan](#8-ai-and-machine-learning-plan)
9. [Fraud Prevention Strategy](#9-fraud-prevention-strategy)
10. [Adversarial Defense and Anti-Spoofing](#10-adversarial-defense-and-anti-spoofing)
11. [Tech Stack](#11-tech-stack)
12. [6-Week Development Plan](#12-6-week-development-plan)
13. [System Architecture](#13-system-architecture)
14. [Business Viability](#14-business-viability)
15. [Conclusion](#15-conclusion)

---

## 1. Persona and User Scenarios

### Primary Persona

**Arjun, 27 — Swiggy delivery partner, Bengaluru**

| Attribute | Detail |
|---|---|
| Operating zone | Koramangala (approx. 3 km radius, PIN 560034) |
| Active shifts | Lunch (12–3 PM) and Dinner (7–11 PM), 6 days a week |
| Shift earnings | ₹350–500 (lunch), ₹600–900 (dinner) |
| Weekly income | ₹5,500–₹8,400 |
| Device | Android smartphone, limited digital literacy |
| Pain point | A single heavy-rain evening wipes out ₹700–900 in dinner earnings with zero recourse |

---

### Scenario 1 — Heavy Rain Disruption (Primary Trigger)

It is a Wednesday evening. IMD reports 18 mm/hour of rainfall in the Koramangala zone between 7 PM and 9 PM. Google Maps traffic data shows a 52% drop in vehicle density in the zone. ShiftShield's trigger engine detects both signals simultaneously. Arjun holds an active dinner-shift policy for this week. The system classifies the event as a Level 3 disruption. A payout of 60% of his covered dinner-shift earnings (₹800 baseline → ₹480 payout) is processed automatically to his UPI handle. Arjun receives a push notification. He never filed a claim.

---

### Scenario 2 — AQI Spike (Secondary Trigger)

Delhi, November. AQI in Lajpat Nagar crosses 401 (Severe category) at 6:30 PM. ShiftShield's AQI monitor detects the breach via the OpenAQ API. Restaurant availability in the zone drops by 38% (tracked via Zomato public search proxy). Both signals confirm income disruption. Riders with active dinner-shift policies in that zone receive automatic Level 2 payouts (40% of covered shift earnings) within 15 minutes.

---

### Scenario 3 — Adverse Selection Attempt (Fraud Guard)

A rider in Chennai attempts to purchase a policy at 6:45 PM on a Wednesday, 15 minutes before an IMD-forecast heavy rain event. The system blocks the purchase — policies must be bought at least 24 hours before the Monday 00:00 start of the coverage week. The rider is informed and directed to purchase coverage for the following week.

---

### Scenario 4 — Suspicious Inactivity During Disruption

During a verified rain event in Pune, 47 of 200 active riders in the zone show GPS coordinates that have not moved for over 90 minutes. However, 12 of those 47 show no prior login or activity on the ShiftShield app for the entire day preceding the event — anomalous compared to their 30-day activity baseline. These 12 claims are flagged for manual review. The remaining 35 are processed automatically.

---

## 2. Problem Statement

Food delivery partners in India are exposed to income volatility they cannot control. External disruptions — heavy rainfall, extreme heat, severe pollution, and mobility restrictions — can reduce a rider's weekly earnings by 20–40% with no safety net in place.

ShiftShield addresses this by providing a shift-level weekly parametric protection model that is fully automated, priced fairly against real risk, and designed around how gig workers actually earn.

---

## 3. Coverage Scope

### What Is Covered

Income loss during a covered shift caused by verified external disruptions.

| Disruption | Trigger Signal | Detection Source |
|---|---|---|
| Heavy rain / flooding | Rainfall ≥ 15 mm/hour | IMD API / OpenWeatherMap |
| Extreme heat | Temperature ≥ 42°C for 2+ hours during shift | OpenWeatherMap |
| Severe air pollution | AQI ≥ 301 (Very Poor / Severe) | OpenAQ API |
| Mobility restriction | Curfew or zone closure declared | Government notification proxy / news API |
| Severe flooding | IMD Red Alert + traffic density drop ≥ 50% | IMD + Google Maps Distance Matrix API |

### What Is Excluded (Strictly)

- Health insurance or medical expenses
- Life insurance
- Accident-related payouts
- Vehicle damage or repair costs
- Any manual claim submitted by the rider

---

## 4. Platform Choice

ShiftShield is built as a **Flutter-based mobile application**.

**Justification:** Delivery riders operate exclusively on smartphones. Flutter enables a single codebase for Android and iOS, supports real-time push notifications for disruption alerts and payout confirmations, and allows deployment to the majority of riders using mid-range Android devices. A web platform is not suitable given the rider's context — they are in the field, not at a desk.

---

## 5. Weekly Premium Model

### Coverage Week Definition

A coverage week runs from Monday 00:00 to Sunday 23:59. Policies must be purchased by Saturday 23:59 (at least 24 hours before the week begins). Mid-week purchases are not permitted.

### Zone Definition

A zone is defined as a named locality with an associated PIN code and a fixed 2–3 km radius centred on a major landmark (e.g. Koramangala market, Lajpat Nagar metro station). Zone boundaries are pre-defined in the system. A rider selects one primary zone at onboarding.

### Premium Calculation Inputs

- Zone-level historical disruption frequency (last 12 months)
- Rider's declared shift coverage (lunch, dinner, or both)
- Shift-level income baseline (derived from onboarding declaration)
- Day-of-week demand patterns for the selected zone
- Forecasted disruption probability for the upcoming week (weather ML model output)

### Indicative Premium Examples

| Zone Risk Level | Shifts Covered | Weekly Premium | Max Payout |
|---|---|---|---|
| Low (e.g. central Delhi, clear season) | Dinner only | ₹18–22 | ₹500 |
| Medium (e.g. Mumbai, moderate monsoon) | Lunch + Dinner | ₹38–48 | ₹900 |
| High (e.g. Chennai, peak monsoon) | Lunch + Dinner | ₹58–75 | ₹900 |

Premium is recalculated each week based on updated forecast data and zone-level prior payouts.

### Anti-Adverse Selection Controls

- Policy purchase window closes at Saturday 23:59 each week
- Premium dynamically adjusts based on 7-day forecast risk at time of purchase
- A rider with 3+ consecutive weeks of full payouts triggers a risk review and temporary premium uplift
- No policy can be purchased once a Red Alert or equivalent disruption warning is active for the rider's zone

---

## 6. Parametric Trigger Design

ShiftShield requires **both** conditions to be satisfied before a payout is initiated. A single signal alone is insufficient.

### Condition A — External Disruption Signal

| Trigger | Threshold | Source API |
|---|---|---|
| Rainfall | ≥ 15 mm/hour sustained for ≥ 30 minutes | IMD / OpenWeatherMap (free tier) |
| Extreme heat | ≥ 42°C for ≥ 120 minutes during active shift | OpenWeatherMap |
| AQI | ≥ 301 (Very Poor) for ≥ 60 minutes during active shift | OpenAQ (free, open) |
| Flood / Red Alert | IMD Red or Orange alert issued for the rider's zone | IMD public alert feed |
| Mobility restriction | Confirmed curfew or zone closure (manual admin input for Phase 1) | Admin dashboard entry |

### Condition B — Market Activity Validation

At least two of the following three proxy signals must confirm income impact:

| Proxy Signal | Method | Threshold |
|---|---|---|
| Traffic density drop | Google Maps Distance Matrix API — compare to 30-day same-hour average | ≥ 40% drop |
| Active rider count drop | ShiftShield app — GPS-active riders in zone vs prior 4-week average | ≥ 35% drop |
| Restaurant availability | Zomato public search response count for zone (mock/scrape in Phase 1) | ≥ 30% drop |

### Payout Trigger Logic

```
IF (Condition A is active during covered shift window)
AND (≥ 2 of 3 Condition B proxies are confirmed)
THEN → Classify severity → Generate payout → Run fraud check → Process
```

---

## 7. Payout Logic

### Severity Classification

| Level | Condition | Payout |
|---|---|---|
| Level 1 | Mild — 1 Condition B proxy confirmed | 20% of covered shift earnings baseline |
| Level 2 | Moderate — 2 Condition B proxies confirmed | 40% of covered shift earnings baseline |
| Level 3 | Severe — all 3 Condition B proxies confirmed + strong Condition A | 60% of covered shift earnings baseline |
| Level 4 | Extreme — IMD Red Alert + all proxies + rider GPS inactive | 80% of covered shift earnings baseline |

### Payout Guardrails

- Maximum one payout per shift per week
- Dinner-shift payouts are weighted 1.4x (higher income dependency)
- If multiple disruptions occur in the same shift window, only the highest severity level is applied — no stacking
- Covered shift earnings baseline is declared at onboarding and locked for the policy week; it cannot be modified after purchase

### Payout Denominator

The percentage applies to the rider's **declared shift earnings baseline**, not to the weekly premium.

> **Example:** Arjun's dinner shift baseline is ₹800. A Level 2 event pays 40% × ₹800 = **₹320**, regardless of what his actual earnings were that night.

---

## 8. AI and Machine Learning Plan

### A. Income Volatility and Premium Pricing Model

**Model type:** Gradient Boosted Regression (XGBoost)

**Training inputs:**
- Historical weather data per zone (IMD, 2 years)
- Historical AQI data per zone (OpenAQ, 2 years)
- Simulated income disruption events correlated with weather records
- Shift type, day of week, zone risk tier

**Outputs:**
- Predicted disruption probability for the upcoming week per zone per shift
- Estimated income variance range
- Dynamic weekly premium recommendation

**Framework:** scikit-learn / XGBoost (Python), served via a lightweight FastAPI REST endpoint

---

### B. Fraud Detection Model

**Model type:** Isolation Forest (unsupervised anomaly detection) combined with rule-based validation

**Behavioural features used:**
- GPS activity in the 2 hours before and during a disruption window
- App login frequency on the day of the disruption
- Acceptance rate pattern over the prior 30 days
- Distance from declared operating zone during the disruption window
- Deviation from cohort median (other registered riders in the same zone on ShiftShield)

> **Cohort note:** The cohort is ShiftShield's own registered rider base in a zone — not platform data. Cohort comparison accuracy improves as the rider base grows.

**Outputs:**
- Fraud risk score (0–1)
- Scores above 0.72 → flagged for manual admin review
- Scores below 0.72 → auto-approved

**Framework:** scikit-learn IsolationForest, trained on synthetic behavioural data in Phase 1, retrained on real data from Phase 2 onward.

---

### C. Trigger Monitoring

- Real-time polling of weather and AQI APIs at 15-minute intervals during active shift windows
- Severity classification is deterministic (rule-based thresholds), not ML-based, to ensure auditability and transparency
- ML is used for pricing and fraud detection — not for the trigger decision itself

---

## 9. Fraud Prevention Strategy

### Zero-Claim Model

No claim is ever initiated by the rider. This eliminates the primary fraud vector present in traditional insurance.

### Automated Validation Checks (in order)

1. **Active policy verification** — policy exists and is active for the current week
2. **Shift window check** — disruption occurred within the rider's covered shift hours
3. **Zone consistency check** — disruption is confirmed within the rider's declared zone
4. **GPS activity validation** — rider's device was active (not stationary at home) during the disruption window
5. **Cohort comparison** — rider activity compared to same-zone ShiftShield riders
6. **Duplicate check** — no prior payout has been issued for this shift in this week
7. **Isolation Forest score** — behavioural anomaly score computed and compared against threshold

### Manual Review Queue

Claims scoring above the fraud threshold (0.72) are held for admin review. Admin resolves within 24 hours. The rider is notified of the hold and the expected resolution time.

---

## 10. Adversarial Defense and Anti-Spoofing

In response to the rising threat of coordinated GPS-spoofing syndicates, ShiftShield operates on a **Zero-Trust Location Model**. Standard GPS coordinates are treated as a weak, unverified signal alone. A multi-layered adversarial defense architecture cross-validates physical reality against digital claims to protect the liquidity pool without penalising honest workers.

### A. AI-Driven Differentiation: Genuine Rider vs. Spoofed Actor

The Isolation Forest model evaluates the "physical physics" of each claim by examining telemetry patterns:

| Signal | Genuine Stranded Rider | Spoofed Actor |
|---|---|---|
| GPS coordinates | Micro-movements, slight positional drift | Mathematically perfect stationary coordinates or physically impossible teleports |
| Accelerometer / gyroscope | Erratic variance consistent with outdoor storm exposure | Completely static — device resting flat |
| Battery drain | Elevated, consistent with poor network connectivity | Normal or low |
| Altitude (Z-axis) | Natural variation from finding shelter | Spoofing apps frequently fail to simulate realistic elevation changes |

The ML decision gate requires the rider's digital footprint to align with the macro-market reaction — a measurable drop in overall zone traffic and restaurant order activity. A syndicate can fake 500 GPS locations, but they cannot fake the broader economic shutdown of an entire zone.

---

### B. Detecting Coordinated Fraud Rings

To identify and isolate localised, organised attacks, ShiftShield analyses deep telemetry and network data beyond basic GPS.

**Hardware telemetry (physical layer):**
- Accelerometer and gyroscope variance — is the device experiencing physical vibrations consistent with being outdoors in a storm, or is it completely static?
- Z-axis / altitude data — spoofing applications frequently fail to simulate realistic elevation changes

**Network intelligence (syndicate layer):**
- Graph network analysis — detecting suspicious clusters such as 50+ accounts sharing identical IP subnets, simultaneous login/logout bursts, or identical app-ping intervals
- Device fingerprinting — identifying multiple accounts operating from cloned device IDs, emulators, or identical OS builds that deviate from normal market variance

---

### C. Protecting Honest Riders: Graceful Degradation

A genuine rider experiencing a network drop during a severe storm must never be penalised for a failed ping. ShiftShield balances aggressive fraud defense with empathetic UX through the following workflow.

**Last Known Good State:** If an active rider loses network connectivity during a verified weather disruption, the system relies on their last confirmed active state and their 30-day reliability baseline. A rider who was active and moving just before the storm is granted the benefit of the doubt.

**Flagged queue workflow:** If a claim trips the anomaly detection model, the claim is not rejected outright. It is routed to a Pending Verification queue.

**Transparent rider communication:** The rider's app displays:

> *"Severe weather detected in your zone. Due to network congestion, your payout is in the final verification queue. Expected resolution: 24 hours."*

This prevents panic, secures the liquidity pool from instant mass-drain, and provides admins the necessary window to review cohort data and block the syndicate before funds are released.

---

## 11. Tech Stack

### Frontend
- Flutter (Android + iOS)

### Backend
- Node.js — API layer, trigger monitoring, claim orchestration
- Python (FastAPI) — ML model serving (premium engine, fraud scoring)

### Database
- PostgreSQL via Supabase — policies, rider profiles, claims, payout records

### AI and ML
- XGBoost — premium pricing model
- scikit-learn IsolationForest — fraud detection
- pandas, numpy — data pipeline

### External APIs

| API | Purpose |
|---|---|
| OpenWeatherMap (free tier) | Rainfall, temperature |
| OpenAQ (open, free) | AQI data |
| IMD public feed | Red / Orange alerts |
| Google Maps Distance Matrix API | Traffic density proxy |
| Zomato public search (mock/proxy in Phase 1) | Restaurant availability proxy |

### Payment Integration

| Phase | Integration |
|---|---|
| Phase 1 | Mock payout display — simulated UPI transfer confirmation in UI |
| Phase 2 | Razorpay test mode (sandbox) for payout simulation |
| Phase 3 | Razorpay test mode + UPI simulator for full end-to-end demo |

### Deployment
- Backend: Render / Railway
- ML serving: Render (Python service)
- Database: Supabase (hosted PostgreSQL)

---

## 12. 6-Week Development Plan

### Phase 1 — Ideation and Foundation (Weeks 1–2, March 4–20)

**Goal:** Core architecture, onboarding, static premium display, prototype UI

- Rider registration and onboarding flow (Flutter)
- Zone and shift selection UI
- Static weekly premium calculator (rule-based, no ML yet)
- Basic parametric trigger simulation (hardcoded weather mock)
- README and architecture documentation
- 2-minute prototype video

**Deliverable:** Functioning Flutter prototype demonstrating onboarding → zone selection → premium display → simulated trigger alert

---

### Phase 2 — Automation and Protection (Weeks 3–4, March 21–April 4)

**Goal:** Live API integration, dynamic pricing, claims pipeline, fraud groundwork

- Live weather and AQI API integration (OpenWeatherMap, OpenAQ)
- Dynamic premium calculation powered by XGBoost model (trained on synthetic data)
- Insurance policy creation and management (CRUD operations)
- Parametric trigger engine — real-time monitoring during shift windows
- Automatic claim generation on trigger confirmation
- Razorpay test mode integration for payout simulation
- Basic Isolation Forest fraud scoring (synthetic training data)
- Rider dashboard — active policy, disruption alerts, payout history
- Admin dashboard — active policies, trigger events, fraud flags
- 2-minute demo video

**Deliverable:** End-to-end demo — onboarding → policy purchase → live disruption detected → auto-claim → Razorpay sandbox payout shown

---

### Phase 3 — Scale and Optimise (Weeks 5–6, April 5–17)

**Goal:** Advanced fraud detection, full payout simulation, intelligent dashboards, final submission package

- GPS spoofing detection and advanced behavioural fraud features
- Hardware telemetry integration (accelerometer, gyroscope, altitude)
- Isolation Forest retrained on Phase 2 real interaction data
- Cohort anomaly detection with zone-level comparison
- UPI simulator integration (end-to-end payout flow)
- Intelligent worker dashboard — earnings protected, coverage calendar, disruption history
- Intelligent admin dashboard — loss ratio trends, next-week disruption forecast, zone risk heatmap
- 5-minute final demo video demonstrating: simulated rainstorm trigger → auto-claim approval → payout processing
- Final pitch deck (PDF)

---

## 13. System Architecture

### Core Services

| Service | Stack | Responsibility |
|---|---|---|
| Rider Mobile App | Flutter | Onboarding, policy management, alerts, payout status |
| Policy Service | Node.js | Policy creation, shift/zone storage, coverage validation |
| Premium Engine | Python / FastAPI | XGBoost model serving, weekly pricing calculation |
| Trigger Engine | Node.js | 15-min polling of weather/AQI APIs, severity classification |
| Claims Service | Node.js | Auto-claim generation, fraud score request, payout initiation |
| Fraud Service | Python / FastAPI | Isolation Forest scoring, rule-based validation, manual review queue |
| Payout Service | Node.js | Razorpay/UPI sandbox integration, payout confirmation |
| Admin Dashboard | React or Flutter Web | Policy monitoring, fraud review, analytics |

### External Dependencies

- OpenWeatherMap API (rainfall, temperature)
- OpenAQ API (AQI)
- IMD public alert feed
- Google Maps Distance Matrix API (traffic proxy)
- Zomato search proxy / mock (restaurant availability)
- Razorpay test mode / UPI simulator (payout)

---

## 14. Business Viability

### Revenue Model

Weekly premiums collected from riders constitute the premium pool. Target: ₹38–75 per rider per week depending on zone risk and shift coverage.

### Risk Pooling

Zone-level premium pools absorb localised disruptions. A city-level reserve handles correlated city-wide events (e.g. a Mumbai monsoon flood affecting multiple zones simultaneously). Payout caps per zone per event week prevent pool depletion.

### Sustainability Benchmark

ShiftShield targets a combined loss ratio below 65% — meaning at least 35% of premiums cover operational costs and reserves. Premium adjustment after high-payout weeks ensures pool recovery.

### Scalability Path

ShiftShield's zone-based, API-driven model scales horizontally. Adding a new city requires configuring zone boundaries and validating local API coverage. ONDC integration in a future phase could provide verified platform activity data, replacing proxy signals with authoritative income data.

---

## 15. Conclusion

ShiftShield protects the income behind every shift. It is built around the actual earning behaviour of food delivery riders — shift-level, zone-specific, and fully automated — with no claim burden placed on the rider. The dual-signal parametric trigger model ensures payouts are objective, fraud-resistant, and fair.

The platform is designed to be realistic within its phase constraints: mock and sandbox integrations in early phases, with a clear path to live payment and API integration by the final submission.

---

> **ShiftShield protects the income behind every shift.**
