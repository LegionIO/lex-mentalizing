# lex-mentalizing

Theory of mind and belief attribution for LegionIO agents. Part of the LegionIO cognitive architecture extension ecosystem (LEX).

## What It Does

`lex-mentalizing` builds mental models of other agents by attributing beliefs to them. The agent tracks what it thinks each known agent believes, supports recursive belief chains up to depth 4 ("I think agent B thinks that agent C believes..."), detects false beliefs when attributed content conflicts with known facts, and projects its own beliefs onto unknown agents with confidence discounting.

Key capabilities:

- **Belief attribution**: track what each agent believes about any subject
- **Recursive belief chains**: support up to depth 4 nested attributions
- **False belief detection**: compare attributed beliefs against known ground truth
- **Self-projection**: spread own beliefs to unknown agents at 70% confidence
- **Alignment scoring**: confidence similarity between self and another agent

## Installation

Add to your Gemfile:

```ruby
gem 'lex-mentalizing'
```

Or install directly:

```
gem install lex-mentalizing
```

## Usage

```ruby
require 'legion/extensions/mentalizing'

client = Legion::Extensions::Mentalizing::Client.new

# Attribute a belief to another agent
client.attribute_belief(
  agent_id: 'agent-review-bot',
  subject: :deployment_safety,
  content: 'deployment is safe to proceed',
  confidence: 0.8
)

# Recursive belief attribution (second-order)
client.attribute_belief(
  agent_id: 'agent-orchestrator',
  subject: :task_status,
  content: 'task is complete',
  confidence: 0.6,
  depth: 2,
  about_agent_id: 'agent-worker'
)

# Detect false beliefs
client.detect_false_belief(
  agent_id: 'agent-review-bot',
  subject: :deployment_safety,
  actual_content: 'deployment has known issues'
)

# Check alignment with another agent
client.check_alignment(agent_id: 'agent-review-bot')
# => { alignment: 0.75, beliefs_compared: 4 }

# Recursive lookup
client.recursive_belief_lookup(agent_id: 'agent-orchestrator', subject: :task_status, depth: 2)
```

## Runner Methods

| Method | Description |
|---|---|
| `attribute_belief` | Attribute a belief to an agent |
| `project_belief` | Project own belief onto other agents with confidence discount |
| `check_alignment` | Confidence similarity between self and another agent |
| `detect_false_belief` | Find attributed beliefs that contradict known facts |
| `beliefs_for_agent` | All beliefs attributed to a specific agent |
| `beliefs_about_agent` | All beliefs across agents about a subject |
| `recursive_belief_lookup` | Traverse recursive belief chain to specified depth |
| `update_mentalizing` | Decay belief confidences and prune expired beliefs |
| `mentalizing_stats` | Agent count, total beliefs, avg confidence |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
