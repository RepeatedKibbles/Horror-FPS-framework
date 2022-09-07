tool
extends EditorPlugin

"""
	雲シェーダー for Godot Engine by あるる（きのもと 結衣）
	Cloud Shader for Godot Engine by Yui Kinomoto @arlez80

	MIT License
"""

func _enter_tree( ):
	self.add_custom_type( "CloudDome", "MeshInstance", preload("Cloud.gd"), preload("icon.png") )
	# TODO: 追加する方法を探す
	#self.add_blabla_type( "CloudShader", "ShaderMaterial", preload("CloudMat.tres"), preload( "icon.png" ) )

func _exit_tree( ):
	self.remove_custom_type( "CloudDome" )
	#self.remove_blabla_type( "CloudShader" )

func get_plugin_name( ):
	return "Cloud Shader"
