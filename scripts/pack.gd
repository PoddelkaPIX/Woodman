extends Node

var all = {}

func add(key, label, count=1 , desc='', icon=''):
	if !icon: icon = key
	if !desc: desc = label
	if all.has(key):
		all[key].count += count
	else:
		all[key] = {
			'label' : label,
			'desc' : desc,
			'count' : count,
			'icon' : icon,
		}

func has(key):
	return all.has(key)
	
func remove(key, count=1):
	if has(key):
		if count != -1:
			all[key].count -= count
			if all[key].count < 1:
				all.arase(key)
		else:
			all.erase(key)
			
func get_all():
	return all
