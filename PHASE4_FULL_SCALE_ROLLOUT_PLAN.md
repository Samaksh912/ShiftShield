# ShiftShield Phase 4 Full-Scale Rollout Plan

Date: 2026-04-02
Repo: `/home/arnavbansal/Guidewire`
Baseline branch: `Arnav-3`

## 1. Purpose

This document defines **Phase 4** as the final large-scale implementation plan for the Guidewire hackathon version of Phase 2.

This plan assumes:

- Phase 2 backend baseline is complete
- Phase 2.5 product-alignment work is complete
- Phase 3 prototype foundation is complete:
  - city -> zone hierarchy
  - differentiated premium model
  - geography-specific threshold configuration

Phase 4 should turn the current prototype-scale product into a stronger, more realistic, more presentation-ready rollout while keeping the scope bounded enough for the hackathon.

Important scope note:

- Project **Phase 3** remains the security/fraud-engine workstream
- This document is only for the **product rollout / realism / scale-up** workstream

## 2. Phase 4 Objective

By the end of Phase 4, the product should be demonstrably closer to the full intended Guidewire pitch:

- multiple cities across all tiers, but focused on a small set of high-impact demo geographies
- multiple operational zones per city
- stronger city/zone-aware premium behavior
- a stronger mock-trained model with realistic synthetic distributions and explainable outputs
- operational analytics and scenario control for demoable monitoring
- richer demo and review artifacts

This is still a hackathon build, not a production launch, so the plan intentionally prioritizes:

- end-to-end demoability
- realism where it helps the pitch
- bounded implementation phases
- explainable architecture

## 3. What Phase 4 Must Achieve

### Product outcomes

1. A real multi-city, multi-zone operating model
2. Stronger premium differentiation and explainability
3. A convincing monitoring and control surface for triggers, payouts, and geography state
4. A clearer path from mock data to realistic simulated data, without pretending real historical retraining exists today
5. A demo/presentation surface that honestly shows:
   - what is real
   - what is mocked
   - what is dynamically calculated

### Architecture outcomes

1. Stable city -> zone hierarchy used consistently in backend and ML
2. Premium model that remains bounded but is more differentiated and explainable
3. Threshold/risk configuration that can scale by geography
4. A clean analytics/control layer for live or simulated monitoring
5. Test and verification artifacts strong enough for final review

## 4. What Is Already Done Before Phase 4

The following should be treated as baseline, not re-implementation work:

- 8 cities and 12 zones exist in the prototype
- city tiers `T1 / T2 / T3` exist
- `zone_id` remains the active operational key
- dynamic premium calculation exists
- underwriting exists
- geography-specific thresholds exist
- claim flow, dashboard, wallet, notifications, and admin trigger flow exist
- non-Bengaluru flow is already verified

## 5. Remaining Gaps Before Final Rollout

### 5.1 Geography scale

Current state:

- 8 cities
- 12 zones
- only Bengaluru has multiple zones

Gap:

- the rollout needs a few high-signal archetypal cities with intentional multi-zone coverage
- zone distribution should look intentional, not incidental
- riders should exist for the zones being shown, not just the cities

### 5.2 Data realism

Current state:

- seeded/mock riders
- seeded/mock thresholds
- dynamic pricing on a bounded range
- real/live weather path exists but demo often uses deterministic fallback

Gap:

- the synthetic model should feel realistic and explainable enough to survive judge scrutiny
- the rollout should clearly separate:
  - seeded inputs
  - simulated scenarios
  - runtime calculations
  - optional live weather

### 5.3 Premium realism

Current state:

- premium differentiation exists
- bounded to `₹20–₹50`

Gap:

- premium logic should be more explainable per city/zone/tier
- the “why this rider pays this premium” story should become stronger

### 5.4 Tracking and analysis

Current state:

- admin trigger simulation exists
- dashboard exists

Gap:

- no richer city/zone analytics layer
- no simple demo control layer for intentionally triggering parametric events
- limited visibility into city/zone status, trigger history, and payout summaries as a monitoring product

### 5.5 Demo/readout layer

Current state:

- backend/API demoability is good

Gap:

- need clearer artifacts for judges and reviewers:
  - what is hardcoded
  - what is computed
  - what is live
  - what is simulated

## 6. Phase 4 Should Be Implemented In 3 Phases Maximum

Phase 4 is capped at **3 implementation phases**.

## 7. Phase 4.1 — Geography Scale-Up And Runtime Model

### Goal

Scale the product from prototype geography to a stronger multi-city rollout model that is deep enough to demo convincingly.

### Required work

1. Expand from the current prototype into a small set of archetypal high-impact cities
   - maintain `T1`, `T2`, `T3`
   - prefer depth over breadth
   - recommended archetypes:
     - one rain-heavy coastal city
     - one AQI-heavy northern city
     - one heat/traffic-heavy southern city

2. Give each supported demo city multiple zones
   - not just Bengaluru
   - target 3-4 zones for each featured demo city
   - each city should show meaningful intra-city risk differences

3. Normalize zone metadata
   - city_id
   - zone_id
   - risk_class
   - city_tier
   - earnings baselines
   - threshold hooks

