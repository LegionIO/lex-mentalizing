# lex-mentalizing

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-mentalizing`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::Mentalizing`

## Purpose

Theory of mind and belief attribution for LegionIO agents. Builds mental models of other agents by attributing beliefs about subjects and tracking how those beliefs change over time. Supports recursive belief attribution up to depth 4 ("I believe that agent B believes that agent C believes..."), false belief detection, self-projection with confidence discounting, and alignment scoring between the agent and known others.

## Gem Info

- **Require path**: `legion/extensions/mentalizing`
- **Ruby**: >= 3.4
- **License**: MIT
- **Registers with**: `Legion::Extensions::Core`

## File Structure

```
lib/legion/extensions/mentalizing/
  version.rb
  helpers/
    constants.rb            # Limits, decay rate, projection discount, labels
    belief_attribution.rb   # BeliefAttribution value object
    mental_model.rb         # Per-agent belief model + recursive belief + projection
  actors/
    decay.rb                # Belief decay actor
  runners/
    mentalizing.rb          # Runner module

spec/
  legion/extensions/mentalizing/
    helpers/
      constants_spec.rb
      belief_attribution_spec.rb
      mental_model_spec.rb
    actors/decay_spec.rb
    runners/mentalizing_spec.rb
  spec_helper.rb
```

## Key Constants

```ruby
MAX_AGENTS           = 50
MAX_BELIEFS_PER_AGENT = 30
MAX_RECURSION_DEPTH  = 4
BELIEF_DECAY         = 0.02    # confidence decrement per decay tick
PROJECTION_DISCOUNT  = 0.7     # confidence multiplier when projecting own beliefs onto others

CONFIDENCE_LABELS = {
  (0.8..)     => :certain,
  (0.6...0.8) => :confident,
  (0.4...0.6) => :uncertain,
  (0.2...0.4) => :doubtful,
  (..0.2)     => :dismissing
}
```

## Helpers

### `Helpers::BeliefAttribution` (class)

A single belief attributed to an agent about a subject.

| Attribute | Type | Description |
|---|---|---|
| `id` | String (UUID) | unique identifier |
| `agent_id` | String | the agent holding this belief |
| `subject` | Symbol | what the belief is about |
| `content` | String | the belief content |
| `confidence` | Float (0..1) | how confident we are in this attribution |
| `depth` | Integer | recursion depth (1 = first-order, 2 = second-order, etc.) |
| `about_agent_id` | String | for depth > 1: which agent this belief is about |

Key methods:
- `decay` — confidence -= BELIEF_DECAY, floors at 0
- `reinforce` — confidence += 0.1 (cap 1.0)
- `label` — confidence label via CONFIDENCE_LABELS

### `Helpers::MentalModel` (class)

Per-agent belief registry with recursive belief traversal.

| Method | Description |
|---|---|
| `attribute_belief(agent_id:, subject:, content:, confidence:, depth:, about_agent_id:)` | stores belief; enforces MAX_BELIEFS_PER_AGENT per agent |
| `beliefs_for(agent_id:)` | all beliefs attributed to a specific agent |
| `beliefs_about(subject:)` | all beliefs across all agents about a subject |
| `recursive_belief(agent_id:, subject:, depth:)` | traverses belief chain up to MAX_RECURSION_DEPTH |
| `project_self(subject:, content:, confidence:)` | projects own belief onto unknown agents, discounted by PROJECTION_DISCOUNT |
| `alignment(agent_id:)` | confidence similarity between this agent's beliefs and agent_id's beliefs |
| `detect_false_belief(agent_id:, subject:, actual_content:)` | returns beliefs where content differs from actual_content |
| `decay_all` | decrements confidence on all beliefs across all agents |
| `prune_expired` | removes beliefs with confidence <= 0 |

## Actors

**`Actors::Decay`** — fires periodically, calls `update_mentalizing` on the runner to decay all belief confidences and prune expired beliefs.

## Runners

Module: `Legion::Extensions::Mentalizing::Runners::Mentalizing`

Private state: `@model` (memoized `MentalModel` instance).

| Runner Method | Parameters | Description |
|---|---|---|
| `attribute_belief` | `agent_id:, subject:, content:, confidence: 0.5, depth: 1, about_agent_id: nil` | Attribute a belief to an agent |
| `project_belief` | `subject:, content:, confidence:` | Project own belief onto others with discount |
| `check_alignment` | `agent_id:` | Confidence similarity between self and agent |
| `detect_false_belief` | `agent_id:, subject:, actual_content:` | Find attributed beliefs that contradict known facts |
| `beliefs_for_agent` | `agent_id:` | All beliefs attributed to an agent |
| `beliefs_about_agent` | `subject:` | All beliefs across agents about a subject |
| `recursive_belief_lookup` | `agent_id:, subject:, depth: 2` | Recursive belief chain traversal |
| `update_mentalizing` | (none) | Decay and prune expired beliefs |
| `mentalizing_stats` | (none) | Agent count, total beliefs, avg confidence, deepest recursion |

## Integration Points

- **lex-mesh**: mentalizing models the beliefs of mesh-connected agents; agent_ids from lex-mesh are the natural keys for belief attribution.
- **lex-trust**: trust scores from lex-trust can weight belief confidence — high-trust agents' beliefs are attributed with higher confidence.
- **lex-swarm**: swarm coordination benefits from shared mental models; mentalizing models what each swarm member believes about the task.
- **lex-empathy**: mentalizing provides the belief attribution layer that empathy draws on to compute affective responses.
- **lex-metacognition**: `Mentalizing` is listed under `:communication` capability category.

## Development Notes

- Agent mental models are stored in a flat hash keyed by agent_id in `MentalModel`. Each entry holds an array of BeliefAttribution objects.
- `recursive_belief` walks the chain: depth=1 returns agent_id's beliefs about subject; depth=2 returns agent_id's beliefs about what another agent believes about subject. The chain is limited to MAX_RECURSION_DEPTH=4.
- `project_self` creates new belief attributions for all known agents with confidence multiplied by PROJECTION_DISCOUNT (0.7). It does not check whether the agent already has a different attribution for the same subject.
- `detect_false_belief` compares attributed content strings with actual_content using case-insensitive string comparison. There is no semantic comparison.
- Belief decay is slow (0.02 per tick). At the default decay rate, a confidence=1.0 belief takes 50 ticks to expire.
- `MAX_BELIEFS_PER_AGENT` is enforced by removing the lowest-confidence belief when the limit is reached.
