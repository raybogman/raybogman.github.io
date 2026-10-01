---
title: "AI FinOps: The Economics of AI at Scale"
date: "2026-10-01 08:00:00 +0000"
description: "AI features are cheap to demo and easy to ship. Knowing what one accepted customer outcome costs is harder. A leadership perspective on designing AI economics into the product: cost per accepted outcome, pricing, ARR and MRR, observability, controlled model routing and ownership."
featured_image: "/assets/images/ai-finops-economics-of-ai-at-scale.png"
tags: [AI, FinOps, Leadership, Tech Leadership, Pricing, Observability, AI Governance]
---

**The feature works. Customers are using it. Then someone in a finance review asks what one successfully completed task actually costs, and the room goes quiet.**

Picture a hypothetical B2B product-information platform that has just shipped an AI feature: upload a product catalogue, and the system completes missing attributes, writes descriptions, and translates them into three languages. The demo landed. Adoption is healthy. Engineering can report the number of model calls and the tokens consumed. Finance has the provider invoices and the cloud bill. Product has a usage dashboard showing how many catalogues were processed. All three views are accurate. None connects to the others, so nobody can say what one accepted product record costs, or whether the plan price covers it.

That gap is the subject of this article. It is not a tooling gap. It is a design gap, and it is one that leadership owns.

