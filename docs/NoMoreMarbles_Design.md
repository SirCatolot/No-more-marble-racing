# No More Marbles — Design Document (Towers, Marbles, and Maps)

## Document Purpose
This document defines the design framework for all **Towers**, **Marbles**, and **Maps** in *No More Marbles*.
It is intended to be **modular**, **scalable**, and **developer-friendly** — allowing new entities to be added or existing ones to be modified with minimal structural changes.

---

<details>
<summary>SECTION 1: TOWERS</summary>

### Tower Template

### Tower: [Name]  
- **Type:** [Damage / Slow / Hybrid / Utility]  
- **Cost:** [Base Cost]  

**Base Stats:**  
- **Damage:** [value per shot]  
- **Range:** [short / medium / long]  
- **Fire Rate:** [shots per second]  
- **Effect:** [Describe base effect or impact on marbles]  

**Upgrade Branches:**  

**Branch A — [Theme/Function, e.g., "Precision"]:**  
| Tier | Upgrade Name | Cost | Effect / Description |  
|------|---------------|------|----------------------|  
| 1 | [Upgrade 1] | [Cost] | [Effect] |  
| 2 | [Upgrade 2] | [Cost] | [Effect] |  
| 3 | [Upgrade 3] | [Cost] | [Effect] |  

**Branch B — [Theme/Function, e.g., "Support"]:**  
| Tier | Upgrade Name | Cost | Effect / Description |  
|------|---------------|------|----------------------|  
| 1 | [Upgrade 1] | [Cost] | [Effect] |  
| 2 | [Upgrade 2] | [Cost] | [Effect] |  
| 3 | [Upgrade 3] | [Cost] | [Effect] |  

- **Visual Notes:** [Shape, color, projectile type, animation cues]  
- **Sound Notes:** [Firing, impact, upgrade sounds]  
- **Implementation Notes:** [Script references, prefab names, variables]  

### Tower Entries
(Add tower entries here following the template above.)

</details>

---

<details>
<summary>SECTION 2: MARBLES</summary>

### Marble Template

### Marble: [Name]  
- **Tier:** [1–5 / Early–Late game]  
- **Health (HP):** [integer]  
- **Speed:** [float]  
- **Resistance:** [None / Slow / Damage / etc.]  
- **Spawn Wave:** [wave number or range]  
- **Behavior:** [Movement or special behavior]  
- **Special Ability:** [Passive or triggered ability, if any]  
- **Visual Notes:** [Color, texture, material, size]  
- **Sound Notes:** [Rolling, hit, destruction, etc.]  
- **Implementation Notes:** [Script name, prefab, variables]  

### Marble Entries
(Add marble entries here following the template above.)

</details>

---

<details>
<summary>SECTION 3: MAPS</summary>

### Map Template

### Map: [Name]  
- **Theme:** [Wood / Glass / Metal / Hybrid / etc.]  
- **Path Length:** [units or tiles]  
- **Track Complexity:** [Describe loops, splits, ramps, etc.]  
- **Tower Slots:** [number and coordinates or regions]  
- **Entry Point:** [position or node ID]  
- **Exit Point:** [position or node ID]  
- **Difficulty Curve:** [Easy / Medium / Hard + notes]  
- **Environment Notes:** [Lighting, materials, ambiance]  
- **Implementation Notes:** [Scene file name, node layout, scripts used]  

### Map Entries
(Add map entries here following the template above.)

</details>

---

<details>
<summary>SECTION 4: BALANCING & PROGRESSION</summary>

(Optional — use for reference tables and progression planning.)

### Tower Balance Table
| Tower Name | Base Cost | Damage | Range | Fire Rate | Special Effect |  
|-------------|------------|---------|--------|------------|----------------|  

### Marble Balance Table
| Marble Name | HP | Speed | Resistance | Wave | Notes |  
|--------------|----|--------|-------------|------|-------|  

### Map Difficulty Table
| Map Name | Path Length | Tower Slots | Difficulty | Notes |  
|-----------|--------------|--------------|-------------|-------|  

</details>

---

<details>
<summary>SECTION 5: CHANGE LOG</summary>

Use this section to track updates to designs, balance tweaks, and entity changes over time.

| Date | Change | Author | Notes |  
|------|---------|---------|-------|  

</details>

---

*End of Document*
