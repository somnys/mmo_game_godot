@tool
@icon("res://addons/wyvernbox/icons/item_type.png")
class_name ItemType
extends ItemLike

enum SlotFlags {
	SMALL = 1 << 0,
	LARGE = 1 << 1,
	EQUIPMENT = 1 << 2,
	QUEST = 1 << 3,
	POTION = 1 << 4,
	AMMO = 1 << 5,
	CURRENCY = 1 << 6,
	FUEL = 1 << 7,
	KEY = 1 << 8,
	CRAFTING = 1 << 9,
	#
	#
	#
	#
	#
	E_MAINHAND = 1 << 15,
	E_OFFHAND = 1 << 16,
	E_HELM = 1 << 17,
	E_CHEST = 1 << 18,
	E_BELT = 1 << 19,
	E_HANDS = 1 << 20,
	E_FEET = 1 << 21,
	E_RING = 1 << 22,
	E_NECK = 1 << 23,
}
## Matches flags of all equipment slots (hands, helmet, chest, belt, handwear, footwear, ring and neck)
const EQUIPMENT_FLAGS := (
	SlotFlags.E_MAINHAND
	| SlotFlags.E_OFFHAND
	| SlotFlags.E_HELM
	| SlotFlags.E_CHEST
	| SlotFlags.E_BELT
	| SlotFlags.E_HANDS
	| SlotFlags.E_FEET
	| SlotFlags.E_RING
	| SlotFlags.E_NECK
)
## The item's name. Can be a locale string.
@export var name := ""

## The item's description. Can be empty or a locale string.
@export var description := "" # (String, MULTILINE)

## How many items can fit into a single stack.
@export var max_stack_count := 1

## How many cells, horizontally, this item occupies in a [GridInventory].
@export var in_inventory_width := 1

## How many cells, vertically, this item occupies in a [GridInventory].
@export var in_inventory_height := 1

## The item's texture.
@export var texture : Texture2D

## The [Mesh] to spawn when it gets created on the ground. If not set, shows [member Texture].
@export var mesh : Mesh

## Optionally, the [PackedScene] to spawn when it gets created on the ground.
## If not set, uses scene set in [GroundItemManager] with [member mesh] or [member texture].
@export var custom_ground_prefab : PackedScene

## The scale of the item's texture.
@export var texture_scale := 1.0

## The [code]SlotFlags[/code] of this item. Used in [RestrictedInventory].
@export_flags(
"SMALL",
"LARGE",
"EQUIPMENT",
"QUEST",
"POTION",
"AMMO",
"CURRENCY",
"FUEL",
"KEY",
"CRAFTING",
"#",
"#",
"#",
"#",
"#",
"E_MAINHAND",
"E_OFFHAND",
"E_HELM",
"E_CHEST",
"E_BELT",
"E_HANDS",
"E_FEET",
"E_RING",
"E_NECK"
	) var slot_flags := 1

## The string representation of the type's [member default_properties].
@export_multiline var default_properties_string : String:
	set(v):
		default_properties_string = v
		if default_properties_converting: return
		default_properties_converting = true
		var converted = str_to_var(v)
		if converted is Dictionary: default_properties = converted
		default_properties_converting = false

## The type's default property dictionary.
## For editing, [default_properties_string] or the Dictionary Inspector addon are recommended.
## Can contain various data for display in [InventoryTooltip] via its [InventoryTooltipProperty], or other, game-specific uses.
## [code]price[/code] is used for vendor prices, selling and buying.
## [code]back_color[/code] is used to show a colored background in inventories and a glow on the ground.
@export var default_properties : Dictionary:
	set(v):
		default_properties = v
		if default_properties_converting: return
		default_properties_converting = true
		default_properties_string = var_to_str(default_properties)
		default_properties_converting = false

var default_properties_converting := false


## Returns [member in_inventory_width] and [member in_inventory_height] as a [code]Vector2[/code].
func get_size_in_inventory() -> Vector2:
	return Vector2(in_inventory_width, in_inventory_height)

## Returns [code]true[/code] if stack has the same type.
## For compatibility with [method ItemPattern.matches].
func matches(stack) -> bool:
	return stack.item_type == self

## Returns the value it contributes to an [ItemConversion]. Equals to the stack's [member ItemStack.count].
## For compatibility with [method ItemPattern.get_value].
func get_value(stack) -> int:
	return stack.count