4. Expand seeded rider coverage intentionally
   - each featured city must have at least 2 demo-ready riders
   - each tier represented
   - both Swiggy and Zomato represented
   - include at least:
     - 1 eligible rider
     - 1 insufficient-history or restricted rider
     - 1 rider usable for paid-claim flow
   - seeding should be idempotent and scenario-oriented where possible
   - new rider IDs, phones, and zones must not collide with existing test fixture assumptions

5. Draft the demo runbook early
   - define the exact demo story before Phase 4.2
   - specify:
     - which cities/zones are shown
     - which riders are used
     - what admin trigger scenarios will be demonstrated
     - what outputs judges should see

6. Make city runtime/API support stronger
   - list cities
   - list zones by city
   - expose enough read-only geography data for demo/UI support

7. Retrain or re-encode the pricing model for the expanded zone set before moving into premium work
   - expanded zones must not remain “unknown” to the model
   - this is a hard gate between 4.1 and 4.2, not an optional enhancement
   - minimum validation:
     - every new zone can generate a bounded premium
     - no new zone falls outside the intended quote range

8. Add a backend/ML zone-sync verification check
   - backend and ML must agree on the supported zone_id set before demo use
   - this can be a health-check or startup validation, but it must fail loudly on drift

### Priority split

Must-have:

- 3 featured cities with 3-4 zones each
- seeded riders for every showcased city
- stable city/zone runtime/API support
- demo runbook outline
- expanded-zone ML retraining or equivalent encoding update
- backend/ML zone-sync verification

Nice-to-have:

- more cities beyond the featured archetypes
- richer geography metadata normalization

Cut if behind:

- broad India-wide expansion without riders or demo flows

### Success criteria

- multiple zones per city are modeled across the featured city set
- backend and ML both load the expanded hierarchy correctly
- demo can traverse multiple cities without hand-waving

## 8. Phase 4.2 — Premium And Data Realism Upgrade

### Goal

Upgrade from a seeded/differentiated prototype premium model into a stronger, more explainable final hackathon pricing system using realistic simulated data.

### Required work

1. Strengthen the current synthetic/mock-trained model rather than splitting into a mandatory second “real-data” mode
- deterministic enough for demo stability
- driven by:
  - city tier
  - zone risk
  - weather/AQI
  - trigger history
  - rider earning baseline
- trained on more realistic simulated distributions if retraining is needed for expanded geography coverage
- synthetic generation must be parameterized by city archetype or “climate personality,” not just by new zone IDs
- explicitly document that this is a realistic simulated-data model, not a production historical-data model
- if retraining does not materially increase zone/tier feature importance, the explainability layer should frame zone/tier as configuration inputs
  such as thresholds, baselines, and payout caps, not overclaim them as dominant model drivers

2. Add premium explanation outputs that are judge-friendly
- emphasize what actually drives the quote today
- explain:
  - why current week conditions matter
  - why shift type matters
  - how zone/city tier influence configuration, baselines, and thresholds
- do not overclaim zone/tier effects if the model signal is still dominated by weather/shift inputs

3. Introduce premium-tier structure without losing dynamic behavior
- higher-risk zones should trend higher
- lower-risk zones should trend lower
- all still remain bounded and affordable

4. Add validation artifacts
- premium spread by city tier
- premium spread by zone risk
- premium behavior under safe vs risky weeks
- explicit retraining/encoding plan when new zones are added
- post-retraining validation that every supported zone still produces bounded premiums

### Priority split

Must-have:

- stable final pricing model for featured cities/zones
- explainable premium outputs
- validation artifacts for safe vs risky weeks

Nice-to-have:

- feature-importance or explanation summary artifact

Cut if behind:

- any “real-data-improved” mode that depends on unavailable historical data

### Success criteria

- pricing remains dynamic
- pricing is more obviously differentiated
- pricing story is explainable in product terms
- there is a documented honest explanation of what is simulated, what is configured, and what is runtime-calculated

## 9. Phase 4.3 — Analytics, Demo Control, And Final Demo Hardening

### Goal

Turn the scaled product into a final review/demo system that visibly supports operational monitoring, scenario control, and insurer-facing review without adding risky new infrastructure.

### Required work

1. Analytics snapshot layer
- zone/city monitoring view
- current trigger/weather status by geography
- recent trigger history
- recent claims and payouts by geography
- implement as one on-demand admin analytics endpoint, not new streaming infrastructure

2. Demo control layer
- extend the existing admin trigger simulation path rather than inventing a separate control subsystem
- add a simple admin/demo surface for intentionally triggering parametric events
- make it easy to show:
  - zone trigger
  - optional city-wide scenario trigger if cheap enough
  - affected policies
  - paid vs under_review claims
  - downstream dashboard effects

3. Insurer/admin analytics summary
- active policies by city/zone
- claim counts by geography
- payout totals by geography
- threshold breach summaries
- fraud/under-review summaries where available from the parallel security narrative
- if the parallel fraud engine is not ready, fall back to existing claim status / fraud-flag fields and do not block Phase 4 on that dependency