The FinOps Foundation describes [FinOps](https://www.finops.org/framework/) as an operational framework and cultural practice that maximises the business value of technology and creates financial accountability through collaboration between engineering, finance and business teams. In plain English: the people who build, the people who pay, and the people who sell make decisions together, with shared numbers, on an ongoing basis. Applied to AI, the cost of an outcome is designed in from the first architecture sketch, not reconstructed from invoices after launch.

I recently spent time exploring exactly this, through a proof of concept and an AI FinOps workshop covering subscriptions, feature entitlements, estimated versus actual model costs, multiple languages, cost allocation and model routing. It was exploratory work, not a production case study, and the numbers in this article are illustrative rather than measured. The useful learning was not a list of tools. It was a way of connecting decisions that are usually made in separate rooms.


## One customer action becomes many paid operations

The first thing the enrichment example teaches is that "one request" is a fiction. A customer clicks once. Behind that click, the workflow retrieves the existing product data and similar records, checks completeness, calls a model to enrich the record, calls it again for each target language, runs a validation pass, and if validation fails, retries with a corrected prompt. Each of those steps has a cost, and several of them carry the same context forward, so the same product description may be paid for as input four or five times.

It gets less visible from there. Background agents run without any fresh user action: a nightly job that re-checks records against updated supplier data, a monitor that re-translates when the source text changes. These are legitimate features. They also mean spend is no longer proportional to visible usage, which is the assumption most pricing pages quietly rely on.

Two distinctions matter here. The first is between building software with AI and operating AI features in production. Coding assistants make development faster, and that is real value, but it says nothing about what the resulting feature costs to run for every customer, every month. Faster coding does not establish better runtime economics. The second is between unit price and total spend. Provider prices per token have fallen repeatedly, and every fall makes it rational to send more context, add another validation pass, or switch on a background agent. Lower unit prices can stimulate usage, so lower token prices do not guarantee lower bills. That rebound is not inevitable for every business, but a falling price list should never be mistaken for a falling cost line.


## Measure the accepted outcome, not the token

Cost per token is a resource metric. It tells you how efficiently you buy inference. It does not tell you whether the business is making money. The FinOps Foundation's [unit economics](https://www.finops.org/framework/capabilities/unit-economics/) guidance draws exactly this line, separating resource-efficiency metrics such as cost per token from business unit metrics such as cost per case resolved. For AI features, the business unit is the accepted outcome: a correctly enriched product record, an accepted translation, a resolved support case, a completed integration task.

Defining it properly takes discipline. Cost per accepted outcome is the total relevant cost of the workflow over a stated period, divided by the number of outcomes that met the agreed acceptance criteria in that period. Failed attempts, retries and records that were discarded after review all belong in the numerator. They were paid for. Only accepted outcomes belong in the denominator.

The cost layers for the enrichment workflow look something like this.

| Cost layer | What it includes in the enrichment example |
|---|---|
| Licences and subscriptions | Gateway, evaluation tooling, vendor platform fees |
| Model usage | Enrichment, translation and validation calls, including retries |
| Orchestration and tool calls | Workflow engine, retrieval, external data lookups |
| Data retrieval and storage | Vector index, product data, logs and traces |
| Infrastructure | Compute for the pipeline, queues, monitoring stack |
| Evaluation and monitoring | Test-set runs, quality scoring, dashboards |
| Human review and rework | Time spent on exceptions and corrections |

Two cautions. Do not double-count: if the review team's salaries already sit in a departmental budget, allocate the hours they spend on this workflow, not their whole cost. And be explicit about whether you are quoting marginal cost, roughly the model and orchestration spend that varies with each record, or fully allocated cost, which adds shared platform, evaluation and human effort. Comparing a marginal number for one option against a fully allocated number for another is how good decisions go wrong.

The example that follows is illustrative and the assumptions are stated so the arithmetic can be checked. Imagine the platform processes 10,000 product records a month across three languages. Option A uses a stronger, more expensive model. Option B uses a cheaper one. Reviewers cost €45 per hour and spend six minutes on each exception. Shared costs (orchestration, evaluation, infrastructure and licences) are €950 a month in both cases.

| | Option A: stronger model | Option B: cheaper model |
|---|---|---|
| Model usage | €1,800 | €900 |
| Exception rate | 5% (500 records, 50 hours, €2,250) | 12% (1,200 records, 120 hours, €5,400) |
| Shared costs | €950 | €950 |
| Total monthly cost | €5,000 | €7,250 |
| Accepted outcomes | 9,850 | 9,700 |
| Fully allocated cost per accepted outcome | €0.51 | €0.75 |
| Marginal cost per accepted outcome (model only) | €0.18 | €0.09 |

On marginal cost, the cheaper model wins comfortably. On fully allocated cost, it loses by almost half, because the exceptions it creates are paid for in human time. Neither answer is wrong; they answer different questions. A model choice is never only a cost decision. Every alternative should be judged on cost, quality, latency and human effort at once, and language coverage and input quality shift all four. A sparse supplier feed in a language the model handles poorly raises the exception rate whichever model you pick, and that belongs in the forecast too.


## Pricing has to reflect the product's economics

Once you know what an accepted outcome costs, pricing stops being a marketing exercise. The most honest structure for AI-heavy features is usually a hybrid: a predictable subscription base, an explicitly included amount of AI usage, and transparent charges or prepaid allowances beyond it. Customers see a plan, an entitlement and a limit, and can see how much of the entitlement they have used. This is a design option to test against demand and willingness to pay, not a universal rule. Flat plans work where usage is naturally bounded and the margin has been checked against the high-usage case rather than the average.

One separation is non-negotiable. Internal model routing and customer pricing are different systems. If the platform switches the enrichment step to a different model next month, the customer's agreed tariff should not move. Customers need predictable terms and visibility into their own consumption, not exposure to every provider price change. The business absorbs that variability, which is precisely why it needs to measure it.

Pricing also has to be reported in terms finance can defend. Monthly Recurring Revenue (MRR) is the subscription revenue a customer has contracted to pay each month; Annual Recurring Revenue (ARR) is the same commitment annualised. Both describe what is contracted, not what was consumed. Usage above the included allowance is real revenue but uncommitted, and a busy month annualised and presented as secured ARR is a forecast dressed up as a contract. Keep three lines apart: contracted recurring revenue, forecast usage revenue, and actual consumption revenue. Agree the definitions and reporting policy with finance before the first invoice.

A scenario view makes the sensitivity visible. Continue the illustrative example: a plan priced at €1,500 a month includes 3,000 accepted enrichments, with additional outcomes at €0.45 each. Variable cost per accepted outcome is €0.35 and the fixed platform cost allocated to this customer is €150 a month.

- **Low usage, 1,000 outcomes.** Revenue €1,500. Cost €500. Margin €1,000, or 67%.
- **Expected usage, 3,000 outcomes.** Revenue €1,500. Cost €1,200. Margin €300, or 20%.
- **High usage, 6,000 outcomes.** Revenue €2,850 (€1,500 plus 3,000 overage outcomes at €0.45). Cost €2,250. Margin €600, or 21%.

Revenue nearly doubles between the expected and high scenarios. Margin as a percentage barely moves, because overage is priced close to cost. And if exceptions rise and variable cost drifts from €0.35 to €0.45, the expected scenario's margin falls to zero. More revenue and more engagement do not automatically mean a healthier business. The scenario table is where that becomes obvious before it becomes a problem.


## Observability connects an action to its consequence

None of the above can be managed if the platform cannot trace what happened, why it happened, what it cost and whether it produced an acceptable result. That is what observability means here. Logging model calls is the easy part. The harder part is carrying the right identifiers all the way through: tenant or customer, plan, feature, workflow, agent, request, and model plus version. When those identifiers are attached to every step and joined to outcome data, cost per accepted outcome becomes a query rather than a quarterly reconstruction.

A compact operating view for the enrichment feature needs only a handful of signals: cost per accepted outcome, acceptance and rework rates, latency at the percentile the customer notices, budget burn against the period, projected spend, attributable revenue, and margin. The value is in what the accountable owner does with it. If the rework rate for one language climbs, the owner routes that language to a stronger model or to review and checks the cost line the following week. If a tenant's projected spend will cross their entitlement, the product warns the customer before finance discovers it.

Two sources of truth have to coexist. Near-real-time telemetry, estimated from token counts and list prices, supports intervention while it still matters. Provider invoices settle what was actually billed and arrive later. They will not match exactly, because discounts, caching, retries, price versions and shared costs all produce differences. Reconciling the two on a regular cadence is unglamorous and essential. Not every cost or every euro of revenue can be measured perfectly in real time; the goal is a known, small, explained variance.

Budget alerts are not spending caps. An alert tells someone that a threshold was crossed; it stops nothing. Enforceable limits are separate mechanisms: caps on requests per tenant, on spend per period, on the steps an agent may take, and on retries per task. Each limit needs a deliberate behaviour when it is hit: stop and fail visibly, queue for later, escalate to a human, or fall back to an approved cheaper path. The one behaviour that is never acceptable is silent degradation, where a cost control quietly produces a worse answer the customer is still charged for. Gateway products increasingly provide the plumbing, and the documentation deserves a careful read. Vercel's AI Gateway, for example, describes its [budgets](https://vercel.com/docs/ai-gateway/observability-and-spend/budgets) as a soft cap, where the request that crosses the limit still completes. Reasonable, but it is the application, not the gateway, that decides what happens to the customer's task.

I wrote recently about [what happens when AI-generated notes become company truth](/blog/organizational-bias-when-ai-notes-become-company-truth/). The same discipline applies here. An AI output that nobody has checked is not an accepted outcome, and a dashboard that counts it as one is measuring the wrong thing.


## Dynamic model routing needs a controlled lifecycle

Model routing is where AI FinOps most often goes wrong, because it sounds like a pure optimisation. The principle is sound: for each feature, select the least costly approved approach that satisfies its quality, latency, privacy and operational requirements. The word doing the work is approved.

Task complexity alone is not enough to route on. Context length, the languages involved, tool and structured-output support, the region where data may be processed, and how the model behaves when it fails all decide whether a cheaper option is acceptable for a given step. The router making this choice does not need to be a language model. A rule table keyed on feature, language and input size is cheaper, more predictable and easier to audit.

The lifecycle has four separate stages: discover a new model, evaluate it, approve it, and route production traffic to it. Discovery and evaluation can be automated. A new listing in a provider catalogue is not production approval. Evaluation means running the candidate against a representative, versioned test set for the specific feature, comparing all four dimensions, and recording the result. Approval is a decision with an owner. Rollout is controlled, monitored and reversible, with a rollback path that has been exercised. The cost of evaluation, test-set maintenance and the routing layer itself belongs in the workflow economics, because a routing strategy that saves five percent on inference and costs an engineer to maintain is not saving anything.

Gateways help with the plumbing. LiteLLM, an open-source proxy with a commercial enterprise tier, offers per-key, per-team and per-user budgets with spend tracking and fallback routing, documented in its [repository](https://github.com/BerriAI/litellm). OpenRouter is a hosted routing service, not an open-source product, and states in its [FAQ](https://openrouter.ai/docs/faq) that it passes provider pricing through without markup while charging a fee on credit purchases. None of them knows what your feature entitlements are, what your customer was promised, or what an accepted outcome looks like. The application owns feature policy, entitlements and customer economics. The gateway owns the pipe.


## Most optimisation is workflow design

The optimisations with the best return rarely involve a new model. They involve sending less, sending it less often, and not sending it at all when a rule will do.

Caching where it is safe is the clearest example. Providers now serve repeated prompt prefixes at a fraction of the input price. Anthropic's [prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) documentation, for instance, specifies a minimum cacheable length per model, a short default lifetime with a longer paid option, and a cache read price that is a small fraction of the base input price. For the enrichment workflow, the stable instructions, style guide and product taxonomy should sit at the front of every prompt so they are read from cache rather than paid for in full each time. The trade-off is staleness: a cached prefix that includes yesterday's taxonomy will confidently apply yesterday's categories.

Batching work that can wait is the second. Overnight enrichment of a new catalogue does not need a two-second response. Anthropic's [Message Batches API](https://platform.claude.com/docs/en/build-with-claude/batch-processing) processes requests asynchronously at half the standard price, with most batches completing within an hour and a 24-hour expiry. The trade-off is latency and unfinished work: an expired batch leaves records unprocessed, and the workflow has to notice.

The rest is hygiene that only looks trivial. Trim context the model does not need and cap output to what the feature uses. Deduplicate calls so that two users triggering the same enrichment on the same record produce one request. Put a ceiling on retries with backoff, so a provider incident does not become a retry storm that costs more than the outage. Use deterministic rules for the simple cases: a completeness check does not need a model, and a field copied verbatim across languages should not be translated. Each of these changes one variable. Measure all four dimensions after each one, and only then scale it. The [pipeline thinking](/blog/ai-content-pipeline-for-wordpress/) I applied to content generation applies here too: the expensive step is rarely the one everyone is looking at.

Quality assurance belongs in cost control, not beside it, because every defect that reaches a customer is paid for twice. Code tooling is secondary to the workflow decisions above, but one method deserves a precise mention because it is often described loosely. Mutation testing, as tools such as [Stryker](https://stryker-mutator.io/docs/) implement it, deliberately changes your code and checks whether your tests fail as a result. A high mutation score means the tests detect changes. It says nothing about whether the business logic was right, whether the system is secure, or whether the model's output is any good. It checks the tests, not the product.


## Ownership, and where to start

Everything in this article fails if it is treated as an engineering project. Product, engineering and finance have to share one operating rhythm, with security and privacy expertise at the table whenever data handling or region affects a routing decision, and with one accountable owner per use case. Product defines value and the acceptance criteria. Engineering implements the measurement and the controls. Finance validates the cost allocation, the pricing assumptions and the forecast. The FinOps Foundation's [guidance on FinOps for AI](https://www.finops.org/wg/finops-for-ai-overview/) makes the same point about ownership, and about establishing visibility before attempting optimisation.

A practical start is small. Pick one representative workflow, ideally one that already has customers and a cost line. Establish a baseline: what it costs today, fully allocated, per accepted outcome. Agree the quality criteria and a budget for the period. Instrument the workflow end to end so that every step carries the identifiers described above. Run one optimisation experiment, and only one, so that the effect can be attributed. Then decide: improve, scale, or stop. That decision is the deliverable, and it is a leadership decision, not a dashboard.

Keep the rhythm afterwards. A monthly value review that puts cost per accepted outcome, margin by plan and the exception trend in front of the three functions is enough. Re-evaluate models when something meaningful changes: a price move, a quality regression, a new language, a contractual requirement. Do not turn every model announcement into migration work. The evaluation pipeline exists so that a new option can be tested in a day and adopted only if it wins on all four dimensions for that feature.

The question I would put to any leadership team shipping AI features is simple to ask and hard to answer well. For one useful outcome your product delivers, can you explain what it cost, why it cost that, what the customer paid for it, and who is accountable when any of those numbers moves? If the answer depends on a reconstruction from invoices, the economics are not yet designed in. If it can be answered from the system, on demand, with a known variance, the business is ready to scale what it built.


---

### Sources

- FinOps Foundation, [FinOps Framework](https://www.finops.org/framework/) and [Unit Economics capability](https://www.finops.org/framework/capabilities/unit-economics/).
- FinOps Foundation, [FinOps for AI overview](https://www.finops.org/wg/finops-for-ai-overview/), updated February 2026.
- Anthropic, [Prompt caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) and [Batch processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing) documentation.
- Vercel, [AI Gateway budgets and spend limits](https://vercel.com/docs/ai-gateway/observability-and-spend/budgets), updated September 2026.
- OpenRouter, [FAQ](https://openrouter.ai/docs/faq); BerriAI, [LiteLLM repository](https://github.com/BerriAI/litellm).
- Stryker Mutator, [documentation](https://stryker-mutator.io/docs/).
