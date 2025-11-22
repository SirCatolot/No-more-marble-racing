extends PanelContainer

@onready var damage_label = $VBoxContainer/DamageContainer/ValueLabel
@onready var fire_rate_label = $VBoxContainer/FireRateContainer/ValueLabel
@onready var damage_cost_label = $VBoxContainer/DamageContainer/CostLabel
@onready var fire_rate_cost_label = $VBoxContainer/FireRateContainer/CostLabel
@onready var damage_button = $VBoxContainer/DamageContainer/UpgradeButton
@onready var fire_rate_button = $VBoxContainer/FireRateContainer/UpgradeButton
@onready var close_button = $VBoxContainer/CloseButton
@onready var tower_name_label = $VBoxContainer/Title

var current_tower = null

func _ready():
	visible = false
	damage_button.pressed.connect(_on_damage_upgrade_pressed)
	fire_rate_button.pressed.connect(_on_fire_rate_upgrade_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	GameState.money_changed.connect(_on_money_changed)

func set_tower(tower):
	current_tower = tower
	if tower:
		visible = true
		update_ui()
	else:
		visible = false

func update_ui():
	if not current_tower:
		return
	
	if "RedBullet" in current_tower.name or "Red" in current_tower.name:
		tower_name_label.text = "RED TOWER"
		tower_name_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
	elif "BlueArrow" in current_tower.name or "Blue" in current_tower.name:
		tower_name_label.text = "BLUE TOWER"
		tower_name_label.add_theme_color_override("font_color", Color(0.4, 0.4, 1))
	elif "PurpleBomb" in current_tower.name or "Purple" in current_tower.name:
		tower_name_label.text = "PURPLE TOWER"
		tower_name_label.add_theme_color_override("font_color", Color(0.8, 0.4, 1))
	else:
		tower_name_label.text = "UPGRADES"
		tower_name_label.remove_theme_color_override("font_color")

	var dmg = 0
	if "bulletDamage" in current_tower:
		dmg = current_tower.bulletDamage
	elif "bombDamage" in current_tower:
		dmg = current_tower.bombDamage
		
	var fr = 0
	if "fireRate" in current_tower:
		fr = current_tower.fireRate
		
	damage_label.text = str(dmg)
	# Show level next to value
	if "damage_level" in current_tower:
		damage_label.text += " (Lvl " + str(current_tower.damage_level) + ")"
		
	fire_rate_label.text = str(snapped(fr, 0.01))
	if "fire_rate_level" in current_tower:
		fire_rate_label.text += " (Lvl " + str(current_tower.fire_rate_level) + ")"
	
	var dmg_cost = current_tower.get_damage_upgrade_cost()
	var fr_cost = current_tower.get_fire_rate_upgrade_cost()
	
	damage_cost_label.text = "$" + str(dmg_cost)
	fire_rate_cost_label.text = "$" + str(fr_cost)
	
	damage_button.disabled = not GameState.can_afford(dmg_cost)
	fire_rate_button.disabled = not GameState.can_afford(fr_cost)

func _on_money_changed(_m):
	if visible and current_tower:
		update_ui()

func _on_damage_upgrade_pressed():
	if current_tower and GameState.try_spend(current_tower.get_damage_upgrade_cost()):
		current_tower.upgrade_damage()
		update_ui()

func _on_fire_rate_upgrade_pressed():
	if current_tower and GameState.try_spend(current_tower.get_fire_rate_upgrade_cost()):
		current_tower.upgrade_fire_rate()
		update_ui()

func _on_close_pressed():
	visible = false
	current_tower = null
