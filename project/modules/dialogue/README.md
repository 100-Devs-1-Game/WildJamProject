# Dialogue System Documentation

## Overview

The dialogue system is a flexible, resource-based system for managing conversations and interactions with NPCs in the game. It supports branching dialogues, character images, typed text animation, and dialogue options with side effects.

## Architecture

The dialogue system consists of four main components:

### 1. **DialogueContainer** (dialogue_container.gd)
A resource that holds a collection of dialogue lines and manages navigation between them.

**Properties:**
- `start_id: String` - The ID of the first dialogue line to display (default: "start")
- `lines: Array[DialogueLine]` - Array of all dialogue lines in this container

**Methods:**
- `get_line_by_id(target_id: String) -> DialogueLine` - Returns the dialogue line with the specified ID, or null if not found

### 2. **DialogueLine** (dialogue_line.gd)
A resource representing a single line of dialogue spoken by a character.

**Properties:**
- `id: String` - Unique identifier for this line (used for navigation)
- `speaker_name: String` - The name of the character speaking
- `speaker_image: Texture2D` - The character's portrait/image
- `text: String` - The dialogue text (multiline support)
- `options: Array[DialogueOption]` - Available player choices for this line
- `next_line_id: String` - The ID of the next line to show (only used if no options are available)

### 3. **DialogueOption** (dialogue_option.gd)
A resource representing a player choice within a dialogue.

**Properties:**
- `text: String` - The text displayed for this option
- `next_line_id: String` - The ID of the dialogue line to show when this option is selected
- `effect: String` - Optional effect/callback to trigger (e.g., "add_gold", "remove_item")

### 4. **DialogueBox** (dialogue_box.gd)
The UI component that displays dialogue to the player and handles user interactions.

**Signals:**
- `dialogue_started` - Emitted when a dialogue begins
- `dialogue_finished` - Emitted when a dialogue ends

**Key Methods:**
- `start_dialogue(container: DialogueContainer)` - Begins displaying dialogue from the specified container
- `show_line(line: DialogueLine)` - Displays a specific dialogue line
- `show_options()` - Shows the available dialogue options for the current line
- `close_dialogue()` - Closes the dialogue box and cleans up

### 5. **DialogueTrigger** (dialogue_trigger.gd)
A Node2D that triggers dialogue when the player interacts with it (usually placed in the scene).

**Properties:**
- `dialogue_container: DialogueContainer` - The dialogue to display when triggered

**Features:**
- Detects when the player is within interaction range (via `InteractionArea`)
- Responds to the "interact" input action
- Automatically manages dialogue box state

## How to Use

### Creating a Dialogue

1. **Create a new DialogueContainer resource:**
   - Right-click in the FileSystem → New Resource → DialogueContainer
   - Name it something descriptive (e.g., `npc_trader_dialogue.tres`)

2. **Add DialogueLines to the container:**
   - In the resource editor, expand the "Lines" array
   - Click "Add Element" to create a new DialogueLine
   - Configure each line:
     - **id**: Unique identifier (e.g., "start", "greeting", "thanks")
     - **speaker_name**: Character name
     - **speaker_image**: Character portrait (PNG/JPG)
     - **text**: What the character says
     - **options**: Player choices (if any)
     - **next_line_id**: Where to go next (if no options)

3. **Set the start_id:**
   - Make sure the DialogueContainer `start_id` matches the ID of your first dialogue line

### Example Dialogue Flow

```
[start] "Hello, traveler!" 
    ↓
[greeting] "What brings you here?"
    ├→ Option 1: "I'm looking for work" → [job_offer]
    ├→ Option 2: "Just passing through" → [goodbye]
    └→ Option 3: "What do you sell?" → [items]

[job_offer] "Excellent! Here's a task for you..." → [next_task]
[goodbye] "Safe travels!" → [end]
[items] "We have potions, weapons, and armor." → [greeting]
```

### Adding Dialogue to a Scene

1. **Create or select a Node2D in your scene** (e.g., an NPC)
2. **Attach a DialogueTrigger:**
   - Add a child node of type `DialogueTrigger`
   - Assign your DialogueContainer resource to the `dialogue_container` property
   - Add an `Area2D` child node named `InteractionArea` (if not already present)
3. **Configure the interaction area:**
   - Add a `CollisionShape2D` with an appropriate shape (e.g., CircleShape2D for range)
   - This defines the area where the player can trigger the dialogue

### Input Handling

The dialogue system uses the `"interact"` input action:
- **When the player is near an NPC:** Pressing the interact button starts the dialogue
- **During dialogue:** Pressing the interact button advances the dialogue or selects the option
- **For closing:** If dialogue has no options and no next line, the "Next" button shows "Close (Press E)"

### TODO: Adding Dialogue Effects

When a player selects an option with an effect:

1. The effect string is printed to the console
2. Add custom effect handling in `DialogueBox.on_option_pressed()`:

```gdscript
func on_option_pressed(option: DialogueOption) -> void:
    if option.effect != "":
        match option.effect:
            "add_gold":
                # Add gold to player
                pass
            "remove_item":
                # Remove item from inventory
                pass
            # Add more effects as needed
    
    if option.next_line_id != "":
        show_line(current_container.get_line_by_id(option.next_line_id))
    else:
        close_dialogue()
```

### Troubleshooting

- **Dialogue won't start:** Check that the player is in the "Player" group
- **Options don't appear:** Verify the `TemplateOption` scene is properly referenced
- **Text appears all at once:** Check the `is_typing` flag logic
- **Blank dialogue:** Ensure the line ID matches an actual line in the container
