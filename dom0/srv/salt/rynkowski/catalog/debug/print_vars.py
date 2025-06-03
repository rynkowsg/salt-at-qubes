#!py

import os, sys
from pathlib import Path

import re

def ls(dir):
	print("--------------------------------------------------")
	print(f"content of '{dir}'")
	print("--------------------------------------------------")
	directory = Path(dir)
	for entry in directory.iterdir():
		print(entry.name)
	print("--------------------------------------------------")

def print_all_vars():
	print("Keys found in globals().items()")
	dunder_vars = {key: value for key, value in globals().items() if key.startswith('__')}
	for key, value in dunder_vars.items():
		# print(f"{key}: {value}")
		print(f"{key}")

	print("Selected keys from globals().items():")
	print(f"__sls__: {__sls__}")
	print(f"__file__: {__file__}")
	print(f"__package__: {__package__}")
#	 print("--------------------------------------------------")
#	 print("__salt__")
#	 print("--------------------------------------------------")
#	 for key, value in __salt__.items():
#		 print(f"{key}: {value}")
	# print()
	print("--------------------------------------------------")
	print("__pillar__")
	print("--------------------------------------------------")
	print()
	for key, value in __pillar__.items():
		print(f"{key}: {value}")
		print(f"--------------------------")
	print()
	print("--------------------------------------------------")
	print("__grains__")
	print("--------------------------------------------------")
	print()
	for key, value in __grains__.items():
		print(f"{key}: {value}")
		print(f"--------------------------")
	print("--------------------------------------------------")
	print("__opts__")
	print("--------------------------------------------------")
	for key, value in __opts__.items():
		print(f"{key}: {value}")
		print(f"--------------------------")

def wget():
	os = __grains__.get('os')
	os_major_release = __grains__.get('osmajorrelease')
	print("grain[os]", os)
	print("grain[id]", __grains__.get('id'))
	if os == "Debian":
		return ['wget']
	elif os == 'Fedora' and os_major_release == 39:
		return ['wget']
	elif os == 'Fedora' and (os_major_release == 40 or os_major_release == 41):
		return ['wget2']
	else:
		return []

def run():
	print_all_vars()
	# print(f"os.getcwd(): {os.getcwd()}")
	# print("file", __file__)
	#
	# print("base", Path(__file__).parent.parent)
	# ls(Path(__file__).parent.parent)
	# # Print the full version string
	# print("Python version:", sys.version)
	# # Or use version_info for a tuple of version numbers
	# print("Version info:", sys.version_info)
	# print("Content of sys.path:")
	# for path in sys.path:
	# 	print(path)

	config = {}
	state_id = f'{__sls__}-fake-state'
	config |= {
		state_id: {
			'cmd.run': [
				{ 'name': "echo Hello" }
			]
		}
	}
	# pylib.test()
	return config