4. Demo hardening
- clear seeded demo personas across tiers/cities
- clearly marked live vs fallback behavior
- stable end-to-end demo runbooks
- add a reset/reseed path for clean demo reruns if needed
- prefer UI reuse across rider/admin views to keep frontend scope bounded

5. Review artifacts
- final test report
- final architecture summary
- final “what is real vs mocked vs calculated” sheet

### Priority split

Must-have:

- one analytics snapshot endpoint
- demo control path
- demo runbook
- final truth sheet for real vs mocked vs calculated

Nice-to-have:

- reset/reseed endpoint for cleaner demo reruns

Cut if behind:

- any true real-time streaming layer
- infrastructure-heavy monitoring additions

### Success criteria

- a reviewer can see the product working as a scaled multi-city system
- the analytics/control layer makes the product feel operational, not just transactional
- the final demo no longer depends on a single narrow path

## 10. Real vs Mock Strategy

Phase 4 should explicitly separate **what is mocked** from **what is real**.

### Mocked / seeded at rollout stage

- rider profiles and some rider activity histories
- some threshold configuration
- some trigger scenarios for repeatable demos
- most training data, unless explicitly stated otherwise

### Real or closer-to-real

- live weather path where available
- actual backend pricing execution
- actual policy / claim / wallet / dashboard logic

### Required honesty rule

The demo and documentation should clearly state:

- what is seeded
- what is simulated
- what is dynamically calculated
- what is live

## 11. Suggested Review Strategy

Because Codex usage is limited, use a lighter mixed review model:

### Use Claude as the primary broad implementation agent for

- larger backend/API/dashboard implementation slices
- multi-file refactors
- broad feature execution where the scope is already well-defined
- milestone-level implementation review

### Use Codex / Thinking 2 selectively for

- exact repo verification
- bounded runtime and test verification
- narrower ML/backend patches
- precise truth-checking when an implementation claim is ambiguous

### Use Gemini for

- phase planning refinement
- external critique
- rollout/story coherence
- checkpoint review on whether a slice is still demoable and appropriately scoped

### Use Claude for adversarial review when needed

- deep adversarial review of a major phase output
- cross-cutting risk review before freeze
- challenge review after Gemini planning feedback

## 12. Proposed External Review Checkpoints

### After Phase 4.1

- Gemini quick review on geography rollout realism
- Claude review if the geography slice becomes larger than planned

### After Phase 4.2

- Gemini review on premium realism/explainability
- Codex verification on bounded ML/backend truth
- Claude adversarial review if pricing changes are material

### After Phase 4.3

- Gemini review on final demo coherence
- Codex verification on exact repo/runtime claims
- final Claude adversarial review

## 12.1 Recommended Agent Split For Phase 4

Use this default split unless a slice is unusually small:

### Phase 4.1 — Geography scale-up

- Claude: primary implementation
- Codex: targeted verification and small cleanup
- Gemini: checkpoint review on realism and demoability

### Phase 4.2 — Premium and data realism

- Claude: implementation planning and larger supporting changes
- Codex: precise ML/backend pricing changes and integrated verification
- Gemini: explainability and product-story review

### Phase 4.3 — Analytics, demo control, and hardening

- Claude: primary implementation
- Codex: endpoint/test verification and final truth checks
- Gemini: demo-flow and presentation coherence review

## 13. Implementation Sequence Summary

Phase 4 should execute in this exact order:

1. **Phase 4.1**
   - featured-city geography scale-up
   - more zones per featured city
   - stronger runtime geography support
   - early demo runbook

2. **Phase 4.2**
   - premium and simulated-data realism upgrade
   - explainability + validation artifacts
   - ML retraining for expanded zone set as a hard gate completed before 4.2 premium work

3. **Phase 4.3**
   - one analytics snapshot layer
   - demo control
   - insurer/admin summaries in the same response shape where practical
   - demo hardening
   - final review artifacts

## 14. What This Plan Intentionally Does Not Do

Not in the first implementation move:

- full CPCB production integration
- full ward-level operational rollout everywhere
- a complete production fraud/security engine here
- a total rewrite of existing backend contracts
- any claim that the model is trained on true production historical data unless such a pipeline actually exists

Those can exist as separate or later workstreams if needed.

## 15. Completion Standard

Phase 4 should be considered complete when:

- the product demonstrates a convincing multi-city, multi-zone rollout across a small featured geography set
- premium differentiation is stronger and explainable
- analytics/control makes the system feel operational
- the demo can honestly show what is live vs simulated
- external review does not reveal a major product-integrity flaw

## 16. Execution Guardrails

To keep this hackathon-final phase executable:

- every phase must keep existing relevant tests green
- every new endpoint must get at least a smoke test
- every expanded-zone retraining pass must verify bounded premiums for all supported zones
- backend and ML must verify the same supported zone_id set before demo-ready builds
- each phase should end with a demoability checkpoint, not just code completion
- if time pressure appears, cut breadth before cutting the demo story
- if the storage layer remains single-file JSON for demo mode, acknowledge it explicitly as a demo constraint
